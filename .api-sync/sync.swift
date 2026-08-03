#!/usr/bin/env swift
//
// sync.swift
//
// Deterministic spec-sync patcher for the BlindPay Swift SDK. Replaces the
// AI-driven api-sync pipeline: reconciles committed source against the spec
// via .api-sync/spec-map.json (curated schema/enum -> SDK symbol mapping),
// applies only mechanically-safe additive changes, and hard-fails on anything
// that needs a human decision.
//
// Modes:
//   swift .api-sync/sync.swift --check
//       State reconciliation against .api-sync/spec-snapshot.json. Exit 1 with
//       precise messages on any pending drift or needs-human finding; silent
//       (exit 0) when clean.
//   swift .api-sync/sync.swift --apply [--spec path] [--report path]
//       Diffs .api-sync/spec-snapshot.json (old) against --spec (new, default
//       .api-sync/spec-current.json) for version-bump/removal purposes, then
//       reconciles source against the new spec. Hard fails (no writes) on any
//       needs-human finding. Otherwise applies every applicable edit, refreshes
//       the snapshot to match the new spec, and writes --report as JSON.
//   swift .api-sync/sync.swift --validate-map
//       Verifies every spec-map.json entry resolves: SDK file exists, SDK
//       symbol is found in source, and the spec locator resolves against the
//       snapshot.
//
// No third-party dependencies (Foundation only), mirroring check-contract.swift.

import Foundation

// MARK: - CLI args

enum Mode { case check, apply, validateMap, coverageReport }

var mode: Mode = .check
var snapshotPath = ".api-sync/spec-snapshot.json"
var specPath = ".api-sync/spec-current.json"
var sourcesPath = "Sources/BlindPay/Models"
// Endpoint literals live in both Services/ (nested resource services) and
// Core/BlindPay.swift (the flat facade, which mirrors -- and in several
// documented cases, no longer mirrors -- the nested services). Scanning the
// whole package root catches both; Models/ files never contain "endpoint:"
// literals, so including them is harmless.
var servicesPath = "Sources/BlindPay"
var specMapPath = ".api-sync/spec-map.json"
var unmodeledPath = ".api-sync/unmodeled.json"
var knownDivergencesPath = ".api-sync/known-divergences.json"
var reportPath: String? = nil

do {
    let args = CommandLine.arguments
    var i = 1
    while i < args.count {
        switch args[i] {
        case "--check": mode = .check
        case "--apply": mode = .apply
        case "--validate-map": mode = .validateMap
        case "--coverage-report": mode = .coverageReport
        case "--snapshot": i += 1; if i < args.count { snapshotPath = args[i] }
        case "--spec": i += 1; if i < args.count { specPath = args[i] }
        case "--sources": i += 1; if i < args.count { sourcesPath = args[i] }
        case "--services": i += 1; if i < args.count { servicesPath = args[i] }
        case "--spec-map": i += 1; if i < args.count { specMapPath = args[i] }
        case "--unmodeled": i += 1; if i < args.count { unmodeledPath = args[i] }
        case "--known-divergences": i += 1; if i < args.count { knownDivergencesPath = args[i] }
        case "--report": i += 1; if i < args.count { reportPath = args[i] }
        default: break
        }
        i += 1
    }
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write("sync: \(message)\n".data(using: .utf8)!)
    exit(2)
}

// MARK: - JSON helpers

func loadJSON(_ path: String) -> Any? {
    guard let data = FileManager.default.contents(atPath: path) else { return nil }
    return try? JSONSerialization.jsonObject(with: data)
}

func loadJSONRequired(_ path: String) -> Any {
    guard let obj = loadJSON(path) else { fail("could not read/parse JSON at \(path)") }
    return obj
}

extension Dictionary where Key == String {
    func str(_ key: String) -> String? { self[key] as? String }
    func dict(_ key: String) -> [String: Any]? { self[key] as? [String: Any] }
    func arr(_ key: String) -> [Any]? { self[key] as? [Any] }
}

// MARK: - Spec locator resolution
//
// A locator is either:
//   - a plain schema name ("PayoutOut"), optionally with a dotted nested path
//     ("PayoutOut.tracking_payment", "CustomerOut.owners[].tax_type") walking
//     into nested object/array-item properties, or
//   - an inline path-operation locator ("POST /v1/instances/{id}/quotes/fx#requestBody"
//     or "...#response.200"), for spec bodies with no named component schema.

struct SpecNode {
    let raw: [String: Any]
}

func schemas(of spec: [String: Any]) -> [String: Any] {
    return (spec.dict("components")?.dict("schemas")) ?? [:]
}

func paths(of spec: [String: Any]) -> [String: Any] {
    return (spec["paths"] as? [String: Any]) ?? [:]
}

/// Returns the properties dictionary of a resolved node, auto-unwrapping a
/// bare array schema (`{"type": "array", "items": {...}}`) into its item's
/// properties when the node itself has none.
func propertiesOf(_ node: [String: Any]) -> [String: Any] {
    if let props = node.dict("properties") { return props }
    if let items = node.dict("items"), let props = items.dict("properties") { return props }
    return [:]
}

func requiredOf(_ node: [String: Any]) -> Set<String> {
    if let req = node["required"] as? [Any] {
        return Set(req.compactMap { $0 as? String })
    }
    if let items = node.dict("items"), let req = items["required"] as? [Any] {
        return Set(req.compactMap { $0 as? String })
    }
    return []
}

enum LocatorError: Error, CustomStringConvertible {
    case notFound(String)
    var description: String {
        switch self { case .notFound(let s): return s }
    }
}

func resolveLocator(_ locator: String, in spec: [String: Any]) throws -> [String: Any] {
    let httpMethods = ["GET ", "POST ", "PUT ", "DELETE ", "PATCH "]
    if httpMethods.contains(where: { locator.hasPrefix($0) }) {
        guard let hashRange = locator.range(of: "#") else {
            throw LocatorError.notFound("malformed inline locator (missing #): \(locator)")
        }
        let methodPath = String(locator[locator.startIndex..<hashRange.lowerBound])
        let tail = String(locator[hashRange.upperBound...])
        guard let spaceRange = methodPath.range(of: " ") else {
            throw LocatorError.notFound("malformed inline locator (missing method/path split): \(locator)")
        }
        let method = String(methodPath[methodPath.startIndex..<spaceRange.lowerBound]).lowercased()
        let path = String(methodPath[spaceRange.upperBound...])
        guard let op = paths(of: spec)[path] as? [String: Any], let opForMethod = op[method] as? [String: Any] else {
            throw LocatorError.notFound("operation not found for locator: \(locator)")
        }
        if tail == "requestBody" {
            guard let node = opForMethod.dict("requestBody")?.dict("content")?.dict("application/json")?.dict("schema") else {
                throw LocatorError.notFound("requestBody not found for locator: \(locator)")
            }
            return node
        } else if tail.hasPrefix("response.") {
            var code = String(tail.dropFirst("response.".count))
            var unwrapArray = false
            if code.hasSuffix("[]") { unwrapArray = true; code = String(code.dropLast(2)) }
            guard var node = opForMethod.dict("responses")?.dict(code)?.dict("content")?.dict("application/json")?.dict("schema") else {
                throw LocatorError.notFound("response \(code) not found for locator: \(locator)")
            }
            if unwrapArray {
                guard let items = node.dict("items") else {
                    throw LocatorError.notFound("response \(code) is not an array for locator: \(locator)")
                }
                node = items
            }
            return node
        } else {
            throw LocatorError.notFound("unknown locator tail \"\(tail)\" in: \(locator)")
        }
    }

    // Plain schema name, optionally with a dotted nested path.
    let parts = locator.components(separatedBy: ".")
    guard var node = schemas(of: spec)[parts[0]] as? [String: Any] else {
        throw LocatorError.notFound("schema not found: \(parts[0])")
    }
    for part in parts.dropFirst() {
        var key = part
        var isArrayItem = false
        if key.hasSuffix("[]") { isArrayItem = true; key = String(key.dropLast(2)) }
        guard let prop = propertiesOf(node)[key] as? [String: Any] else {
            throw LocatorError.notFound("property \"\(key)\" not found while resolving \(locator)")
        }
        if isArrayItem {
            guard let items = prop.dict("items") else {
                throw LocatorError.notFound("property \"\(key)\" is not an array while resolving \(locator)")
            }
            node = items
        } else {
            node = prop
        }
    }
    return node
}

/// Extracts a raw string enum value set from a resolved node, handling the
/// `{"items": true}` (array-of-enum, e.g. WebhookEndpointIn.events) shape.
func enumValues(_ node: [String: Any], itemsFlag: Bool) -> Set<String> {
    if itemsFlag {
        guard let items = node.dict("items"), let vals = items["enum"] as? [Any] else { return [] }
        return Set(vals.compactMap { $0 as? String })
    }
    guard let vals = node["enum"] as? [Any] else { return [] }
    return Set(vals.compactMap { $0 as? String })
}

/// Builds the full locator string for a spec-map `enums[]` entry's "spec" object,
/// which is either {schema, property, items?} (named schema, possibly a dotted/
/// bracketed nested path in `property`) or {locator, property?, items?} (inline
/// path-operation body). Returns nil if malformed.
func fullEnumLocator(_ specSpec: [String: Any]) -> String? {
    if let schema = specSpec.str("schema") {
        return schema + (specSpec.str("property").map { "." + $0 } ?? "")
    }
    if let loc = specSpec.str("locator") {
        // Inline locators resolve to a requestBody/response node first; the
        // optional nested `property` is then a dotted path *within* that node,
        // so we cannot fold it into the "#..." string. Resolve in two steps.
        return loc
    }
    return nil
}

/// Resolves a spec-map `enums[]` entry's spec anchor to its raw enum value set.
func resolveEnumAnchorValues(_ specSpec: [String: Any], in spec: [String: Any]) throws -> Set<String> {
    let itemsFlag = (specSpec["items"] as? Bool) ?? false
    guard let base = fullEnumLocator(specSpec) else {
        throw LocatorError.notFound("malformed enum spec anchor: \(specSpec)")
    }
    var node = try resolveLocator(base, in: spec)
    if specSpec.str("locator") != nil, let prop = specSpec.str("property") {
        for part in prop.components(separatedBy: ".") {
            guard let sub = propertiesOf(node)[part] as? [String: Any] else {
                throw LocatorError.notFound("property \"\(prop)\" not found while resolving \(base)#\(prop)")
            }
            node = sub
        }
    }
    return enumValues(node, itemsFlag: itemsFlag)
}

/// Human-readable locator string for messages (schema.property or locator#property).
func describeEnumAnchor(_ specSpec: [String: Any]) -> String {
    if let schema = specSpec.str("schema") {
        return schema + (specSpec.str("property").map { "." + $0 } ?? "")
    }
    if let loc = specSpec.str("locator") {
        return loc + (specSpec.str("property").map { "#" + $0 } ?? "")
    }
    return "<malformed>"
}

// MARK: - Source scanning

struct ScannedProperty {
    var name: String
    var wireKey: String
    var declLineIndex: Int   // index into ScannedType.lines of the `public let` line
    var typeText: String     // raw Swift type text, e.g. "String?" or "Int"
}

enum EncodeStyle { case none, encodeIfPresent, ifLetBlock }

final class ScannedType {
    var name: String = ""
    var kind: String = ""       // "struct" | "enum"
    var file: String = ""
    var lines: [String] = []
    var bodyStartLine: Int = 0 // index of the line containing the opening "{"
    var bodyEndLine: Int = 0   // index of the line containing the matching closing "}"
    var indentUnit: String = "    "

    // struct-specific
    var properties: [ScannedProperty] = []
    var hasCodingKeys: Bool = false
    var codingKeysBodyStart: Int = -1
    var codingKeysBodyEnd: Int = -1
    var codingKeysWireKeyOf: [String: String] = [:]  // propName -> wireKey (only entries physically present)
    var initBodyStart: Int = -1
    var initBodyEnd: Int = -1
    var initSignatureEndLine: Int = -1 // line index containing the ")" that closes the init parameter list
    var encodeStyle: EncodeStyle = .none
    var encodeBodyStart: Int = -1
    var encodeBodyEnd: Int = -1

    // enum-specific
    var rawValues: [(name: String, value: String, lineIndex: Int)] = []
}

let typeDeclRegex = try! NSRegularExpression(pattern: #"^(\s*)(?:public\s+)?(?:final\s+)?(struct|class|enum)\s+(\w+)"#)
let letDeclRegex = try! NSRegularExpression(pattern: #"^(\s*)public\s+let\s+(\w+)\s*:\s*([^\n=]+?)\s*(?:=.*)?$"#)
let codingKeyEqRegex = try! NSRegularExpression(pattern: #"^(\s*)case\s+(\w+)\s*=\s*"([^"]*)""#)
let codingKeyBareRegex = try! NSRegularExpression(pattern: #"^(\s*)case\s+((?:\w+\s*,\s*)*\w+)\s*$"#)
let enumCaseEqRegex = try! NSRegularExpression(pattern: #"^(\s*)case\s+`?(\w+)`?\s*=\s*"([^"]*)""#)
let initDeclRegex = try! NSRegularExpression(pattern: #"^(\s*)public\s+init\s*\("#)

func matchGroups(_ regex: NSRegularExpression, _ line: String) -> [String]? {
    let range = NSRange(line.startIndex..<line.endIndex, in: line)
    guard let m = regex.firstMatch(in: line, range: range) else { return nil }
    var groups: [String] = []
    for i in 0..<m.numberOfRanges {
        if let r = Range(m.range(at: i), in: line) {
            groups.append(String(line[r]))
        } else {
            groups.append("")
        }
    }
    return groups
}

func swiftFiles(under path: String) -> [String] {
    guard let enumerator = FileManager.default.enumerator(atPath: path) else { return [] }
    var files: [String] = []
    for item in enumerator {
        guard let relative = item as? String, relative.hasSuffix(".swift") else { continue }
        files.append(path + "/" + relative)
    }
    return files.sorted()
}

func braceDelta(_ line: String) -> Int {
    line.filter { $0 == "{" }.count - line.filter { $0 == "}" }.count
}

/// Scans every .swift file under `path` and returns every TOP-LEVEL struct/enum
/// declaration (not nested types like CodingKeys), keyed by symbol name.
///
/// Pass 1 walks a brace-depth type stack (mirroring check-contract.swift) to
/// find each top-level type's body range, its directly-owned `public let`
/// properties, its enum raw values, and its nested CodingKeys entries. Pass 2
/// locates the `init(...)` and `encode(to:)` callable ranges by brace-matching
/// from the already-known body range, since those aren't type declarations and
/// so fall outside the pass-1 stack.
func scanSources(under path: String) -> [String: ScannedType] {
    var results: [String: ScannedType] = [:]

    for file in swiftFiles(under: path) {
        guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
        let lines = content.components(separatedBy: "\n")

        struct Frame { var name: String; var depthAtOpen: Int; var scanned: ScannedType? }
        var stack: [Frame] = []
        var depth = 0

        for (idx, line) in lines.enumerated() {
            if let g = matchGroups(typeDeclRegex, line) {
                let indent = g[1]
                let kind = g[2]
                let name = g[3]
                var scanned: ScannedType? = nil
                if stack.isEmpty {
                    let t = ScannedType()
                    t.name = name
                    t.kind = kind
                    t.file = file
                    t.lines = lines
                    t.bodyStartLine = idx
                    t.indentUnit = indent.isEmpty ? "    " : indent + "    "
                    results[name] = t
                    scanned = t
                }
                stack.append(Frame(name: name, depthAtOpen: depth, scanned: scanned))
            } else if let top = stack.last, let owner = top.scanned {
                // Directly inside the top-level type itself (not a nested type).
                if let g = matchGroups(letDeclRegex, line) {
                    owner.properties.append(ScannedProperty(name: g[2], wireKey: g[2], declLineIndex: idx, typeText: g[3].trimmingCharacters(in: .whitespaces)))
                }
                if owner.kind == "enum", let g = matchGroups(enumCaseEqRegex, line) {
                    owner.rawValues.append((name: g[2], value: g[3], lineIndex: idx))
                }
            } else if stack.count >= 2, stack.last!.name == "CodingKeys" {
                guard let owner = stack[stack.count - 2].scanned else { continue }
                owner.hasCodingKeys = true
                if let g = matchGroups(codingKeyEqRegex, line) {
                    owner.codingKeysWireKeyOf[g[2]] = g[3]
                } else if let g = matchGroups(codingKeyBareRegex, line) {
                    for name in g[2].components(separatedBy: ",").map({ $0.trimmingCharacters(in: .whitespaces) }) {
                        owner.codingKeysWireKeyOf[name] = name
                    }
                }
            }

            depth += braceDelta(line)
            while let last = stack.last, depth <= last.depthAtOpen {
                let popped = stack.removeLast()
                if let owner = popped.scanned { owner.bodyEndLine = idx }
            }
        }
    }

    for (_, t) in results {
        if t.kind != "struct" { continue }
        (t.initSignatureEndLine, t.initBodyStart, t.initBodyEnd) = findCallableRanges(t.lines, containingLineWith: "public init(", from: t.bodyStartLine, to: t.bodyEndLine)
        if (t.bodyStartLine...t.bodyEndLine).contains(where: { t.lines[$0].contains("func encode(to encoder") }) {
            let (_, bodyStart, bodyEnd) = findCallableRanges(t.lines, containingLineWith: "func encode(to encoder", from: t.bodyStartLine, to: t.bodyEndLine)
            t.encodeBodyStart = bodyStart
            t.encodeBodyEnd = bodyEnd
            if bodyStart != -1, bodyEnd != -1 {
                t.encodeStyle = (bodyStart...bodyEnd).contains { t.lines[$0].contains("encodeIfPresent(") } ? .encodeIfPresent : .ifLetBlock
            }
        }
    }

    return results
}

/// Finds (signatureEndLine, bodyStartLine, bodyEndLine) for a callable (init or
/// func) whose declaration line contains `marker`, searching only within
/// [from, to]. signatureEndLine is the line containing the ")" that closes the
/// parameter list (may equal the line with the opening "{"). bodyStartLine is
/// the line with the opening "{"; bodyEndLine is the line with the matching "}".
func findCallableRanges(_ lines: [String], containingLineWith marker: String, from: Int, to: Int) -> (Int, Int, Int) {
    guard let declLine = (from...to).first(where: { lines[$0].contains(marker) }) else { return (-1, -1, -1) }
    // Walk forward from declLine to find the line with the first "{" at
    // paren-depth 0 (end of parameter list) -- this is also bodyStart.
    var parenDepth = 0
    var sigEnd = -1
    var bodyStart = -1
    outer: for i in declLine...to {
        for ch in lines[i] {
            if ch == "(" { parenDepth += 1 }
            if ch == ")" { parenDepth -= 1 }
            if ch == "{" && parenDepth <= 0 {
                bodyStart = i
                sigEnd = i
                break outer
            }
        }
    }
    if bodyStart == -1 { return (-1, -1, -1) }
    var depth = 0
    var bodyEnd = -1
    for i in bodyStart...to {
        depth += braceDelta(lines[i])
        if depth == 0 { bodyEnd = i; break }
    }
    return (sigEnd, bodyStart, bodyEnd)
}

// MARK: - Identifier derivation

let swiftKeywords: Set<String> = ["as", "do", "is", "in", "for", "case", "self", "Self", "class", "struct", "enum", "func", "var", "let", "if", "else", "return", "import", "public", "private", "internal", "static", "protocol", "extension", "guard", "switch", "default", "break", "continue", "true", "false", "nil", "try", "catch", "throw", "throws", "async", "await", "operator", "where", "repeat", "while"]

/// Derives a lowerCamelCase Swift identifier from a wire-format enum raw value
/// (snake_case or dotted.camelCase), matching this repo's existing convention
/// (e.g. WebhookEvent's "customer.new" -> customerNew; BusinessIndustry's bare
/// numeric NAICS codes get an "n" prefix, e.g. "446120" -> n446120).
func deriveCaseName(from value: String) -> String {
    let parts = value.split(whereSeparator: { $0 == "_" || $0 == "." || $0 == " " || $0 == "-" })
    if parts.isEmpty { return "_empty" }
    if parts.count == 1, let first = parts.first, first.first?.isNumber == true {
        return "n" + first
    }
    var result = ""
    for (i, part) in parts.enumerated() {
        let lower = part.lowercased()
        if i == 0 {
            result += lower
        } else {
            result += lower.prefix(1).uppercased() + lower.dropFirst()
        }
    }
    if swiftKeywords.contains(result) {
        return "`\(result)`"
    }
    return result
}

/// Derives a lowerCamelCase Swift property name from a snake_case wire key.
func deriveCamelName(from wireKey: String) -> String {
    let parts = wireKey.split(separator: "_")
    guard !parts.isEmpty else { return wireKey }
    var result = String(parts[0])
    for part in parts.dropFirst() {
        result += part.prefix(1).uppercased() + part.dropFirst()
    }
    return result
}

/// Swift type text for a JSON Schema property node, used only when generating
/// a brand-new optional property declaration.
func swiftType(for node: [String: Any]) -> String {
    var t: Any? = node["type"]
    if let arr = t as? [Any] {
        t = arr.first(where: { ($0 as? String) != "null" })
    }
    switch t as? String {
    case "integer": return "Int?"
    case "number": return "Double?"
    case "boolean": return "Bool?"
    case "array": return "[String]?"
    case "object": return "[String: String]?"
    default: return "String?"
    }
}

// MARK: - Findings

enum FindingKind: String { case applicableEnumCase = "applicable-enum-case", applicableField = "applicable-field", needsHuman = "needs-human" }

struct Finding {
    let kind: FindingKind
    let message: String
    // Applicable-enum-case payload:
    var enumSymbol: String? = nil
    var enumValue: String? = nil
    // Applicable-field payload:
    var fieldSymbol: String? = nil
    var fieldName: String? = nil
    var fieldWireKey: String? = nil
    var fieldTypeText: String? = nil
}

// MARK: - Load configuration

let specMapRaw = loadJSONRequired(specMapPath) as! [String: Any]
let specMapEnums = (specMapRaw["enums"] as? [[String: Any]]) ?? []
let specMapTypes = (specMapRaw["types"] as? [[String: Any]]) ?? []

let unmodeledRaw = (loadJSON(unmodeledPath) as? [[String: Any]]) ?? []
struct UnmodeledEntry { let schema: String; let field: String }
let unmodeledEntries: [UnmodeledEntry] = unmodeledRaw.compactMap {
    guard let schema = $0.str("schema"), let field = $0.str("field") else { return nil }
    return UnmodeledEntry(schema: schema, field: field)
}
let unmodeledSet = Set(unmodeledEntries.map { "\($0.schema)\u{0}\($0.field)" })

let knownDivergencesRaw = (loadJSON(knownDivergencesPath) as? [[String: Any]]) ?? []
struct DivergenceEntry { let enumName: String; let values: Set<String> }
let divergenceEntries: [DivergenceEntry] = knownDivergencesRaw.compactMap {
    guard let enumName = $0.str("enum") else { return nil }
    var values = Set<String>()
    if let v = $0.str("specValue") { values.insert(v) }
    if let arr = $0.arr("specValues") { values.formUnion(arr.compactMap { $0 as? String }) }
    return DivergenceEntry(enumName: enumName, values: values)
}
func isKnownDivergence(enumName: String, value: String) -> Bool {
    divergenceEntries.contains { $0.enumName == enumName && $0.values.contains(value) }
}

// Amount-shaped fields on the three cents-converting hand-rolled encoders:
// adding one of these mechanically would silently guess at unit conversion,
// so it is routed to NEEDS_HUMAN instead of auto-applied. Plain String/Bool/
// enum optional fields on these same structs remain safely mechanical.
let amountConvertingEncoders: Set<String> = ["CreateQuoteInput", "GetFxRateInput", "CreatePayinQuoteInput"]
func looksAmountShaped(name: String, typeText: String) -> Bool {
    let n = name.lowercased()
    let t = typeText.replacingOccurrences(of: "?", with: "")
    return (t == "Double" || t == "Int") && (n.contains("amount") || n.contains("fee"))
}

// MARK: - Reconciliation

func reconcile(spec: [String: Any], scanned: [String: ScannedType]) -> (applicable: [Finding], needsHuman: [Finding]) {
    var applicable: [Finding] = []
    var needsHuman: [Finding] = []

    // Enums
    for entry in specMapEnums {
        guard let specSpec = entry.dict("spec"), let sdkSpec = entry.dict("sdk"),
              let symbol = sdkSpec.str("symbol") else { continue }
        let locator = describeEnumAnchor(specSpec)

        guard let scannedType = scanned[symbol], scannedType.kind == "enum" else {
            needsHuman.append(Finding(kind: .needsHuman, message: "spec-map enum \"\(symbol)\" not found in sources (anchor not found)"))
            continue
        }

        do {
            let specVals = try resolveEnumAnchorValues(specSpec, in: spec)
            let sdkVals = Set(scannedType.rawValues.map { $0.value })
            let missing = specVals.subtracting(sdkVals)
            for value in missing.sorted() {
                if isKnownDivergence(enumName: symbol, value: value) { continue }
                applicable.append(Finding(kind: .applicableEnumCase,
                                           message: "enum \(symbol) is missing member \"\(value)\" (spec: \(locator))",
                                           enumSymbol: symbol, enumValue: value))
            }
        } catch {
            needsHuman.append(Finding(kind: .needsHuman, message: "spec-map enum anchor not found: \(locator) (\(error))"))
        }
    }

    // Types
    for entry in specMapTypes {
        guard let locator = entry.str("spec"), let sdkSites = entry["sdk"] as? [[String: Any]] else { continue }
        let node: [String: Any]
        do {
            node = try resolveLocator(locator, in: spec)
        } catch {
            needsHuman.append(Finding(kind: .needsHuman, message: "spec-map type anchor not found: \(locator) (\(error))"))
            continue
        }
        let specProps = propertiesOf(node)
        if specProps.isEmpty { continue }
        let required = requiredOf(node)

        for site in sdkSites {
            guard let symbol = site.str("symbol") else { continue }
            guard let scannedType = scanned[symbol], scannedType.kind == "struct" else {
                needsHuman.append(Finding(kind: .needsHuman, message: "spec-map type \"\(symbol)\" (for \(locator)) not found in sources (anchor not found)"))
                continue
            }
            let modeledWireKeys = Set(scannedType.properties.map { prop -> String in
                scannedType.codingKeysWireKeyOf[prop.name] ?? prop.name
            })
            for (propName, propNode) in specProps.sorted(by: { $0.key < $1.key }) {
                if modeledWireKeys.contains(propName) { continue }
                if unmodeledSet.contains("\(locator)\u{0}\(propName)") { continue }
                if required.contains(propName) {
                    needsHuman.append(Finding(kind: .needsHuman,
                        message: "\(symbol) is missing REQUIRED spec property \"\(propName)\" (spec: \(locator)); adding a required memberwise-init parameter would break existing callers -- needs a human decision"))
                    continue
                }
                let camelName = deriveCamelName(from: propName)
                let typeText = swiftType(for: propNode as? [String: Any] ?? [:])
                if amountConvertingEncoders.contains(symbol) && looksAmountShaped(name: camelName, typeText: typeText) {
                    needsHuman.append(Finding(kind: .needsHuman,
                        message: "\(symbol).\(camelName) (spec property \"\(propName)\") looks amount-shaped on a cents-converting hand-rolled encoder; needs a human decision on unit conversion, not a mechanical add"))
                    continue
                }
                applicable.append(Finding(kind: .applicableField,
                    message: "\(symbol) is missing optional spec property \"\(propName)\" (spec: \(locator))",
                    fieldSymbol: symbol, fieldName: camelName, fieldWireKey: propName, fieldTypeText: typeText))
            }
        }
    }

    return (applicable, needsHuman)
}

// MARK: - Removal / new-schema / new-operation / type-change detection (--apply only)

func mappedSchemaBaseNames() -> Set<String> {
    var names = Set<String>()
    for entry in specMapTypes {
        guard let locator = entry.str("spec") else { continue }
        if locator.hasPrefix("GET ") || locator.hasPrefix("POST ") || locator.hasPrefix("PUT ") || locator.hasPrefix("DELETE ") || locator.hasPrefix("PATCH ") { continue }
        names.insert(String(locator.split(separator: ".").first ?? Substring(locator)))
    }
    if let ignore = specMapRaw.dict("ignore"), let ignoreSchemas = ignore["schemas"] as? [[String: Any]] {
        for s in ignoreSchemas { if let n = s.str("schema") { names.insert(n) } }
    }
    return names
}

func detectStructuralChanges(old: [String: Any], new: [String: Any]) -> [Finding] {
    var findings: [Finding] = []
    let oldSchemas = schemas(of: old)
    let newSchemas = schemas(of: new)
    let known = mappedSchemaBaseNames()

    for name in newSchemas.keys.sorted() where oldSchemas[name] == nil {
        if known.contains(name) { continue }
        findings.append(Finding(kind: .needsHuman, message: "new schema \"\(name)\" present in spec, not present in spec-map.json (types or ignore) -- needs mapping"))
    }

    let oldPaths = paths(of: old)
    let newPaths = paths(of: new)
    for (path, newOps) in newPaths.sorted(by: { $0.key < $1.key }) {
        guard let newOpsDict = newOps as? [String: Any] else { continue }
        let oldOpsDict = oldPaths[path] as? [String: Any] ?? [:]
        for method in newOpsDict.keys.sorted() where ["get", "post", "put", "delete", "patch"].contains(method) {
            if oldOpsDict[method] == nil {
                findings.append(Finding(kind: .needsHuman, message: "new operation \"\(method.uppercased()) \(path)\" present in spec -- needs mapping/naming decision"))
            }
        }
    }
    for (path, oldOps) in oldPaths.sorted(by: { $0.key < $1.key }) {
        guard let oldOpsDict = oldOps as? [String: Any] else { continue }
        let newOpsDict = newPaths[path] as? [String: Any] ?? [:]
        for method in oldOpsDict.keys.sorted() where ["get", "post", "put", "delete", "patch"].contains(method) {
            if newOpsDict[method] == nil {
                findings.append(Finding(kind: .needsHuman, message: "operation \"\(method.uppercased()) \(path)\" removed from spec -- breaking change, needs a human decision (major bump)"))
            }
        }
    }

    // Property/enum removals and type/required changes on every mapped locator.
    for entry in specMapTypes {
        guard let locator = entry.str("spec") else { continue }
        guard let oldNode = try? resolveLocator(locator, in: old) else { continue }
        guard let newNode = try? resolveLocator(locator, in: new) else {
            findings.append(Finding(kind: .needsHuman, message: "spec locator \"\(locator)\" no longer resolves in the new spec -- needs a human decision"))
            continue
        }
        let oldProps = propertiesOf(oldNode)
        let newProps = propertiesOf(newNode)
        let oldRequired = requiredOf(oldNode)
        let newRequired = requiredOf(newNode)
        for name in oldProps.keys.sorted() where newProps[name] == nil {
            findings.append(Finding(kind: .needsHuman, message: "property \"\(name)\" removed from \(locator) -- breaking change, needs a human decision (major bump)"))
        }
        for name in oldProps.keys.sorted() where newProps[name] != nil {
            if oldRequired.contains(name) != newRequired.contains(name) {
                findings.append(Finding(kind: .needsHuman, message: "required-ness of \"\(name)\" on \(locator) changed -- needs a human decision"))
            }
        }
    }
    for entry in specMapEnums {
        guard let specSpec = entry.dict("spec"), let sdkSpec = entry.dict("sdk"), let symbol = sdkSpec.str("symbol") else { continue }
        guard let oldVals = try? resolveEnumAnchorValues(specSpec, in: old) else { continue }
        guard let newVals = try? resolveEnumAnchorValues(specSpec, in: new) else { continue }
        let locator = describeEnumAnchor(specSpec)
        for v in oldVals.subtracting(newVals).sorted() {
            findings.append(Finding(kind: .needsHuman, message: "enum member \"\(v)\" removed from \(locator) (mapped to \(symbol)) -- breaking change, needs a human decision (major bump)"))
        }
    }

    return findings
}

enum Bump: String { case none, patch, minor }

func classifyBump(old: [String: Any], new: [String: Any]) -> Bump {
    if old.count == new.count, NSDictionary(dictionary: old).isEqual(to: new) { return .none }

    let oldPaths = paths(of: old)
    let newPaths = paths(of: new)
    if !NSDictionary(dictionary: oldPaths).isEqual(to: newPaths) { return .minor }

    for entry in specMapEnums {
        guard let specSpec = entry.dict("spec") else { continue }
        guard let oldVals = try? resolveEnumAnchorValues(specSpec, in: old) else { continue }
        guard let newVals = try? resolveEnumAnchorValues(specSpec, in: new) else { continue }
        if oldVals != newVals { return .minor }
    }

    let oldSchemas = schemas(of: old)
    let newSchemas = schemas(of: new)
    if Set(oldSchemas.keys) != Set(newSchemas.keys) { return .minor }

    return .patch
}

// MARK: - Apply

func indentOf(_ line: String) -> String {
    String(line.prefix(while: { $0 == " " }))
}

/// Applies every field/enum finding to the in-memory source of each affected
/// file, then writes files back. Mutates `scanned` line arrays as it goes so
/// multiple findings against the same file compose correctly; re-scans line
/// indices are stable because we always insert relative to a brace line found
/// fresh from the current in-memory content right before mutating.
func applyFindings(_ findings: [Finding]) {
    var fileLines: [String: [String]] = [:]
    var fileOfSymbol: [String: String] = [:]
    for entry in specMapTypes {
        for site in (entry["sdk"] as? [[String: Any]]) ?? [] {
            if let symbol = site.str("symbol"), let file = site.str("file") {
                fileOfSymbol[symbol] = file
            }
        }
    }
    for entry in specMapEnums {
        if let sdkSpec = entry.dict("sdk"), let symbol = sdkSpec.str("symbol"), let file = sdkSpec.str("file") {
            fileOfSymbol[symbol] = file
        }
    }

    func linesFor(_ file: String) -> [String] {
        if let cached = fileLines[file] { return cached }
        let content = (try? String(contentsOfFile: file, encoding: .utf8)) ?? ""
        let lines = content.components(separatedBy: "\n")
        fileLines[file] = lines
        return lines
    }

    // Enum case insertions.
    for finding in findings where finding.kind == .applicableEnumCase {
        guard let symbol = finding.enumSymbol, let value = finding.enumValue, let file = fileOfSymbol[symbol] else { continue }
        var lines = linesFor(file)
        guard let declIdx = lines.firstIndex(where: { matchGroups(typeDeclRegex, $0)?[3] == symbol }) else { continue }
        var depth = 0
        var closeIdx = -1
        var lastCaseIdx = declIdx
        for i in declIdx..<lines.count {
            depth += braceDelta(lines[i])
            if i > declIdx, lines[i].trimmingCharacters(in: .whitespaces).hasPrefix("case ") { lastCaseIdx = i }
            if depth == 0 && i > declIdx { closeIdx = i; break }
        }
        guard closeIdx != -1 else { continue }
        let indent = indentOf(lines[lastCaseIdx])
        let caseName = deriveCaseName(from: value)
        let newLine = "\(indent)case \(caseName) = \"\(value)\""
        lines.insert(newLine, at: lastCaseIdx + 1)
        fileLines[file] = lines
    }

    // Field insertions (declaration + CodingKeys entry + init parameter/assignment + optional encode line).
    for finding in findings where finding.kind == .applicableField {
        guard let symbol = finding.fieldSymbol, let name = finding.fieldName,
              let wireKey = finding.fieldWireKey, let typeText = finding.fieldTypeText,
              let file = fileOfSymbol[symbol] else { continue }
        var lines = linesFor(file)
        guard let declIdx = lines.firstIndex(where: { matchGroups(typeDeclRegex, $0)?[3] == symbol }) else { continue }

        var depth = 0
        var closeIdx = -1
        for i in declIdx..<lines.count {
            depth += braceDelta(lines[i])
            if depth == 0 && i > declIdx { closeIdx = i; break }
        }
        guard closeIdx != -1 else { continue }

        // 1. Property declaration: insert right before the `public init(` line
        //    (or, if none is found, right before the closing brace), copying
        //    indentation from the nearest sibling `public let` line.
        let initLineIdx = (declIdx...closeIdx).first { lines[$0].contains("public init(") }
        var sampleLetIdx: Int? = nil
        for i in stride(from: closeIdx - 1, through: declIdx, by: -1) {
            if matchGroups(letDeclRegex, lines[i]) != nil { sampleLetIdx = i; break }
        }
        let letIndent = sampleLetIdx.map { indentOf(lines[$0]) } ?? "    "
        let insertAt = initLineIdx ?? closeIdx
        let declLine = "\(letIndent)public let \(name): \(typeText)"
        // A single trailing blank line separates the new property from
        // `public init(`; only add a leading blank if the line above the
        // insertion point isn't already blank, to avoid a double gap.
        let precededByBlank = insertAt > declIdx && lines[insertAt - 1].trimmingCharacters(in: .whitespaces).isEmpty
        let insertion: [String] = precededByBlank ? [declLine, ""] : ["", declLine, ""]
        lines.insert(contentsOf: insertion, at: insertAt)
        var shift = insertion.count

        // 2. CodingKeys entry (only if the struct already has a CodingKeys block).
        var codingKeysBlockStart = -1
        var codingKeysBlockEnd = -1
        var d2 = 0
        var inCK = false
        for i in declIdx..<(closeIdx + shift) {
            if !inCK, matchGroups(typeDeclRegex, lines[i])?[3] == "CodingKeys" {
                inCK = true; codingKeysBlockStart = i; d2 = 0
            }
            if inCK {
                d2 += braceDelta(lines[i])
                if d2 == 0 && i > codingKeysBlockStart { codingKeysBlockEnd = i; break }
            }
        }
        if codingKeysBlockStart != -1 {
            var lastCaseIdx = codingKeysBlockStart
            for i in codingKeysBlockStart..<codingKeysBlockEnd {
                if lines[i].trimmingCharacters(in: .whitespaces).hasPrefix("case ") { lastCaseIdx = i }
            }
            let ckIndent = indentOf(lines[lastCaseIdx])
            let ckLine = wireKey == name ? "\(ckIndent)case \(name)" : "\(ckIndent)case \(name) = \"\(wireKey)\""
            lines.insert(ckLine, at: lastCaseIdx + 1)
            shift += 1
        }

        // 3. init parameter + assignment.
        let (sigEnd, initStart, initEnd) = findCallableRanges(lines, containingLineWith: "public init(", from: declIdx, to: closeIdx + shift)
        if sigEnd != -1 {
            var lastParamIdx = -1
            for i in stride(from: sigEnd - 1, through: declIdx, by: -1) {
                let t = lines[i].trimmingCharacters(in: .whitespaces)
                if !t.isEmpty && t != "(" { lastParamIdx = i; break }
            }
            if lastParamIdx != -1 {
                let paramIndent = indentOf(lines[lastParamIdx])
                var trimmed = lines[lastParamIdx]
                if !trimmed.trimmingCharacters(in: .whitespaces).hasSuffix(",") {
                    trimmed += ","
                    lines[lastParamIdx] = trimmed
                }
                lines.insert("\(paramIndent)\(name): \(typeText) = nil", at: lastParamIdx + 1)
                shift += 1
            }
            let (_, newInitStart, newInitEnd) = findCallableRanges(lines, containingLineWith: "public init(", from: declIdx, to: closeIdx + shift)
            if newInitEnd != -1 {
                var lastAssignIdx = newInitStart
                for i in newInitStart..<newInitEnd {
                    if lines[i].trimmingCharacters(in: .whitespaces).hasPrefix("self.") { lastAssignIdx = i }
                }
                let assignIndent = indentOf(lines[lastAssignIdx])
                lines.insert("\(assignIndent)self.\(name) = \(name)", at: lastAssignIdx + 1)
                shift += 1
            }
            _ = initStart; _ = initEnd
        }

        // 4. encode(to:) line, when the struct has a hand-rolled encoder.
        var encStart = -1, encEnd = -1
        var d3 = 0, inEnc = false
        for i in declIdx..<(closeIdx + shift) {
            if !inEnc, lines[i].contains("func encode(to encoder") {
                let (_, bs, be) = findCallableRanges(lines, containingLineWith: "func encode(to encoder", from: i, to: closeIdx + shift)
                encStart = bs; encEnd = be; inEnc = true
            }
            _ = d3
        }
        if encStart != -1, encEnd != -1 {
            let encIndent = indentOf(lines[encStart + 1])
            let usesEncodeIfPresent = (encStart...encEnd).contains { lines[$0].contains("encodeIfPresent(") }
            let newLine: String
            if usesEncodeIfPresent {
                newLine = "\(encIndent)try container.encodeIfPresent(\(name), forKey: .\(name))"
                lines.insert(newLine, at: encEnd)
            } else {
                let ifLetLines = [
                    "\(encIndent)if let \(name) = \(name) {",
                    "\(encIndent)    try container.encode(\(name), forKey: .\(name))",
                    "\(encIndent)}",
                ]
                lines.insert(contentsOf: ifLetLines, at: encEnd)
            }
        }

        fileLines[file] = lines
    }

    for (file, lines) in fileLines {
        try? lines.joined(separator: "\n").write(toFile: file, atomically: true, encoding: .utf8)
    }
}

// MARK: - Coverage report (non-blocking; endpoint-string vs spec.paths drift)
//
// check-contract.swift never validates URL paths (it only checks wire keys),
// so a wrong or missing endpoint string is otherwise invisible. This scans
// every literal `endpoint: "..."` string under Services/ and normalizes both
// it and every spec path template to a method+segment shape (with any
// interpolation/parameter segment collapsed to "*"), then reports the
// mismatches in both directions.

let endpointLiteralRegex = try! NSRegularExpression(pattern: #"endpoint:\s*"([^"]+)""#)
let methodRegex = try! NSRegularExpression(pattern: #"method:\s*\.(\w+)"#)

func normalizedSegments(_ path: String) -> [String] {
    path.split(separator: "/").map { segment -> String in
        let s = String(segment)
        if s.hasPrefix("{") && s.hasSuffix("}") { return "*" }
        if s.contains("\\(") { return "*" }
        return s
    }
}

struct EndpointUsage { let method: String; let template: String; let file: String; let line: Int }

func scanEndpointUsages(under path: String) -> [EndpointUsage] {
    var usages: [EndpointUsage] = []
    for file in swiftFiles(under: path) {
        guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
        let lines = content.components(separatedBy: "\n")
        for (idx, line) in lines.enumerated() {
            guard let g = matchGroups(endpointLiteralRegex, line) else { continue }
            let template = g[1]
            var method = "get"
            for offset in 0...6 {
                if idx + offset >= lines.count { break }
                if let m = matchGroups(methodRegex, lines[idx + offset]) { method = m[1]; break }
            }
            usages.append(EndpointUsage(method: method, template: template, file: file, line: idx + 1))
        }
    }
    return usages
}

func printCoverageReport(spec: [String: Any], servicesPath: String) {
    let usages = scanEndpointUsages(under: servicesPath)
    let usageKeys = Set(usages.map { "\($0.method).\(normalizedSegments($0.template).joined(separator: "/"))" })

    var specKeys: [String: (path: String, method: String)] = [:]
    for (path, ops) in paths(of: spec) {
        guard let opsDict = ops as? [String: Any] else { continue }
        for method in opsDict.keys where ["get", "post", "put", "delete", "patch"].contains(method) {
            let key = "\(method).\(normalizedSegments(path).joined(separator: "/"))"
            specKeys[key] = (path, method)
        }
    }

    print("sync --coverage-report (non-blocking):")

    let phantom = usages.filter { !specKeys.keys.contains("\($0.method).\(normalizedSegments($0.template).joined(separator: "/"))") }
    if phantom.isEmpty {
        print("  SDK endpoint strings with no match in the spec: none")
    } else {
        print("  SDK endpoint strings with NO match in the spec (possible drift, e.g. a renamed/never-existed path):")
        for u in phantom.sorted(by: { $0.file == $1.file ? $0.line < $1.line : $0.file < $1.file }) {
            print("    - \(u.file):\(u.line): \(u.method.uppercased()) \(u.template)")
        }
    }

    let uncovered = specKeys.filter { !usageKeys.contains($0.key) }
    if uncovered.isEmpty {
        print("  Spec operations with no SDK endpoint string: none")
    } else {
        print("  Spec operations with NO SDK endpoint string (uncovered surface):")
        for (_, v) in uncovered.sorted(by: { $0.value.path == $1.value.path ? $0.value.method < $1.value.method : $0.value.path < $1.value.path }) {
            print("    - \(v.method.uppercased()) \(v.path)")
        }
    }
}

// MARK: - Map validity

func validateMap(spec: [String: Any], scanned: [String: ScannedType]) -> [String] {
    var errors: [String] = []
    for entry in specMapEnums {
        guard let sdkSpec = entry.dict("sdk"), let symbol = sdkSpec.str("symbol"), let file = sdkSpec.str("file") else {
            errors.append("malformed enums entry: \(entry)"); continue
        }
        if !FileManager.default.fileExists(atPath: file) { errors.append("enum \(symbol): file not found: \(file)") }
        if scanned[symbol] == nil { errors.append("enum \(symbol): symbol not found under sources") }
        guard let specSpec = entry.dict("spec") else { errors.append("enum \(symbol): missing spec locator"); continue }
        do {
            _ = try resolveEnumAnchorValues(specSpec, in: spec)
        } catch {
            errors.append("enum \(symbol): \(error)")
        }
    }
    for entry in specMapTypes {
        guard let locator = entry.str("spec") else { errors.append("malformed types entry: \(entry)"); continue }
        do { _ = try resolveLocator(locator, in: spec) } catch { errors.append("type \(locator): \(error)") }
        for site in (entry["sdk"] as? [[String: Any]]) ?? [] {
            guard let symbol = site.str("symbol"), let file = site.str("file") else { errors.append("type \(locator): malformed sdk site"); continue }
            if !FileManager.default.fileExists(atPath: file) { errors.append("type \(locator) -> \(symbol): file not found: \(file)") }
            if scanned[symbol] == nil { errors.append("type \(locator) -> \(symbol): symbol not found under sources") }
        }
    }
    if let ignore = specMapRaw.dict("ignore"), let ignoreSchemas = ignore["schemas"] as? [[String: Any]] {
        for s in ignoreSchemas {
            guard let name = s.str("schema") else { errors.append("malformed ignore.schemas entry: \(s)"); continue }
            if schemas(of: spec)[name] == nil {
                errors.append("ignore.schemas entry \"\(name)\" does not exist in the spec (stale ignore entry)")
            }
        }
    }
    return errors
}

// MARK: - Main

let snapshot = loadJSONRequired(snapshotPath) as! [String: Any]

switch mode {
case .coverageReport:
    printCoverageReport(spec: snapshot, servicesPath: servicesPath)
    exit(0)

case .validateMap:
    let scanned = scanSources(under: sourcesPath)
    let errors = validateMap(spec: snapshot, scanned: scanned)
    if errors.isEmpty {
        print("sync --validate-map: PASS (\(specMapEnums.count) enums, \(specMapTypes.count) types)")
        exit(0)
    }
    print("sync --validate-map: FAIL")
    for e in errors { print("  - \(e)") }
    exit(1)

case .check:
    let scanned = scanSources(under: sourcesPath)
    let (applicable, needsHuman) = reconcile(spec: snapshot, scanned: scanned)
    if applicable.isEmpty && needsHuman.isEmpty {
        exit(0)
    }
    print("sync --check: FAIL (\(applicable.count) pending drift, \(needsHuman.count) needs-human)")
    for f in applicable { print("  - [pending] \(f.message)") }
    for f in needsHuman { print("  - [needs-human] \(f.message)") }
    exit(1)

case .apply:
    let newSpec = loadJSONRequired(specPath) as! [String: Any]
    let scanned = scanSources(under: sourcesPath)

    let structuralFindings = detectStructuralChanges(old: snapshot, new: newSpec)
    let (applicable, reconFindings) = reconcile(spec: newSpec, scanned: scanned)
    let needsHuman = structuralFindings + reconFindings

    var report: [String: Any] = [:]
    if !needsHuman.isEmpty {
        print("sync --apply: FAIL (needs-human, no changes written)")
        for f in needsHuman { print("  - \(f.message)") }
        report["appliedCount"] = 0
        report["needsHuman"] = needsHuman.map { $0.message }
        report["bump"] = "none"
        if let rp = reportPath {
            let data = try! JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
            try? data.write(to: URL(fileURLWithPath: rp))
        }
        exit(1)
    }

    if applicable.isEmpty {
        print("sync --apply: no changes")
        report["appliedCount"] = 0
        report["needsHuman"] = []
        report["bump"] = "none"
    } else {
        applyFindings(applicable)
        let bump = classifyBump(old: snapshot, new: newSpec)
        print("sync --apply: applied \(applicable.count) change(s), bump=\(bump.rawValue)")
        for f in applicable { print("  - \(f.message)") }
        report["appliedCount"] = applicable.count
        report["applied"] = applicable.map { $0.message }
        report["needsHuman"] = []
        report["bump"] = bump.rawValue
    }

    if let snapshotData = try? JSONSerialization.data(withJSONObject: newSpec, options: [.prettyPrinted, .sortedKeys]) {
        try? snapshotData.write(to: URL(fileURLWithPath: snapshotPath))
    }

    if let rp = reportPath {
        let data = try! JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
        try? data.write(to: URL(fileURLWithPath: rp))
    }
    exit(0)
}
