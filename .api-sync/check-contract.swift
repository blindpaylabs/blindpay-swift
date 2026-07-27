#!/usr/bin/env swift
//
// check-contract.swift
//
// Mechanical wire-contract check for the BlindPay Swift SDK.
//
// Verifies that every wire key this SDK declares (CodingKeys string values and
// query-parameter dictionary literals) actually exists somewhere in the committed
// API spec snapshot, and that mapped SDK enums (WebhookEvent, CurrencyType) cover
// every enum member the spec declares for them.
//
// Usage:
//   swift .api-sync/check-contract.swift
//   swift .api-sync/check-contract.swift --snapshot path/to/spec.json --sources path/to/Sources
//
// No third-party dependencies. Uses only Foundation, which ships with the Swift
// toolchain this package already requires to build.

import Foundation

// MARK: - CLI args

var snapshotPath = ".api-sync/spec-snapshot.json"
var sourcesPath = "Sources/BlindPay"
var allowListPath = ".api-sync/allow-list.json"

do {
    let args = CommandLine.arguments
    var i = 1
    while i < args.count {
        switch args[i] {
        case "--snapshot":
            i += 1
            if i < args.count { snapshotPath = args[i] }
        case "--sources":
            i += 1
            if i < args.count { sourcesPath = args[i] }
        case "--allow-list":
            i += 1
            if i < args.count { allowListPath = args[i] }
        default:
            break
        }
        i += 1
    }
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write("check-contract: \(message)\n".data(using: .utf8)!)
    exit(2)
}

// MARK: - Load snapshot

guard let snapshotData = FileManager.default.contents(atPath: snapshotPath) else {
    fail("could not read snapshot at \(snapshotPath)")
}
guard let snapshotJSON = try? JSONSerialization.jsonObject(with: snapshotData) else {
    fail("could not parse snapshot JSON at \(snapshotPath)")
}

// MARK: - Walk the snapshot to build the global "known wire key" set
//
// Direction A only asks "does this key exist as a property name (or a query/path
// parameter name) ANYWHERE in the snapshot", not "in this exact schema". That is a
// deliberately loose, global check -- see CLAUDE.md for the design rationale.

var knownWireKeys = Set<String>()

// Also collect, for the mapped-enum check (Direction B), every array of strings
// found under a JSON key named "events" (the webhook subscription enum) or under
// "currency_type" (both directly modeled 1:1 by an SDK enum below).
var specEnumValues: [String: Set<String>] = [:]

func recordEnum(_ key: String, _ value: Any) {
    guard let arr = value as? [Any] else { return }
    let strings = arr.compactMap { $0 as? String }
    guard strings.count == arr.count, !strings.isEmpty else { return }
    specEnumValues[key, default: []].formUnion(strings)
}

func walk(_ node: Any) {
    if let dict = node as? [String: Any] {
        if let properties = dict["properties"] as? [String: Any] {
            knownWireKeys.formUnion(properties.keys)
        }
        // Parameter objects: { "name": "...", "in": "query"|"path", ... }
        if let name = dict["name"] as? String, dict["in"] != nil {
            knownWireKeys.insert(name)
        }
        // Mapped-enum sources: "events": { "items": { "enum": [...] } } and
        // "currency_type": { "enum": [...] }.
        if let events = dict["events"] {
            if let inner = events as? [String: Any], let items = inner["items"] as? [String: Any], let e = items["enum"] {
                recordEnum("events", e)
            }
        }
        if let currencyType = dict["currency_type"] as? [String: Any], let e = currencyType["enum"] {
            recordEnum("currency_type", e)
        }
        for (_, v) in dict { walk(v) }
    } else if let arr = node as? [Any] {
        for v in arr { walk(v) }
    }
}

walk(snapshotJSON)

// MARK: - Load allow-list

struct AllowEntry {
    let schema: String
    let field: String
    let reason: String
    let owner: String
}

var allowList: [AllowEntry] = []
if let allowData = FileManager.default.contents(atPath: allowListPath),
   let allowJSON = try? JSONSerialization.jsonObject(with: allowData) as? [[String: Any]] {
    for entry in allowJSON {
        guard let schema = entry["schema"] as? String,
              let field = entry["field"] as? String,
              let reason = entry["reason"] as? String,
              let owner = entry["owner"] as? String else {
            fail("malformed allow-list entry, expected {schema, field, reason, owner}: \(entry)")
        }
        allowList.append(AllowEntry(schema: schema, field: field, reason: reason, owner: owner))
    }
} else if FileManager.default.fileExists(atPath: allowListPath) {
    fail("could not parse allow-list JSON at \(allowListPath) (expected an array of {schema, field, reason, owner})")
}

let allowedPairs = Set(allowList.map { "\($0.schema).\($0.field)" })

// MARK: - Scan SDK sources for declared wire keys

struct DeclaredKey {
    let type: String
    let wireKey: String
    let file: String
    let line: Int
}

let typeDeclRegex = try! NSRegularExpression(
    pattern: #"^\s*(?:public\s+)?(?:final\s+)?(?:struct|class|enum)\s+(\w+)"#
)
let codingKeyRegex = try! NSRegularExpression(
    pattern: #"^\s*case\s+\w+\s*=\s*"([^"]+)""#
)
let queryParamRegex = try! NSRegularExpression(
    pattern: #"params\["([^"]+)"\]\s*="#
)

func matches(_ regex: NSRegularExpression, in line: String) -> [String] {
    let range = NSRange(line.startIndex..<line.endIndex, in: line)
    return regex.matches(in: line, range: range).compactMap { match in
        guard match.numberOfRanges > 1, let r = Range(match.range(at: 1), in: line) else { return nil }
        return String(line[r])
    }
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

var declaredKeys: [DeclaredKey] = []

for file in swiftFiles(under: sourcesPath) {
    guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
    let lines = content.components(separatedBy: "\n")

    // Stack of (typeName, braceDepthAtOpen). depth counted by cumulative "{" - "}".
    var typeStack: [(name: String, depth: Int)] = []
    var depth = 0

    for (idx, line) in lines.enumerated() {
        let lineNumber = idx + 1

        if let m = typeDeclRegex.firstMatch(in: line, range: NSRange(line.startIndex..<line.endIndex, in: line)),
           let r = Range(m.range(at: 1), in: line) {
            typeStack.append((name: String(line[r]), depth: depth))
        }

        // CodingKeys `case foo = "wire_key"` lines are only meaningful wire-key
        // declarations when we're actually inside an `enum CodingKeys` block --
        // an ordinary `String`-backed model enum (e.g. `PayinStatus`) also matches
        // `case x = "y"` syntactically but its raw values aren't struct fields.
        if typeStack.last?.name == "CodingKeys", typeStack.count >= 2 {
            let enclosing = typeStack[typeStack.count - 2].name
            for wireKey in matches(codingKeyRegex, in: line) {
                declaredKeys.append(DeclaredKey(type: enclosing, wireKey: wireKey, file: file, line: lineNumber))
            }
        }
        if let top = typeStack.last {
            for wireKey in matches(queryParamRegex, in: line) {
                declaredKeys.append(DeclaredKey(type: top.name, wireKey: wireKey, file: file, line: lineNumber))
            }
        }

        depth += line.filter { $0 == "{" }.count
        depth -= line.filter { $0 == "}" }.count
        while let top = typeStack.last, depth <= top.depth {
            typeStack.removeLast()
        }
    }
}

// MARK: - Direction A: every declared wire key must exist in the snapshot (or be allow-listed)

var hardFailures: [String] = []
var usedAllowEntries = Set<String>()

for declared in declaredKeys {
    if knownWireKeys.contains(declared.wireKey) { continue }
    let pairKey = "\(declared.type).\(declared.wireKey)"
    if allowedPairs.contains(pairKey) {
        usedAllowEntries.insert(pairKey)
        continue
    }
    hardFailures.append(
        "\(declared.file):\(declared.line): \(declared.type) declares wire key \"\(declared.wireKey)\" "
            + "which does not exist anywhere in \(snapshotPath)"
    )
}

// MARK: - Direction B: mapped SDK enums must cover every spec enum member (hard failure)

struct MappedEnum {
    let sdkEnumName: String
    let specKey: String
}

let mappedEnums: [MappedEnum] = [
    MappedEnum(sdkEnumName: "WebhookEvent", specKey: "events"),
    MappedEnum(sdkEnumName: "CurrencyType", specKey: "currency_type"),
]

func sdkEnumRawValues(named enumName: String, under path: String) -> Set<String>? {
    let declRegex = try! NSRegularExpression(pattern: #"^\s*(?:public\s+)?enum\s+\#(enumName)\b"#)
    let caseRegex = try! NSRegularExpression(pattern: #"^\s*case\s+\w+\s*=\s*"([^"]+)""#)

    for file in swiftFiles(under: path) {
        guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
        let lines = content.components(separatedBy: "\n")
        var inEnum = false
        var depth = 0
        var enumOpenDepth = 0
        var values = Set<String>()

        for line in lines {
            if !inEnum, declRegex.firstMatch(in: line, range: NSRange(line.startIndex..<line.endIndex, in: line)) != nil {
                inEnum = true
                enumOpenDepth = depth
            }
            if inEnum {
                values.formUnion(matches(caseRegex, in: line))
            }
            depth += line.filter { $0 == "{" }.count
            depth -= line.filter { $0 == "}" }.count
            if inEnum, depth <= enumOpenDepth, line.contains("}") {
                return values
            }
        }
        if inEnum { return values }
    }
    return nil
}

var enumFailures: [String] = []

for mapped in mappedEnums {
    guard let specValues = specEnumValues[mapped.specKey], !specValues.isEmpty else {
        // Nothing in the snapshot uses this key -- nothing to check against.
        continue
    }
    guard let sdkValues = sdkEnumRawValues(named: mapped.sdkEnumName, under: sourcesPath) else {
        enumFailures.append("mapped enum \"\(mapped.sdkEnumName)\" was not found under \(sourcesPath)")
        continue
    }
    let missing = specValues.subtracting(sdkValues)
    if !missing.isEmpty {
        enumFailures.append(
            "enum \(mapped.sdkEnumName) is missing \(missing.count) member(s) present in the spec's "
                + "\"\(mapped.specKey)\" enum: \(missing.sorted().joined(separator: ", "))"
        )
    }
}

// MARK: - Report

var unusedAllowEntries: [AllowEntry] = []
for entry in allowList where !usedAllowEntries.contains("\(entry.schema).\(entry.field)") {
    unusedAllowEntries.append(entry)
}

print("check-contract: \(declaredKeys.count) declared wire key(s) scanned, \(knownWireKeys.count) known key(s) in snapshot")

if !unusedAllowEntries.isEmpty {
    print("check-contract: warning - \(unusedAllowEntries.count) allow-list entry(ies) matched nothing and can be removed:")
    for entry in unusedAllowEntries {
        print("  - \(entry.schema).\(entry.field) (\(entry.reason), owner: \(entry.owner))")
    }
}

if hardFailures.isEmpty && enumFailures.isEmpty {
    print("check-contract: PASS")
    exit(0)
}

print("check-contract: FAIL")
if !hardFailures.isEmpty {
    print("\nDirection A -- wire keys not found in the spec snapshot:")
    for f in hardFailures { print("  - \(f)") }
}
if !enumFailures.isEmpty {
    print("\nDirection B -- mapped enums missing spec members:")
    for f in enumFailures { print("  - \(f)") }
}
exit(1)
