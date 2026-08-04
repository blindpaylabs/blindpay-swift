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

enum Mode { case check, apply, validateMap, coverageReport, auditTypes }

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
var enumExclusionsPath = ".api-sync/enum-exclusions.json"
var nestedOmissionsPath = ".api-sync/nested-omissions.json"
var operationExclusionsPath = ".api-sync/operation-exclusions.json"
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
        case "--audit-types": mode = .auditTypes
        case "--snapshot": i += 1; if i < args.count { snapshotPath = args[i] }
        case "--spec": i += 1; if i < args.count { specPath = args[i] }
        case "--sources": i += 1; if i < args.count { sourcesPath = args[i] }
        case "--services": i += 1; if i < args.count { servicesPath = args[i] }
        case "--spec-map": i += 1; if i < args.count { specMapPath = args[i] }
        case "--unmodeled": i += 1; if i < args.count { unmodeledPath = args[i] }
        case "--known-divergences": i += 1; if i < args.count { knownDivergencesPath = args[i] }
        case "--enum-exclusions": i += 1; if i < args.count { enumExclusionsPath = args[i] }
        case "--nested-omissions": i += 1; if i < args.count { nestedOmissionsPath = args[i] }
        case "--operation-exclusions": i += 1; if i < args.count { operationExclusionsPath = args[i] }
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

/// The exact (line, character offset) position of the opening "(" (offset
/// points just past it) and the matching closing ")" of a callable's
/// parameter list, found by tracking paren depth character by character
/// -- independent of where "{" falls, unlike findCallableRanges above.
/// This matters because a parameter list can be entirely on one line
/// (`public init(id: String, name: String) {`, common for small structs
/// like CustomerLimits.swift's PayinLimits) or spread one-per-line
/// (common for larger structs); appending a new parameter must handle both
/// without assuming the closing paren is ever on its own line.
struct ParamListRange { let openLine: Int; let openOffset: Int; let closeLine: Int; let closeOffset: Int }

func findParamListRange(_ lines: [String], containingLineWith marker: String, from: Int, to: Int) -> ParamListRange? {
    guard let declLine = (from...to).first(where: { lines[$0].contains(marker) }) else { return nil }
    var depth = 0
    var openLine = -1, openOffset = -1
    for i in declLine...to {
        let chars = Array(lines[i])
        for (j, ch) in chars.enumerated() {
            if ch == "(" {
                depth += 1
                if depth == 1, openLine == -1 { openLine = i; openOffset = j + 1 }
            } else if ch == ")" {
                depth -= 1
                if depth == 0, openLine != -1 {
                    return ParamListRange(openLine: openLine, openOffset: openOffset, closeLine: i, closeOffset: j)
                }
            }
        }
    }
    return nil
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

enum FindingKind: String { case applicableEnumCase = "applicable-enum-case", applicableField = "applicable-field", operationInsert = "operation-insert", needsHuman = "needs-human" }

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
    // Operation-insert payload (re-classified from spec at apply time; only the
    // method/path identity needs to survive the Finding round trip):
    var opMethod: String? = nil
    var opPath: String? = nil
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

// known-divergences.json also carries field-level "type-conversion" entries
// (schema locator + field, e.g. the three cents-converting hand-rolled
// encoders' amount fields, where the spec's wire type is deliberately
// narrower than the Swift property's type). Keyed separately from the
// enum-kind entries above, which use "enum" rather than "schema"/"field".
let typeDivergenceSet: Set<String> = Set(knownDivergencesRaw.compactMap { entry -> String? in
    guard let schema = entry.str("schema"), let field = entry.str("field") else { return nil }
    return "\(schema)\u{0}\(field)"
})
func isKnownTypeDivergence(locator: String, field: String) -> Bool {
    typeDivergenceSet.contains("\(locator)\u{0}\(field)")
}

// enum-exclusions.json: honest ledger of enum-constrained spec properties on a
// mapped schema that are deliberately not wired into spec-map.json's enums[]
// (e.g. a legacy field the SDK intentionally treats as a bare String). Keyed
// the same way as unmodeled.json (schema locator + field).
let enumExclusionsRaw = (loadJSON(enumExclusionsPath) as? [[String: Any]]) ?? []
let enumExclusionSet: Set<String> = Set(enumExclusionsRaw.compactMap { entry -> String? in
    guard let schema = entry.str("schema"), let field = entry.str("field") else { return nil }
    return "\(schema)\u{0}\(field)"
})
func isEnumCoverageExcluded(locator: String, field: String) -> Bool {
    enumExclusionSet.contains("\(locator)\u{0}\(field)")
}

// nested-omissions.json: honest ledger of inline object/array-of-object
// shapes on a mapped schema that are deliberately not given their own
// spec-map.json types entry (e.g. a nested shape with no SDK representation
// at all). Keyed the same way as unmodeled.json (schema locator + field).
let nestedOmissionsRaw = (loadJSON(nestedOmissionsPath) as? [[String: Any]]) ?? []
let nestedOmissionSet: Set<String> = Set(nestedOmissionsRaw.compactMap { entry -> String? in
    guard let schema = entry.str("schema"), let field = entry.str("field") else { return nil }
    return "\(schema)\u{0}\(field)"
})
func isNestedOmissionExcluded(locator: String, field: String) -> Bool {
    nestedOmissionSet.contains("\(locator)\u{0}\(field)")
}

// operation-exclusions.json: honest ledger of spec operations with no SDK
// method at all that predate operation-insert (this scaffolding cannot tell
// "always been uncovered" apart from "just appeared" without a two-spec
// diff, so pre-existing gaps must be recorded explicitly the same way
// enum-exclusions.json/nested-omissions.json record other pre-existing
// gaps) or that a human has deliberately deferred after triage. Keyed by
// "METHOD /path" using the exact spec path template.
let operationExclusionsRaw = (loadJSON(operationExclusionsPath) as? [[String: Any]]) ?? []
let operationExclusionSet: Set<String> = Set(operationExclusionsRaw.compactMap { entry -> String? in
    guard let method = entry.str("method"), let path = entry.str("path") else { return nil }
    return "\(method.uppercased()) \(path)"
})
func isOperationExcluded(method: String, path: String) -> Bool {
    operationExclusionSet.contains("\(method.uppercased()) \(path)")
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

// MARK: - Type-compatibility check
//
// Presence checks alone (does the SDK model this wire key at all) miss the
// more dangerous half of "type change": an EXISTING, already-modeled
// property whose spec type changed shape. A spec type change is a silent
// Codable decode failure at runtime for every consumer, and nothing else in
// this patcher (or check-contract.swift) looks at property types at all.

/// Every SDK enum symbol name registered anywhere in spec-map.json's enums[],
/// regardless of which single schema+property it is anchored to for coverage
/// checking. The same enum (e.g. Country, KYCType) is reused verbatim across
/// dozens of mapped schemas that each repeat the same spec "enum" array, so
/// type-checking must recognize the symbol globally rather than only at its
/// one canonical anchor -- otherwise every non-canonical occurrence looks
/// like a spurious "spec says string, SDK says Country" mismatch.
let registeredEnumSymbols: Set<String> = Set(specMapEnums.compactMap {
    ($0.dict("sdk"))?.str("symbol")
})

/// (baseType, nullable) from a JSON Schema node, handling the plain "type"
/// string, the ["x", "null"] union array, "anyOf"/"oneOf" branches (common in
/// this spec for e.g. date-time fields with a null branch), "$ref" (always a
/// named object schema in this spec), and -- when a node has none of those --
/// falling back to "format" (implies string) or the JSON runtime type of
/// "example" as a last-resort heuristic. An entirely empty node (`{}`) means
/// "unconstrained" per JSON Schema semantics, so it is treated as matching
/// any SDK type. Returns a nil base only when truly nothing on the node
/// hints at a type and the node is not empty.
func specTypeInfo(_ node: [String: Any]) -> (base: String?, nullable: Bool) {
    if node.isEmpty {
        return ("any", false)
    }
    if node["$ref"] != nil {
        // Every named schema this spec references is an object.
        return ("object", false)
    }
    if let t = node["type"] as? String {
        return (t == "null" ? nil : t, t == "null")
    }
    if let arr = node["type"] as? [Any] {
        let strs = arr.compactMap { $0 as? String }
        return (strs.first(where: { $0 != "null" }), strs.contains("null"))
    }
    if let branches = (node["anyOf"] as? [Any]) ?? (node["oneOf"] as? [Any]) ?? (node["allOf"] as? [Any]) {
        // anyOf/oneOf: a value matching any one branch is valid, so nullable
        // is true if ANY branch allows null. allOf technically means every
        // branch must hold simultaneously, but in practice this spec only
        // uses it to combine a "$ref" with a "{"type": [x, "null"]}" sibling
        // to express a nullable reference, so the same aggregation applies.
        var nullable = false
        var base: String? = nil
        for branch in branches {
            guard let b = branch as? [String: Any] else { continue }
            let (branchBase, branchNullable) = specTypeInfo(b)
            if branchNullable { nullable = true }
            if base == nil, let branchBase = branchBase { base = branchBase }
        }
        return (base, nullable)
    }
    if node["format"] != nil {
        return ("string", false)
    }
    switch node["example"] {
    case is String: return ("string", false)
    case is Bool: return ("boolean", false)
    case is Int, is Double: return ("number", false)
    case is [Any]: return ("array", false)
    case is [String: Any]: return ("object", false)
    default: break
    }
    return (nil, false)
}

func isSwiftOptional(_ typeText: String) -> Bool {
    typeText.trimmingCharacters(in: .whitespaces).hasSuffix("?")
}

func swiftBaseType(_ typeText: String) -> String {
    var t = typeText.trimmingCharacters(in: .whitespaces)
    if t.hasSuffix("?") { t.removeLast() }
    return t
}

/// Returns nil when the spec property's declared type and the SDK property's
/// declared Swift type still correspond; otherwise a human-readable mismatch
/// reason. Deliberately conservative: anything this cannot map with
/// confidence (an unrecognized spec type) is treated as a mismatch too, per
/// "where you cannot decide, classify as needs-human rather than silently
/// passing."
///
/// Nullability here is strictly the property's own type-level signal
/// ("type": [x, "null"], or an anyOf/oneOf branch of type "null") -- a
/// separate OpenAPI mechanism from the schema's "required" array, which
/// `detectStructuralChanges` already tracks on its own (a required-ness
/// CHANGE between old and new spec is its own needs-human category).
///
/// `strictNullability` selects which direction of mismatch is reported:
///   - false (used by the CI-gating --check/--apply path): only "spec now
///     allows null but the SDK is non-optional" is a mismatch. This SDK has
///     ~70 fields that are deliberately non-optional even though the spec's
///     type doesn't literally include "null" and/or the field isn't in
///     "required" (created_at/updated_at, nested tracking objects, etc.) --
///     a long-standing, harmless style choice (Optional gracefully accepts a
///     present non-null value either way), not a type change. Gating on it
///     would require ~70 known-divergences.json entries whose only content
///     is "this is fine", which is pure noise, not a curated signal.
///   - true (used by --audit-types, non-blocking): both directions are
///     reported, for full visibility into where the SDK's current type
///     surface disagrees with the spec at all, regardless of which side is
///     "stricter".
func typeMismatchReason(propName: String, propNode: [String: Any], swiftTypeText: String, strictNullability: Bool) -> String? {
    let (specBase, specNullable) = specTypeInfo(propNode)
    let swiftOptional = isSwiftOptional(swiftTypeText)
    let swiftBase = swiftBaseType(swiftTypeText)

    let nullabilityMismatch = strictNullability ? (specNullable != swiftOptional) : (specNullable && !swiftOptional)
    if nullabilityMismatch {
        let specSide = specNullable ? "spec allows null" : "spec does not allow null"
        let sdkSide = swiftOptional ? "SDK declares optional \(swiftTypeText)" : "SDK declares non-optional \(swiftTypeText)"
        return "nullability mismatch for \"\(propName)\": \(specSide), \(sdkSide)"
    }

    let specHasEnum = propNode["enum"] != nil
    let swiftIsRegisteredEnum = registeredEnumSymbols.contains(swiftBase)

    if swiftIsRegisteredEnum {
        if !specHasEnum {
            return "spec property \"\(propName)\" is no longer enum-valued, but SDK declares registered enum type \(swiftTypeText)"
        }
        // Spec is still enum-valued (wire representation is its declared base
        // type, normally "string") and the SDK is one of our registered spec
        // enums: compatible. Per-value coverage is the enum reconciliation
        // loop's job, not this type-shape check's.
        return nil
    }

    guard let specBase = specBase else {
        return "spec property \"\(propName)\" has no resolvable JSON type (SDK declares \(swiftTypeText))"
    }

    let primitiveTypes: Set<String> = ["String", "Int", "Double", "Bool"]
    switch specBase {
    case "any":
        // An entirely empty schema node places no constraint at all (JSON
        // Schema semantics: `{}` validates any value), so any SDK type
        // corresponds to it.
        return nil
    case "string":
        return swiftBase == "String" ? nil : "spec type \"string\" vs SDK type \(swiftBase)"
    case "integer":
        return swiftBase == "Int" ? nil : "spec type \"integer\" vs SDK type \(swiftBase)"
    case "number":
        // JSON Schema does not distinguish integral from fractional "number"
        // values, and several already-modeled amount fields intentionally
        // use Int (smallest-unit) for a "number" property; both are safe.
        return (swiftBase == "Double" || swiftBase == "Int") ? nil : "spec type \"number\" vs SDK type \(swiftBase)"
    case "boolean":
        return swiftBase == "Bool" ? nil : "spec type \"boolean\" vs SDK type \(swiftBase)"
    case "array":
        return swiftBase.hasPrefix("[") ? nil : "spec type \"array\" vs SDK type \(swiftBase)"
    case "object":
        return (primitiveTypes.contains(swiftBase) || swiftBase.hasPrefix("["))
            ? "spec type \"object\" vs SDK type \(swiftBase)" : nil
    default:
        return "unrecognized spec type \"\(specBase)\" for SDK type \(swiftBase)"
    }
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
            var propertyByWireKey: [String: ScannedProperty] = [:]
            for prop in scannedType.properties {
                let wireKey = scannedType.codingKeysWireKeyOf[prop.name] ?? prop.name
                propertyByWireKey[wireKey] = prop
            }
            for (propName, propNode) in specProps.sorted(by: { $0.key < $1.key }) {
                if let modeled = propertyByWireKey[propName] {
                    guard let propNodeDict = propNode as? [String: Any] else { continue }
                    if isKnownTypeDivergence(locator: locator, field: propName) { continue }
                    if let reason = typeMismatchReason(propName: propName, propNode: propNodeDict, swiftTypeText: modeled.typeText, strictNullability: false) {
                        needsHuman.append(Finding(kind: .needsHuman,
                            message: "\(symbol).\(modeled.name) (spec property \"\(propName)\" on \(locator)) type mismatch: \(reason)"))
                    }
                    continue
                }
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

    // New operations with no SDK endpoint literal at all (operation-insert):
    // computed against this single `spec` argument (--check passes the
    // committed snapshot, --apply passes the new spec), so it needs no
    // old-vs-new diff to notice "an operation exists with no SDK method" --
    // unlike new-*schema* detection below, which genuinely cannot tell
    // "always uncovered" apart from "just appeared" without two specs.
    let (opApplicable, opNeedsHuman) = operationCoverageFindings(spec: spec)
    applicable.append(contentsOf: opApplicable)
    needsHuman.append(contentsOf: opNeedsHuman)

    return (applicable, needsHuman)
}

// MARK: - Reachability
//
// A component schema is only "in scope" for the new-schema needs-human gate
// if something in the public surface can actually produce/consume it.
// Schemas that exist in components/schemas but are never $ref'd from
// anywhere reachable are orphans -- generator leftovers, drafts, or schemas
// the spec author staged for a future endpoint -- and require no SDK work at
// all. Seeding from every non-schema component section (not just paths)
// matters because a schema can be reachable ONLY through a shared parameter
// or response that several operations $ref, without appearing inline in any
// single path's own body.

/// Recursively collects every "#/components/schemas/Name" $ref found
/// anywhere within `node` (properties, items, allOf/oneOf/anyOf,
/// additionalProperties, or any other nesting) into `set`.
func collectSchemaRefs(_ node: Any, into set: inout Set<String>) {
    if let dict = node as? [String: Any] {
        if let ref = dict["$ref"] as? String, ref.hasPrefix("#/components/schemas/") {
            set.insert(String(ref.dropFirst("#/components/schemas/".count)))
        }
        for (_, v) in dict { collectSchemaRefs(v, into: &set) }
    } else if let arr = node as? [Any] {
        for v in arr { collectSchemaRefs(v, into: &set) }
    }
}

/// Every component schema reachable, by transitive $ref, from: every path
/// operation, the webhooks (or x-webhooks) section, and every non-schema
/// component section (parameters, requestBodies, responses, headers,
/// securitySchemes, etc.) -- since those are shared and can be the only
/// place a schema is referenced from.
func reachableSchemaNames(_ spec: [String: Any]) -> Set<String> {
    var seeds: [Any] = [spec["paths"] ?? [:]]
    if let wh = spec["webhooks"] { seeds.append(wh) }
    if let wh = spec["x-webhooks"] { seeds.append(wh) }
    if let components = spec["components"] as? [String: Any] {
        for (key, value) in components where key != "schemas" {
            seeds.append(value)
        }
    }

    var frontier = Set<String>()
    for seed in seeds { collectSchemaRefs(seed, into: &frontier) }

    let allSchemas = schemas(of: spec)
    var reachable = Set<String>()
    while !frontier.subtracting(reachable).isEmpty {
        let next = frontier.subtracting(reachable)
        reachable.formUnion(next)
        var newFrontier = Set<String>()
        for name in next {
            guard let schemaNode = allSchemas[name] else { continue }
            collectSchemaRefs(schemaNode, into: &newFrontier)
        }
        frontier = newFrontier
    }
    return reachable
}

// MARK: - Operation-insert: classifying and generating brand-new operations
//
// For every spec operation with no matching SDK endpoint literal, decide
// STANDARD (auto-generatable, becomes an `.operationInsert` applicable
// Finding) vs NON-STANDARD (needs-human, with a precise reason). STANDARD
// requires ALL of:
//   - request/response bodies are JSON-only (or absent),
//   - no query parameters (query-parameter struct synthesis isn't
//     implemented yet -- an honest, explicit boundary, not a silent gap),
//   - the operation's path resolves, by longest fixed-segment prefix match,
//     to an EXISTING Services/*.swift file,
//   - every schema the request/response touches (transitively through
//     named $ref) is a plain object/array/string/number/boolean composition
//     with no enum, oneOf/anyOf/allOf-with-multiple-substantive-branches,
//     or inline (un-named) nested object shape.
// Everything else is needs-human with a specific reason string.

func specOperations(_ spec: [String: Any]) -> [(method: String, path: String, op: [String: Any])] {
    var result: [(method: String, path: String, op: [String: Any])] = []
    for (path, opsAny) in paths(of: spec) {
        guard let ops = opsAny as? [String: Any] else { continue }
        for method in ["get", "post", "put", "delete", "patch"] {
            if let op = ops[method] as? [String: Any] {
                result.append((method, path, op))
            }
        }
    }
    return result
}

/// True if `node` is a JSON Schema composition (`allOf`/`anyOf`/`oneOf`) whose
/// only purpose is the common "nullable $ref" idiom this spec uses elsewhere
/// (a substantive branch plus a bare `{"type": "null"}` sibling). Returns the
/// single substantive branch in that case; returns `node` unchanged when it
/// isn't a composition at all; returns nil for genuine multi-branch
/// polymorphism, which the generator cannot express.
func effectiveSchemaNode(_ node: [String: Any]) -> [String: Any]? {
    guard let branches = (node["allOf"] as? [Any]) ?? (node["anyOf"] as? [Any]) ?? (node["oneOf"] as? [Any]) else {
        return node
    }
    let dicts = branches.compactMap { $0 as? [String: Any] }
    let substantive = dicts.filter { ($0["type"] as? String) != "null" }
    return substantive.count == 1 ? substantive[0] : nil
}

/// Recursively verifies `node` (already possibly a $ref) is expressible with
/// the object/array/string/number/boolean/nullable-ref composition the
/// generator (and its model synthesis in swiftTypeForSchema below) knows how
/// to render. Returns nil when expressible, else a precise reason.
///
/// `allowInlineObject` distinguishes "this object node is the just-resolved
/// body of a named $ref schema" (fine -- its OWN properties are what get
/// checked, individually, as non-inline) from "this object node appears
/// directly, with no $ref, as a property/items value" (not fine -- the
/// generator has no way to name and place an anonymous nested struct).
func checkSchemaExpressible(_ nodeIn: [String: Any], spec: [String: Any], visited: inout Set<String>, allowInlineObject: Bool = false) -> String? {
    guard let node = effectiveSchemaNode(nodeIn) else {
        return "uses a oneOf/anyOf/allOf/discriminator composition with more than one substantive branch, not supported by the generator"
    }
    if node["enum"] != nil {
        return "is enum-constrained; enum naming/placement requires a human decision"
    }
    if let items = node.dict("items"), items["enum"] != nil {
        return "is an array of an enum-constrained item; enum naming/placement requires a human decision"
    }
    if let ref = node.str("$ref") {
        guard ref.hasPrefix("#/components/schemas/") else {
            return "uses a $ref outside #/components/schemas, not supported by the generator"
        }
        let name = String(ref.dropFirst("#/components/schemas/".count))
        if visited.contains(name) { return nil } // recursive/self-referencing schema already in progress
        // Already hand-mapped to an existing SDK type (spec-map.json types[]):
        // swiftTypeForSchema reuses that symbol outright rather than
        // regenerating it, so its shape needs no mechanical-expressibility
        // check here either -- it may well use conventions (a real enum,
        // etc.) beyond what the generator itself could produce from scratch.
        if specMapTypes.contains(where: { $0.str("spec") == name }) { return nil }
        visited.insert(name)
        guard let target = schemas(of: spec)[name] as? [String: Any] else {
            return "references unknown schema \"\(name)\""
        }
        return checkSchemaExpressible(target, spec: spec, visited: &visited, allowInlineObject: true)
    }
    let type = node["type"] as? String
    if type == "array" {
        guard let items = node.dict("items") else { return "array schema is missing \"items\"" }
        return checkSchemaExpressible(items, spec: spec, visited: &visited, allowInlineObject: false)
    }
    if type == "object" || (type == nil && node["properties"] != nil) {
        guard allowInlineObject else {
            return "uses an inline (un-named) object shape; the generator only supports named component schemas (\"$ref\") for objects"
        }
        guard let props = node.dict("properties") else { return nil } // free-form object (no properties): renders as [String: String]
        for (propName, propNodeAny) in props.sorted(by: { $0.key < $1.key }) {
            guard let propNode = propNodeAny as? [String: Any] else { continue }
            if let reason = checkSchemaExpressible(propNode, spec: spec, visited: &visited, allowInlineObject: false) {
                return "property \"\(propName)\" \(reason)"
            }
        }
        return nil
    }
    if let type = type, ["string", "integer", "number", "boolean"].contains(type) {
        return nil
    }
    if node["format"] != nil || node.isEmpty {
        return nil
    }
    return "uses an unrecognized schema shape (type: \(type ?? "nil"))"
}

/// The full set of media types under an operation's requestBody/response
/// "content" map, or empty if there is none (no body / 204, both fine).
func mediaTypes(of contentHolder: [String: Any]?) -> Set<String> {
    guard let content = contentHolder?.dict("content") else { return [] }
    return Set(content.keys)
}

/// True if `types` is either empty (no body) or exactly {"application/json"}.
func isJSONOnly(_ types: Set<String>) -> Bool {
    types.isEmpty || types == ["application/json"]
}

/// `normalizedSegments`, minus the leading "v1" (every real path in this
/// SDK's spec) and "e" (the customer-trackable facade prefix) generic
/// boilerplate segments -- those alone are never a meaningful resource
/// match (every service shares them), so the prefix-match threshold below
/// counts significant segments only.
func significantSegments(_ path: String) -> [String] {
    var segs = normalizedSegments(path)
    if segs.first == "v1" { segs.removeFirst() }
    if segs.first == "e" { segs.removeFirst() }
    return segs
}

/// The Services/*.swift file whose existing endpoint literals share the
/// longest fixed-segment path prefix with `path`, plus how many `{param}`
/// placeholders fall within that shared prefix (i.e. how many of the new
/// operation's path parameters the matched service's own init(...) already
/// binds as stored properties, e.g. instanceId/customerId).
func matchExistingService(path: String, usages: [EndpointUsage]) -> (file: String, boundParamCount: Int)? {
    let target = significantSegments(path)
    var best: (len: Int, file: String)? = nil
    // Only Services/*.swift files are eligible generation targets (per the
    // task's own scope: never invent a new service file, and never target
    // the flat Core/BlindPay.swift facade instead of the real nested
    // service it mirrors) -- restricting the candidate pool here, not just
    // preferring it on ties, keeps this deterministic regardless of file
    // scan order. Checked as a path COMPONENT (not substring) so it matches
    // both "Sources/BlindPay/Services/X.swift" and, in the test fixture
    // harness, a bare relative "Services/X.swift".
    let serviceUsages = usages.filter { $0.file.split(separator: "/").dropLast().contains("Services") }
    for u in serviceUsages {
        let candidate = significantSegments(u.template)
        var common = 0
        while common < target.count, common < candidate.count, target[common] == candidate[common] {
            common += 1
        }
        if common > (best?.len ?? 0) {
            best = (common, u.file)
        }
    }
    guard let b = best, b.len >= 1 else { return nil }
    let boundParamCount = target.prefix(b.len).filter { $0 == "*" }.count
    return (b.file, boundParamCount)
}

/// Extracts the ordered, non-"apiClient" parameter names from a service
/// class's `init(apiClient: APIClient, ...)` declaration -- these are the
/// stored properties (instanceId, customerId, ...) already bound for every
/// method on that service, in the same order its path always nests them.
func boundProperties(of serviceFile: String) -> [String] {
    guard let content = try? String(contentsOfFile: serviceFile, encoding: .utf8) else { return [] }
    guard let range = content.range(of: #"init\(([^)]*)\)"#, options: .regularExpression) else { return [] }
    var inner = String(content[range])
    inner.removeFirst("init(".count)
    inner.removeLast() // trailing ")"
    var names: [String] = []
    for part in inner.split(separator: ",") {
        let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let colon = trimmed.firstIndex(of: ":") else { continue }
        let name = String(trimmed[trimmed.startIndex..<colon]).trimmingCharacters(in: .whitespaces)
        if name.isEmpty || name == "apiClient" { continue }
        names.append(name)
    }
    return names
}

/// Rewrites `path`'s `{param}` placeholders into a Swift string-interpolated
/// endpoint template: the first `boundNames.count` placeholders become
/// `\(boundNames[i])` (already-bound service properties, in order); any
/// remaining placeholders become new method parameters, named from their
/// own OpenAPI path-param name.
func buildEndpointTemplate(path: String, boundNames: [String]) -> (template: String, extraParams: [String]) {
    var extraParams: [String] = []
    var boundIdx = 0
    let segments = path.components(separatedBy: "/")
    var outSegments: [String] = []
    for segment in segments {
        if segment.hasPrefix("{") && segment.hasSuffix("}") {
            let raw = String(segment.dropFirst().dropLast())
            if boundIdx < boundNames.count {
                outSegments.append("\\(\(boundNames[boundIdx]))")
                boundIdx += 1
            } else {
                let swiftName = deriveCamelName(from: raw.replacingOccurrences(of: "-", with: "_"))
                extraParams.append(swiftName)
                outSegments.append("\\(\(swiftName))")
            }
        } else {
            outSegments.append(segment)
        }
    }
    return (outSegments.joined(separator: "/"), extraParams)
}

/// Deterministic method-name derivation from HTTP verb + path shape, since
/// this spec carries no `operationId`. Mirrors the repo's existing
/// hand-written convention as closely as a mechanical rule can: the base
/// collection/item route gets the plain CRUD verb (list/get/create/update/
/// delete); a further, non-parameter path segment beyond the resource itself
/// (an RPC-style sub-action, e.g. ".../secret", ".../authorize") gets that
/// verb prefixed onto the segment's camelCase name.
func deriveMethodName(method: String, path: String, resourceSegment: String, responseIsArray: Bool) -> String {
    let segments = path.split(separator: "/").map(String.init)
    let lastSegment = segments.last ?? ""
    let isTrailingParam = lastSegment.hasPrefix("{") && lastSegment.hasSuffix("}")
    let lastFixed = segments.reversed().first { !($0.hasPrefix("{") && $0.hasSuffix("}")) } ?? ""
    let lastFixedCamel = deriveCamelName(from: lastFixed.replacingOccurrences(of: "-", with: "_"))
    let suffixPascal = lastFixedCamel.prefix(1).uppercased() + lastFixedCamel.dropFirst()
    let isBaseResource = lastFixed == resourceSegment

    switch method {
    case "get":
        if isTrailingParam { return "get" }
        if isBaseResource { return responseIsArray ? "list" : "get" }
        return "get" + suffixPascal
    case "post":
        return isBaseResource ? "create" : "create" + suffixPascal
    case "put", "patch":
        return (isBaseResource || isTrailingParam) ? "update" : "update" + suffixPascal
    case "delete":
        return "delete"
    default:
        return "operation"
    }
}

enum OperationClassification { case standard, nonStandard(String) }

/// Classifies one uncovered spec operation. Does not mutate anything; safe
/// to call from both --check (against the committed snapshot) and --apply
/// (against the new spec).
func classifyNewOperation(method: String, path: String, op: [String: Any], spec: [String: Any], usages: [EndpointUsage]) -> OperationClassification {
    if let params = op.arr("parameters") {
        for p in params {
            guard let pd = p as? [String: Any] else { continue }
            if pd.str("in") == "query" {
                return .nonStandard("has query parameter \"\(pd.str("name") ?? "?")\"; query-parameter struct synthesis is not supported by the generator")
            }
        }
    }

    let requestBody = op.dict("requestBody")
    let requestMediaTypes = mediaTypes(of: requestBody)
    if !isJSONOnly(requestMediaTypes) {
        let bad = requestMediaTypes.subtracting(["application/json"]).sorted().joined(separator: ", ")
        return .nonStandard("\(bad) request body not supported by the generator (JSON-only)")
    }

    if let responses = op.dict("responses") {
        for (code, respAny) in responses.sorted(by: { $0.key < $1.key }) {
            guard let resp = respAny as? [String: Any] else { continue }
            let types = mediaTypes(of: resp)
            if !isJSONOnly(types) {
                let bad = types.subtracting(["application/json"]).sorted().joined(separator: ", ")
                return .nonStandard("\(bad) response body (status \(code)) not supported by the generator (JSON-only)")
            }
        }
    }

    guard matchExistingService(path: path, usages: usages) != nil else {
        let tag = (op.arr("tags")?.first as? String) ?? "<none>"
        return .nonStandard("no existing service matches tag \"\(tag)\" or path prefix \"\(path)\"")
    }

    var visited = Set<String>()
    if let schema = requestBody?.dict("content")?.dict("application/json")?.dict("schema") {
        if let reason = checkSchemaExpressible(schema, spec: spec, visited: &visited) {
            return .nonStandard("request body schema \(reason)")
        }
    }
    if let responses = op.dict("responses") {
        for code in ["200", "201", "202"] {
            if let schema = responses.dict(code)?.dict("content")?.dict("application/json")?.dict("schema") {
                if let reason = checkSchemaExpressible(schema, spec: spec, visited: &visited) {
                    return .nonStandard("response body (status \(code)) schema \(reason)")
                }
            }
        }
    }
    return .standard
}

/// Every named component schema transitively touched (via $ref) by an
/// operation that classifies STANDARD -- these are about to get their own
/// spec-map.json types[] entry synthesized by applyOperationInsertions, so
/// the plain "new schema, not yet in spec-map.json" gate below must not
/// also flag them as a second, redundant needs-human finding.
func schemaNamesTouchedByOperationInserts(spec: [String: Any]) -> Set<String> {
    var touched = Set<String>()
    let usages = scanEndpointUsages(under: servicesPath)
    let usageKeys = Set(usages.map { "\($0.method).\(normalizedSegments($0.template).joined(separator: "/"))" })
    for (method, path, op) in specOperations(spec) {
        let key = "\(method).\(normalizedSegments(path).joined(separator: "/"))"
        if usageKeys.contains(key) { continue }
        if isOperationExcluded(method: method, path: path) { continue }
        guard case .standard = classifyNewOperation(method: method, path: path, op: op, spec: spec, usages: usages) else { continue }
        var visited = Set<String>()
        if let schema = op.dict("requestBody")?.dict("content")?.dict("application/json")?.dict("schema") {
            _ = checkSchemaExpressible(schema, spec: spec, visited: &visited)
        }
        if let responses = op.dict("responses") {
            for code in ["200", "201", "202"] {
                if let schema = responses.dict(code)?.dict("content")?.dict("application/json")?.dict("schema") {
                    _ = checkSchemaExpressible(schema, spec: spec, visited: &visited)
                }
            }
        }
        touched.formUnion(visited)
    }
    return touched
}

/// Scans the spec for operations with no matching SDK endpoint literal
/// (reusing the same normalized-segment matching as --coverage-report),
/// skips anything recorded in operation-exclusions.json, and classifies the
/// rest as either an applicable `.operationInsert` finding or needs-human.
func operationCoverageFindings(spec: [String: Any]) -> (applicable: [Finding], needsHuman: [Finding]) {
    var applicable: [Finding] = []
    var needsHuman: [Finding] = []
    let usages = scanEndpointUsages(under: servicesPath)
    let usageKeys = Set(usages.map { "\($0.method).\(normalizedSegments($0.template).joined(separator: "/"))" })

    for (method, path, op) in specOperations(spec).sorted(by: { $0.path == $1.path ? $0.method < $1.method : $0.path < $1.path }) {
        let key = "\(method).\(normalizedSegments(path).joined(separator: "/"))"
        if usageKeys.contains(key) { continue }
        if isOperationExcluded(method: method, path: path) { continue }
        switch classifyNewOperation(method: method, path: path, op: op, spec: spec, usages: usages) {
        case .standard:
            applicable.append(Finding(
                kind: .operationInsert,
                message: "new operation \"\(method.uppercased()) \(path)\" has no SDK method; auto-generatable (operation-insert)",
                opMethod: method, opPath: path))
        case .nonStandard(let reason):
            needsHuman.append(Finding(kind: .needsHuman, message: "new operation \"\(method.uppercased()) \(path)\" needs a human decision: \(reason)"))
        }
    }
    return (applicable, needsHuman)
}

// MARK: - Operation-insert: model + method generation (--apply only)

struct GeneratedField { let wireKey: String; let swiftName: String; let swiftType: String; let required: Bool }
struct GeneratedStruct { let schemaName: String; let swiftName: String; let isInput: Bool; let fields: [GeneratedField] }

/// Swift symbol name for a named component schema, following this repo's
/// existing spec-map.json convention: an "...In" input schema becomes
/// "...Input"; an "...Out" output schema drops the suffix outright (see
/// CustomerOut -> Customer, CreateCustomerIn -> CreateCustomerInput).
func swiftStructName(for schemaName: String) -> String {
    if schemaName.hasSuffix("In") { return String(schemaName.dropLast(2)) + "Input" }
    if schemaName.hasSuffix("Out") { return String(schemaName.dropLast(3)) }
    return schemaName
}

/// Resolves a schema node to a Swift type-text (e.g. "String", "Int",
/// "[Foo]"), synthesizing a new struct (appended to `generated`) for any
/// not-yet-mapped named object schema it touches. Reuses an already-mapped
/// spec-map.json symbol, or an already-scheduled-this-run symbol, whenever
/// the same named schema recurs. Returns nil if the node turns out not to be
/// expressible after all (should not happen once checkSchemaExpressible has
/// already accepted it, but stays honest rather than crashing).
func swiftTypeForSchema(_ nodeIn: [String: Any], spec: [String: Any], scanned: [String: ScannedType], isInputContext: Bool, generated: inout [GeneratedStruct], generatedNames: inout Set<String>) -> String? {
    guard let node = effectiveSchemaNode(nodeIn) else { return nil }

    if let ref = node.str("$ref"), ref.hasPrefix("#/components/schemas/") {
        let refName = String(ref.dropFirst("#/components/schemas/".count))
        if let existing = specMapTypes.first(where: { $0.str("spec") == refName }),
           let sdkSites = existing["sdk"] as? [[String: Any]], let symbol = sdkSites.first?.str("symbol") {
            return symbol
        }
        let swiftName = swiftStructName(for: refName)
        if generatedNames.contains(refName) { return swiftName }
        guard let target = schemas(of: spec)[refName] as? [String: Any] else { return nil }
        guard let targetProps = target.dict("properties") else {
            // Named schema with no properties at all (free-form map): render
            // the same conservative fallback swiftType() already uses for a
            // brand-new optional field on an existing struct.
            return "[String: String]"
        }
        generatedNames.insert(refName)
        let required = requiredOf(target)
        var fields: [GeneratedField] = []
        for (propName, propNodeAny) in targetProps.sorted(by: { $0.key < $1.key }) {
            guard let propNode = propNodeAny as? [String: Any] else { continue }
            guard let fieldType = swiftTypeForSchema(propNode, spec: spec, scanned: scanned, isInputContext: isInputContext, generated: &generated, generatedNames: &generatedNames) else { return nil }
            let isRequired = required.contains(propName)
            fields.append(GeneratedField(wireKey: propName, swiftName: deriveCamelName(from: propName), swiftType: isRequired ? fieldType : fieldType + "?", required: isRequired))
        }
        generated.append(GeneratedStruct(schemaName: refName, swiftName: swiftName, isInput: isInputContext, fields: fields))
        return swiftName
    }

    let type = node["type"] as? String
    switch type {
    case "array":
        guard let items = node.dict("items") else { return nil }
        guard let itemType = swiftTypeForSchema(items, spec: spec, scanned: scanned, isInputContext: isInputContext, generated: &generated, generatedNames: &generatedNames) else { return nil }
        return "[\(itemType)]"
    case "string": return "String"
    case "integer": return "Int"
    case "number": return "Double"
    case "boolean": return "Bool"
    default: return nil
    }
}

/// Renders one synthesized struct's full Swift source text, matching the
/// convention read from Sources/BlindPay/Models/*.swift: plain Codable
/// output structs decode-only; input structs additionally get a hand-rolled
/// `encode(to:)` that omits absent optionals via encodeIfPresent (the same
/// style already used in e.g. Quote.swift/PayinQuote.swift) rather than
/// emitting an explicit JSON null.
func renderGeneratedStruct(_ s: GeneratedStruct) -> String {
    var lines: [String] = []
    lines.append("/// Auto-generated by sync.swift (operation-insert) from spec schema \"\(s.schemaName)\".")
    lines.append("public struct \(s.swiftName): Codable, Sendable, Equatable {")
    for f in s.fields {
        lines.append("    public let \(f.swiftName): \(f.swiftType)")
    }
    lines.append("")
    lines.append("    public init(")
    for (i, f) in s.fields.enumerated() {
        let def = f.required ? "" : " = nil"
        let comma = i < s.fields.count - 1 ? "," : ""
        lines.append("        \(f.swiftName): \(f.swiftType)\(def)\(comma)")
    }
    lines.append("    ) {")
    for f in s.fields {
        lines.append("        self.\(f.swiftName) = \(f.swiftName)")
    }
    lines.append("    }")
    lines.append("")
    lines.append("    enum CodingKeys: String, CodingKey {")
    for f in s.fields {
        lines.append(f.swiftName == f.wireKey ? "        case \(f.swiftName)" : "        case \(f.swiftName) = \"\(f.wireKey)\"")
    }
    lines.append("    }")
    if s.isInput {
        lines.append("")
        lines.append("    public func encode(to encoder: Encoder) throws {")
        lines.append("        var container = encoder.container(keyedBy: CodingKeys.self)")
        for f in s.fields {
            if f.required {
                lines.append("        try container.encode(\(f.swiftName), forKey: .\(f.swiftName))")
            } else {
                lines.append("        try container.encodeIfPresent(\(f.swiftName), forKey: .\(f.swiftName))")
            }
        }
        lines.append("    }")
    }
    lines.append("}")
    return lines.joined(separator: "\n")
}

/// The Models/*.swift file a service's structs live in, by this repo's 1:1
/// naming convention (PartnerFeesService.swift -> PartnerFee.swift,
/// AvailableService.swift -> Available.swift): strip the "Service" suffix,
/// then try the exact name and its singular (trailing "s" dropped) against
/// the actual Models/ file list.
func modelFileFor(serviceFile: String, sourcesPath: String) -> String? {
    let base = (serviceFile as NSString).lastPathComponent.replacingOccurrences(of: "Service.swift", with: "")
    let candidates = [base, base.hasSuffix("s") ? String(base.dropLast()) : base]
    for candidate in candidates {
        let path = sourcesPath + "/" + candidate + ".swift"
        if FileManager.default.fileExists(atPath: path) { return path }
    }
    return nil
}

/// Renders one new service method's full Swift source text.
func renderServiceMethod(name: String, extraParams: [String], hasBody: Bool, bodyRequired: Bool, inputTypeName: String?, outputTypeName: String, httpMethod: String, endpointTemplate: String, opMethod: String, opPath: String) -> String {
    var sigParams = extraParams.map { "\($0): String" }
    if hasBody, let inputTypeName = inputTypeName {
        sigParams.append(bodyRequired ? "data: \(inputTypeName)" : "data: \(inputTypeName)? = nil")
    }
    var lines: [String] = []
    lines.append("    /// Auto-generated by sync.swift (operation-insert) for \(opMethod.uppercased()) \(opPath).")
    lines.append("    public func \(name)(\(sigParams.joined(separator: ", "))) async throws -> APIResponse<\(outputTypeName)> {")
    lines.append("        return try await apiClient.request(")
    lines.append("            endpoint: \"\(endpointTemplate)\",")
    lines.append("            method: .\(httpMethod)\(hasBody ? "," : "")")
    if hasBody {
        lines.append("            body: data")
    }
    lines.append("        )")
    lines.append("    }")
    return lines.joined(separator: "\n")
}

struct OperationInsertPlan {
    let serviceFile: String
    let modelFile: String
    let methodText: String
    let newStructs: [GeneratedStruct]
}

/// Re-derives the full generation plan for one already-classified-STANDARD
/// operation. Re-classifying at apply time (rather than threading a plan
/// through Finding) keeps Finding a plain value type and keeps --check and
/// --apply sharing exactly one source of truth for "is this operation
/// STANDARD". `generatedNames`/`generated` are threaded across the whole
/// --apply batch so two operations that reference the same nested schema
/// don't synthesize it twice.
func planOperationInsert(method: String, path: String, op: [String: Any], spec: [String: Any], scanned: [String: ScannedType], usages: [EndpointUsage], generatedNames: inout Set<String>) -> OperationInsertPlan? {
    guard let (serviceFile, _) = matchExistingService(path: path, usages: usages) else { return nil }
    guard let modelFile = modelFileFor(serviceFile: serviceFile, sourcesPath: sourcesPath) else { return nil }
    let boundNames = boundProperties(of: serviceFile)
    let (endpointTemplate, extraParams) = buildEndpointTemplate(path: path, boundNames: boundNames)

    var generated: [GeneratedStruct] = []

    var inputTypeName: String? = nil
    var bodyRequired = false
    if let rb = op.dict("requestBody") {
        bodyRequired = (rb["required"] as? Bool) ?? false
        if let schema = rb.dict("content")?.dict("application/json")?.dict("schema") {
            inputTypeName = swiftTypeForSchema(schema, spec: spec, scanned: scanned, isInputContext: true, generated: &generated, generatedNames: &generatedNames)
        }
    }

    var outputTypeName = "VoidResponse"
    var responseIsArray = false
    if let responses = op.dict("responses") {
        for code in ["200", "201", "202"] {
            if let schema = responses.dict(code)?.dict("content")?.dict("application/json")?.dict("schema") {
                if let t = swiftTypeForSchema(schema, spec: spec, scanned: scanned, isInputContext: false, generated: &generated, generatedNames: &generatedNames) {
                    outputTypeName = t
                    responseIsArray = (effectiveSchemaNode(schema)?["type"] as? String) == "array"
                }
                break
            }
        }
    }

    // Resource segment (for method-name derivation): the first fixed path
    // segment appearing after every bound-param placeholder has been
    // consumed, e.g. ".../{instance_id}/customers/{customer_id}/rfi" with
    // boundNames = [instanceId, customerId] -> "rfi".
    var boundIdx = 0
    var resourceSegment = ""
    var foundResource = false
    for seg in path.components(separatedBy: "/") where !seg.isEmpty {
        if seg.hasPrefix("{") && seg.hasSuffix("}") {
            boundIdx += 1
            continue
        }
        if boundIdx >= boundNames.count, !foundResource {
            resourceSegment = seg
            foundResource = true
        }
    }

    let name = deriveMethodName(method: method, path: path, resourceSegment: resourceSegment, responseIsArray: responseIsArray)
    let hasBody = op.dict("requestBody") != nil
    let methodText = renderServiceMethod(
        name: name, extraParams: extraParams, hasBody: hasBody, bodyRequired: bodyRequired,
        inputTypeName: inputTypeName, outputTypeName: outputTypeName, httpMethod: method,
        endpointTemplate: endpointTemplate, opMethod: method, opPath: path)

    return OperationInsertPlan(serviceFile: serviceFile, modelFile: modelFile, methodText: methodText, newStructs: generated)
}

// MARK: - JSON-array text splicing (spec-map.json), without a JSON round trip
//
// Appending new spec-map.json entries by JSONSerialization-decode-then-
// re-encode would reformat and reorder the *entire* curated file, the exact
// noisy-diff failure mode the snapshot byte-copy invariant above exists to
// avoid for spec-snapshot.json. spec-map.json is hand-edited and its
// formatting matters too, so new entries are spliced into the raw text
// instead, preserving every existing byte.

/// Finds the index in `text` matching `openIndex` (which must point at
/// `open`), honoring JSON string-literal escaping so a "{"/"}" or "["/"]"
/// character inside a quoted string (e.g. a "{instance_id}" path template)
/// is never mistaken for a structural bracket.
func findMatchingBracket(_ text: String, openIndex: String.Index, open: Character, close: Character) -> String.Index? {
    var depth = 0
    var inString = false
    var escaped = false
    var i = openIndex
    while i < text.endIndex {
        let c = text[i]
        if inString {
            if escaped { escaped = false } else if c == "\\" { escaped = true } else if c == "\"" { inString = false }
        } else {
            if c == "\"" { inString = true }
            else if c == open { depth += 1 }
            else if c == close {
                depth -= 1
                if depth == 0 { return i }
            }
        }
        i = text.index(after: i)
    }
    return nil
}

/// Appends `newEntryBlocks` (each pre-rendered, indented JSON object text,
/// no trailing comma) to the JSON array introduced by `arrayKeyPattern`
/// (a regex matching the key and colon only, e.g. `"\"types\"\s*:"` --
/// tolerant of incidental whitespace so it isn't wedded to one specific
/// serializer's formatting), splicing raw text rather than round-tripping
/// through JSONSerialization.
func appendToJSONArray(_ rawText: String, arrayKeyPattern: String, newEntryBlocks: [String]) -> String? {
    guard !newEntryBlocks.isEmpty else { return rawText }
    guard let keyRange = rawText.range(of: arrayKeyPattern, options: .regularExpression) else { return nil }
    guard let openBracket = rawText.range(of: "[", range: keyRange.upperBound..<rawText.endIndex) else { return nil }
    guard let closeIdx = findMatchingBracket(rawText, openIndex: openBracket.lowerBound, open: "[", close: "]") else { return nil }

    var insertAt = closeIdx
    while insertAt > openBracket.upperBound {
        let prev = rawText.index(before: insertAt)
        if rawText[prev].isWhitespace { insertAt = prev } else { break }
    }
    let isEmpty = insertAt == openBracket.upperBound
    let joined = newEntryBlocks.joined(separator: ",\n")
    let insertion = (isEmpty ? "" : ",") + "\n" + joined

    var result = rawText
    result.insert(contentsOf: insertion, at: insertAt)
    return result
}

/// Renders one spec-map.json `types[]` entry block for a newly generated
/// struct, at the file's existing 4-space entry indent.
func renderSpecMapTypeEntry(schemaName: String, symbol: String, modelFile: String) -> String {
    "    {\n      \"sdk\": [\n        {\n          \"file\": \"\(modelFile)\",\n          \"symbol\": \"\(symbol)\"\n        }\n      ],\n      \"spec\": \"\(schemaName)\"\n    }"
}

/// Applies every operation-insert Finding: inserts the new method into its
/// service file (before the class's final closing brace), appends any newly
/// synthesized model structs to their model file, and appends spec-map.json
/// `types[]` entries for them -- all via raw text edits, matching
/// applyFindings' own style, so a second --apply run (nothing left to do)
/// is a true no-op.
func applyOperationInsertions(_ findings: [Finding], spec: [String: Any], scanned: [String: ScannedType]) {
    let opFindings = findings.filter { $0.kind == .operationInsert }
    guard !opFindings.isEmpty else { return }
    let usages = scanEndpointUsages(under: servicesPath)

    var generatedNames = Set<String>() // schema names already scheduled this run
    var serviceFileMethods: [String: [String]] = [:]
    var modelFileStructs: [String: [GeneratedStruct]] = [:]

    for finding in opFindings {
        guard let method = finding.opMethod, let path = finding.opPath,
              let op = paths(of: spec).dict(path)?[method] as? [String: Any] else { continue }
        guard let plan = planOperationInsert(method: method, path: path, op: op, spec: spec, scanned: scanned, usages: usages, generatedNames: &generatedNames) else { continue }
        serviceFileMethods[plan.serviceFile, default: []].append(plan.methodText)
        for s in plan.newStructs {
            modelFileStructs[plan.modelFile, default: []].append(s)
        }
    }

    // 1. Insert new methods before each affected service class's final "}".
    for (file, methodTexts) in serviceFileMethods {
        guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
        var lines = content.components(separatedBy: "\n")
        guard let closeIdx = lines.lastIndex(where: { $0.trimmingCharacters(in: .whitespaces) == "}" }) else { continue }
        var insertion: [String] = []
        for text in methodTexts {
            insertion.append("")
            insertion.append(contentsOf: text.components(separatedBy: "\n"))
        }
        lines.insert(contentsOf: insertion, at: closeIdx)
        try? lines.joined(separator: "\n").write(toFile: file, atomically: true, encoding: .utf8)
    }

    // 2. Append new struct definitions to each affected model file.
    for (file, structs) in modelFileStructs {
        guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
        var text = content
        if !text.hasSuffix("\n") { text += "\n" }
        for s in structs {
            text += "\n" + renderGeneratedStruct(s) + "\n"
        }
        try? text.write(toFile: file, atomically: true, encoding: .utf8)
    }

    // 3. Append spec-map.json types[] entries for every newly generated struct.
    let allNewStructs = modelFileStructs.values.flatMap { $0 }
    if !allNewStructs.isEmpty, let mapText = try? String(contentsOfFile: specMapPath, encoding: .utf8) {
        let modelFileByStructName: [String: String] = Dictionary(uniqueKeysWithValues: modelFileStructs.flatMap { file, structs in structs.map { ($0.schemaName, file) } })
        let blocks = allNewStructs.map { s -> String in
            renderSpecMapTypeEntry(schemaName: s.schemaName, symbol: s.swiftName, modelFile: modelFileByStructName[s.schemaName] ?? "")
        }
        if let updated = appendToJSONArray(mapText, arrayKeyPattern: #""types"\s*:"#, newEntryBlocks: blocks) {
            try? updated.write(toFile: specMapPath, atomically: true, encoding: .utf8)
        }
    }
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
    let reachable = reachableSchemaNames(new)
    let operationInsertTouched = schemaNamesTouchedByOperationInserts(spec: new)

    for name in newSchemas.keys.sorted() where oldSchemas[name] == nil {
        if known.contains(name) || operationInsertTouched.contains(name) { continue }
        // Unreachable orphan schemas (not $ref'd from any path, webhook, or
        // shared component section, even transitively) require no SDK work:
        // nothing in the public surface can ever produce or accept one.
        if !reachable.contains(name) { continue }
        findings.append(Finding(kind: .needsHuman, message: "new schema \"\(name)\" present in spec, not present in spec-map.json (types or ignore) -- needs mapping"))
    }

    // New operations are handled by operationCoverageFindings (called from
    // reconcile(), against `new`) instead of here: that path classifies
    // each one STANDARD (operation-insert, auto-generatable) vs
    // NON-STANDARD (needs-human with a precise reason) rather than always
    // needing a human, and --check needs the exact same single-spec logic
    // (it has no "old" spec to diff against), so the classification has to
    // live somewhere both modes call.
    let oldPaths = paths(of: old)
    let newPaths = paths(of: new)
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

        // 3. init parameter (always appended last -- Swift requires labeled
        //    arguments in declaration order, so a new parameter inserted
        //    anywhere but the end would silently break every existing call
        //    site that passes any parameter declared after it) + assignment.
        if let range = findParamListRange(lines, containingLineWith: "public init(", from: declIdx, to: closeIdx + shift) {
            let newParamText = "\(name): \(typeText) = nil"
            if range.openLine == range.closeLine {
                // Single-line signature (e.g. CustomerLimits.swift's small
                // structs): splice the new parameter in before the ")" on
                // that same line.
                let chars = Array(lines[range.closeLine])
                let existingParams = String(chars[range.openOffset..<range.closeOffset]).trimmingCharacters(in: .whitespaces)
                let insertText = existingParams.isEmpty ? newParamText : ", " + newParamText
                let before = String(chars[0..<range.closeOffset])
                let after = String(chars[range.closeOffset...])
                lines[range.closeLine] = before + insertText + after
            } else {
                // Multi-line signature, one parameter per line: append a new
                // line right before the line holding the closing ")".
                var lastParamIdx = -1
                for i in stride(from: range.closeLine - 1, through: range.openLine, by: -1) {
                    let t = lines[i].trimmingCharacters(in: .whitespaces)
                    if !t.isEmpty { lastParamIdx = i; break }
                }
                if lastParamIdx != -1 {
                    let paramIndent = indentOf(lines[lastParamIdx])
                    if !lines[lastParamIdx].trimmingCharacters(in: .whitespaces).hasSuffix(",") {
                        lines[lastParamIdx] += ","
                    }
                    lines.insert("\(paramIndent)\(newParamText)", at: lastParamIdx + 1)
                    shift += 1
                }
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

// MARK: - Type audit (non-blocking; full STATE-based type comparison)
//
// The gating type check (in reconcile(), used by --check/--apply) is
// deliberately asymmetric: it only flags a property where the spec now
// allows null but the SDK is non-optional (a real decode-crash risk), so
// that gating a PR doesn't require ~70 known-divergences.json entries whose
// only content is "the SDK is fine being stricter than the spec's required
// array here". That asymmetry is exactly why this separate, non-blocking
// mode exists: gating tells you about NEW drift from a synced baseline, not
// whether today's SDK type surface already disagrees with the spec at all
// (the same blindness event-diffing had before state reconciliation
// replaced it). --audit-types compares every mapped property SYMMETRICALLY
// (both nullability directions) and prints everything, cross-referencing
// known-divergences.json so a reader can see at a glance what is already
// triaged versus new.
struct TypeAuditFinding {
    let locator: String
    let symbol: String
    let field: String
    let propertyName: String
    let reason: String
}

func auditTypes(spec: [String: Any], scanned: [String: ScannedType]) -> [TypeAuditFinding] {
    var findings: [TypeAuditFinding] = []
    for entry in specMapTypes {
        guard let locator = entry.str("spec"), let sdkSites = entry["sdk"] as? [[String: Any]] else { continue }
        guard let node = try? resolveLocator(locator, in: spec) else { continue }
        let specProps = propertiesOf(node)
        if specProps.isEmpty { continue }

        for site in sdkSites {
            guard let symbol = site.str("symbol"), let scannedType = scanned[symbol], scannedType.kind == "struct" else { continue }
            var propertyByWireKey: [String: ScannedProperty] = [:]
            for prop in scannedType.properties {
                let wireKey = scannedType.codingKeysWireKeyOf[prop.name] ?? prop.name
                propertyByWireKey[wireKey] = prop
            }
            for (propName, propNode) in specProps.sorted(by: { $0.key < $1.key }) {
                guard let modeled = propertyByWireKey[propName], let propNodeDict = propNode as? [String: Any] else { continue }
                if let reason = typeMismatchReason(propName: propName, propNode: propNodeDict, swiftTypeText: modeled.typeText, strictNullability: true) {
                    findings.append(TypeAuditFinding(locator: locator, symbol: symbol, field: propName, propertyName: modeled.name, reason: reason))
                }
            }
        }
    }
    return findings
}

func printTypeAudit(spec: [String: Any], scanned: [String: ScannedType]) {
    let findings = auditTypes(spec: spec, scanned: scanned)
    let recorded = findings.filter { isKnownTypeDivergence(locator: $0.locator, field: $0.field) }
    let unrecorded = findings.filter { !isKnownTypeDivergence(locator: $0.locator, field: $0.field) }

    print("sync --audit-types (non-blocking): \(findings.count) mismatch(es) across the mapped surface")
    print("  \(recorded.count) already recorded in known-divergences.json, \(unrecorded.count) NOT YET recorded")
    if !unrecorded.isEmpty {
        print("\n  Not yet recorded in known-divergences.json:")
        for f in unrecorded.sorted(by: { $0.locator == $1.locator ? $0.field < $1.field : $0.locator < $1.locator }) {
            print("    - \(f.symbol).\(f.propertyName) (spec property \"\(f.field)\" on \(f.locator)): \(f.reason)")
        }
    }
    if !recorded.isEmpty {
        print("\n  Already recorded (see known-divergences.json for the reason):")
        for f in recorded.sorted(by: { $0.locator == $1.locator ? $0.field < $1.field : $0.locator < $1.locator }) {
            print("    - \(f.symbol).\(f.propertyName) (spec property \"\(f.field)\" on \(f.locator))")
        }
    }
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

// MARK: - Enum coverage (blocking, folded into --validate-map)
//
// reconcile()'s enum handling only diffs VALUES for enums already wired into
// spec-map.json's enums[]. It has no way to notice a property that is
// enum-constrained in the spec but was never wired in at all -- which
// reconcile()'s Types loop would then treat as a plain unmapped field and
// (if optional) mechanically add as a bare String, silently discarding the
// enum constraint. This closes that gap: every enum-constrained property on
// every mapped schema/locator must resolve to a spec-map enums[] anchor or a
// recorded enum-exclusions.json entry.

/// True if `node` (a property node) is directly enum-valued, array-of-enum
/// (`items.enum`), or has an anyOf/oneOf branch that is.
func isEnumConstrained(_ node: [String: Any]) -> Bool {
    if node["enum"] != nil { return true }
    if let items = node.dict("items"), items["enum"] != nil { return true }
    let branches = (node["anyOf"] as? [Any]) ?? (node["oneOf"] as? [Any]) ?? []
    for b in branches {
        if let bd = b as? [String: Any], isEnumConstrained(bd) { return true }
    }
    return false
}

/// Checks every mapped schema's modeled SDK property type, not merely
/// whether some spec-map.json enums[] entry happens to be anchored at this
/// exact (locator, property) pair: the same enum symbol is deliberately
/// anchored at only ONE canonical schema+property in enums[] (see
/// `registeredEnumSymbols` above) even though dozens of other mapped
/// schemas repeat the same spec enum on a same-named property. Requiring a
/// literal per-locator anchor would demand a redundant enums[] entry for
/// every one of those repeats; checking the SDK's actual declared type
/// against the global registered-enum set gives credit for all of them.
func enumCoverageErrors(spec: [String: Any], scanned: [String: ScannedType]) -> [String] {
    var errors: [String] = []
    for entry in specMapTypes {
        guard let locator = entry.str("spec"), let sdkSites = entry["sdk"] as? [[String: Any]] else { continue }
        guard let node = try? resolveLocator(locator, in: spec) else { continue }
        let specProps = propertiesOf(node)
        if specProps.isEmpty { continue }

        for site in sdkSites {
            guard let symbol = site.str("symbol"), let scannedType = scanned[symbol], scannedType.kind == "struct" else { continue }
            var propertyByWireKey: [String: ScannedProperty] = [:]
            for prop in scannedType.properties {
                let wireKey = scannedType.codingKeysWireKeyOf[prop.name] ?? prop.name
                propertyByWireKey[wireKey] = prop
            }
            for (propName, propNodeAny) in specProps.sorted(by: { $0.key < $1.key }) {
                guard let propNode = propNodeAny as? [String: Any], isEnumConstrained(propNode) else { continue }
                // An unmapped field is reconcile()'s (required/unmodeled) gate to
                // catch, not this one -- avoid double-reporting the same gap.
                guard let modeled = propertyByWireKey[propName] else { continue }
                var base = swiftBaseType(modeled.typeText)
                if base.hasPrefix("["), base.hasSuffix("]") { base = String(base.dropFirst().dropLast()) }
                if registeredEnumSymbols.contains(base) { continue }
                if isEnumCoverageExcluded(locator: locator, field: propName) { continue }
                errors.append("enum coverage: property \"\(propName)\" on \(locator) (SDK: \(symbol).\(modeled.name): \(modeled.typeText)) is enum-constrained in the spec but the SDK type is not a registered spec-map enum, and no enum-exclusions.json entry exists")
            }
        }
    }
    return errors
}

// MARK: - Nested-object coverage (blocking, folded into --validate-map)
//
// spec-map.json's convention for a nested struct is a second, separate
// types[] entry whose locator is the parent's dotted path (e.g.
// "PayoutOut.tracking_payment", "CustomerOut.owners[]"). Nothing previously
// verified that convention was actually followed for every inline
// object/array-of-object shape under a mapped schema, so a newly-added
// nested shape could silently go unmodeled forever. This walks every mapped
// schema's own top-level properties (deeper nesting is covered because any
// already-mapped nested locator is itself a types[] entry walked by this
// same loop) and requires either a types[] entry at the nested dotted
// locator or a recorded nested-omissions.json entry.

/// True if `node` is an inline object schema (has "properties", not a $ref
/// to a named component schema).
func isInlineObjectNode(_ node: [String: Any]) -> Bool {
    node["$ref"] == nil && node["properties"] != nil
}

func nestedShapeErrors(spec: [String: Any]) -> [String] {
    var errors: [String] = []
    let mappedLocators = Set(specMapTypes.compactMap { $0.str("spec") })
    for entry in specMapTypes {
        guard let locator = entry.str("spec") else { continue }
        guard let node = try? resolveLocator(locator, in: spec) else { continue }
        for (propName, propNodeAny) in propertiesOf(node).sorted(by: { $0.key < $1.key }) {
            guard let propNode = propNodeAny as? [String: Any] else { continue }
            // A property the SDK doesn't model at all is unmodeled.json's own
            // gate; there's no nested shape to require a map entry FOR since
            // nothing here represents it in the first place.
            if unmodeledSet.contains("\(locator)\u{0}\(propName)") { continue }
            var childLocator: String? = nil
            if isInlineObjectNode(propNode) {
                childLocator = "\(locator).\(propName)"
            } else if let items = propNode.dict("items"), isInlineObjectNode(items) {
                childLocator = "\(locator).\(propName)[]"
            }
            guard let cl = childLocator else { continue }
            if mappedLocators.contains(cl) { continue }
            if isNestedOmissionExcluded(locator: locator, field: propName) { continue }
            errors.append("nested-object coverage: property \"\(propName)\" on \(locator) is an inline nested object shape (would be \(cl)) with no spec-map.json types[] entry and no nested-omissions.json entry")
        }
    }
    return errors
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
    errors.append(contentsOf: enumCoverageErrors(spec: spec, scanned: scanned))
    errors.append(contentsOf: nestedShapeErrors(spec: spec))

    for entry in operationExclusionsRaw {
        guard let method = entry.str("method"), let path = entry.str("path") else {
            errors.append("malformed operation-exclusions entry: \(entry)"); continue
        }
        guard let ops = paths(of: spec)[path] as? [String: Any], ops[method.lowercased()] != nil else {
            errors.append("operation-exclusions entry \"\(method) \(path)\" does not exist in the spec (stale exclusion)")
            continue
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

case .auditTypes:
    let scanned = scanSources(under: sourcesPath)
    printTypeAudit(spec: snapshot, scanned: scanned)
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
        applyOperationInsertions(applicable, spec: newSpec, scanned: scanned)
        let hasOperationInsert = applicable.contains { $0.kind == .operationInsert }
        // A brand-new endpoint is a new backward-compatible capability, so
        // operation-insert always forces at least a minor bump -- even in
        // the (structurally impossible in practice, since a new operation
        // implies new paths) edge case where classifyBump's own paths-diff
        // check wouldn't otherwise notice.
        let bump = hasOperationInsert ? Bump.minor : classifyBump(old: snapshot, new: newSpec)
        print("sync --apply: applied \(applicable.count) change(s), bump=\(bump.rawValue)")
        for f in applicable { print("  - \(f.message)") }
        report["appliedCount"] = applicable.count
        report["applied"] = applicable.map { $0.message }
        report["needsHuman"] = []
        report["bump"] = bump.rawValue
    }

    // Refresh the snapshot by copying the source spec file's bytes verbatim
    // (never decode-then-re-encode): the snapshot is a committed, human-reviewed
    // artifact, and a JSONSerialization round trip would reformat and reorder
    // every key, turning "nothing in the spec changed" into a multi-thousand-line
    // diff that defeats the point of committing it at all.
    if let specData = FileManager.default.contents(atPath: specPath) {
        try? specData.write(to: URL(fileURLWithPath: snapshotPath))
    }

    if let rp = reportPath {
        let data = try! JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
        try? data.write(to: URL(fileURLWithPath: rp))
    }
    exit(0)
}
