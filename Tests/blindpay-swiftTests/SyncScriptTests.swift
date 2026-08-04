//
//  SyncScriptTests.swift
//  blindpay-swiftTests
//
//  Exercises .api-sync/sync.swift end-to-end (as a subprocess, mirroring how CI
//  invokes it) against small self-contained fixture spec/source trees, since
//  the patcher is a dependency-free script rather than a library target.
//

import Foundation
import Testing

private let packageRoot: String = {
    // Tests/blindpay-swiftTests/SyncScriptTests.swift -> repo root is two levels up.
    let file = URL(fileURLWithPath: #filePath)
    return file.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().path
}()

private let syncScriptPath = packageRoot + "/.api-sync/sync.swift"

private struct RunResult {
    let exitCode: Int32
    let stdout: String
}

@discardableResult
private func runSync(in dir: String, _ args: [String]) -> RunResult {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["swift", syncScriptPath] + args
    process.currentDirectoryURL = URL(fileURLWithPath: dir)
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    try! process.run()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()
    return RunResult(exitCode: process.terminationStatus, stdout: String(data: data, encoding: .utf8) ?? "")
}

private func makeFixtureDir() -> String {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent("sync-test-\(UUID().uuidString)").path
    try! FileManager.default.createDirectory(atPath: dir + "/Models", withIntermediateDirectories: true)
    return dir
}

private func write(_ path: String, _ content: String) {
    try! FileManager.default.createDirectory(atPath: (path as NSString).deletingLastPathComponent, withIntermediateDirectories: true)
    try! content.write(toFile: path, atomically: true, encoding: .utf8)
}

private func readSource(_ dir: String, _ file: String) -> String {
    (try? String(contentsOfFile: dir + "/" + file, encoding: .utf8)) ?? ""
}

private func readReportBump(_ dir: String) -> String? {
    guard let data = FileManager.default.contents(atPath: dir + "/report.json"),
          let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
    return obj["bump"] as? String
}

// MARK: - Fixture Swift sources

private let fixtureThingSource = """
import Foundation

public enum FixtureStatus: String, Codable, Sendable {
    case active = "active"
    case inactive = "inactive"
}

public struct FixtureThing: Codable, Sendable {
    public let id: String
    public let name: String
    public let status: FixtureStatus

    public init(id: String, name: String, status: FixtureStatus) {
        self.id = id
        self.name = name
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
    }
}
"""

private let fixtureBareSource = """
import Foundation

public struct FixtureBareThing: Codable, Sendable {
    public let status: String

    public init(status: String) {
        self.status = status
    }
}
"""

private let fixtureTwoSpaceSource = """
import Foundation

public struct FixtureTwoSpace: Codable, Sendable {
  public let id: String

  public init(id: String) {
    self.id = id
  }

  enum CodingKeys: String, CodingKey {
    case id
  }
}
"""

private let fixtureEncodeIfPresentSource = """
import Foundation

public struct FixtureEncodeIfPresent: Codable, Sendable {
    public let id: String
    public let note: String?

    public init(id: String, note: String? = nil) {
        self.id = id
        self.note = note
    }

    enum CodingKeys: String, CodingKey {
        case id
        case note
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(note, forKey: .note)
    }
}
"""

private let fixtureIfLetEncodeSource = """
import Foundation

public struct FixtureIfLetEncode: Codable, Sendable {
    public let id: String
    public let note: String?

    public init(id: String, note: String? = nil) {
        self.id = id
        self.note = note
    }

    enum CodingKeys: String, CodingKey {
        case id
        case note
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if let note = note {
            try container.encode(note, forKey: .note)
        }
    }
}
"""

private let fixtureAmountEncoderSource = """
import Foundation

public struct CreateQuoteInput: Codable, Sendable {
    public let id: String

    public init(id: String) {
        self.id = id
    }

    enum CodingKeys: String, CodingKey {
        case id
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
}
"""

private let fixtureMultiParamSource = """
import Foundation

public struct FixtureMultiParam: Codable, Sendable {
    public let id: String
    public let alpha: String?
    public let beta: Int?
    public let gamma: Bool?

    public init(
        id: String,
        alpha: String? = nil,
        beta: Int? = nil,
        gamma: Bool? = nil
    ) {
        self.id = id
        self.alpha = alpha
        self.beta = beta
        self.gamma = gamma
    }

    enum CodingKeys: String, CodingKey {
        case id
        case alpha
        case beta
        case gamma
    }
}
"""

private let fixtureNumericSource = """
import Foundation

public struct FixtureNumeric: Codable, Sendable {
    public let count: Int

    public init(count: Int) {
        self.count = count
    }
}
"""

/// Models the SDK endpoint literal for the one real operation ("GET
/// /things") every fixture spec already carries in baseSpec(), so the
/// operation-insert coverage scan (which treats any spec operation with no
/// matching `endpoint:` literal under --services as a brand-new,
/// uncovered operation) doesn't mistake this pre-existing baseline
/// operation for one. Operation-insert-specific tests add their OWN new
/// paths via baseSpec's extraPaths and leave them deliberately uncovered.
private let fixtureThingsServiceSource = """
import Foundation

public final class ThingsService: Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func list() async throws -> APIResponse<[FixtureThing]> {
        return try await apiClient.request(
            endpoint: "/things",
            method: .get
        )
    }
}
"""

private func writeAllFixtureSources(_ dir: String) {
    write(dir + "/Models/Thing.swift", fixtureThingSource)
    write(dir + "/Models/Bare.swift", fixtureBareSource)
    write(dir + "/Models/TwoSpace.swift", fixtureTwoSpaceSource)
    write(dir + "/Models/EncodeIfPresent.swift", fixtureEncodeIfPresentSource)
    write(dir + "/Models/IfLetEncode.swift", fixtureIfLetEncodeSource)
    write(dir + "/Models/AmountEncoder.swift", fixtureAmountEncoderSource)
    write(dir + "/Models/MultiParam.swift", fixtureMultiParamSource)
    write(dir + "/Models/Numeric.swift", fixtureNumericSource)
    write(dir + "/Services/ThingsService.swift", fixtureThingsServiceSource)
}

// MARK: - Fixture spec / spec-map builders

private func schema(_ properties: [String: Any], required: [String] = []) -> [String: Any] {
    var s: [String: Any] = ["type": "object", "properties": properties]
    if !required.isEmpty { s["required"] = required }
    return s
}

/// Baseline spec: matches exactly what the fixture sources already model (no drift).
private func baseSpec(extraSchemas: [String: Any] = [:], extraPaths: [String: Any] = [:],
                       extraComponents: [String: Any] = [:], extraTopLevel: [String: Any] = [:]) -> [String: Any] {
    var schemas: [String: Any] = [
        "ThingOut": schema(["id": ["type": "string"], "name": ["type": "string"],
                            "status": ["type": "string", "enum": ["active", "inactive"]]]),
        "BareThingOut": schema(["status": ["type": "string"]]),
        "TwoSpaceOut": schema(["id": ["type": "string"]]),
        "EncodeIfPresentOut": schema(["id": ["type": "string"], "note": ["type": "string"]]),
        "IfLetEncodeOut": schema(["id": ["type": "string"], "note": ["type": "string"]]),
        "CreateQuoteInputOut": schema(["id": ["type": "string"]]),
        "MultiParamOut": schema(["id": ["type": "string"], "alpha": ["type": "string"],
                                 "beta": ["type": "integer"], "gamma": ["type": "boolean"]]),
        "NumericOut": schema(["count": ["type": "number"]]),
    ]
    for (k, v) in extraSchemas { schemas[k] = v }
    var paths: [String: Any] = [
        "/things": ["get": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/ThingOut"]]]]]]]
    ]
    for (k, v) in extraPaths { paths[k] = v }
    var components: [String: Any] = ["schemas": schemas]
    for (k, v) in extraComponents { components[k] = v }
    var spec: [String: Any] = ["openapi": "3.0.0", "info": ["title": "fixture", "version": "1.0"], "paths": paths, "components": components]
    for (k, v) in extraTopLevel { spec[k] = v }
    return spec
}

private let baseSpecMap: [String: Any] = [
    "enums": [
        ["spec": ["schema": "ThingOut", "property": "status"], "sdk": ["file": "Models/Thing.swift", "symbol": "FixtureStatus"]],
    ],
    "types": [
        ["spec": "ThingOut", "sdk": [["file": "Models/Thing.swift", "symbol": "FixtureThing"]]],
        ["spec": "BareThingOut", "sdk": [["file": "Models/Bare.swift", "symbol": "FixtureBareThing"]]],
        ["spec": "TwoSpaceOut", "sdk": [["file": "Models/TwoSpace.swift", "symbol": "FixtureTwoSpace"]]],
        ["spec": "EncodeIfPresentOut", "sdk": [["file": "Models/EncodeIfPresent.swift", "symbol": "FixtureEncodeIfPresent"]]],
        ["spec": "IfLetEncodeOut", "sdk": [["file": "Models/IfLetEncode.swift", "symbol": "FixtureIfLetEncode"]]],
        ["spec": "CreateQuoteInputOut", "sdk": [["file": "Models/AmountEncoder.swift", "symbol": "CreateQuoteInput"]]],
        ["spec": "MultiParamOut", "sdk": [["file": "Models/MultiParam.swift", "symbol": "FixtureMultiParam"]]],
        ["spec": "NumericOut", "sdk": [["file": "Models/Numeric.swift", "symbol": "FixtureNumeric"]]],
    ],
    "ignore": ["schemas": [] as [Any]],
]

private func writeJSON(_ path: String, _ obj: Any) {
    let data = try! JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
    try! data.write(to: URL(fileURLWithPath: path))
}

private func setupBaseline(_ dir: String, spec: [String: Any]? = nil, specMap: [String: Any]? = nil,
                            unmodeled: [Any] = [], divergences: [Any] = [],
                            enumExclusions: [Any] = [], nestedOmissions: [Any] = [],
                            operationExclusions: [Any] = []) {
    writeAllFixtureSources(dir)
    writeJSON(dir + "/spec-snapshot.json", spec ?? baseSpec())
    writeJSON(dir + "/spec-map.json", specMap ?? baseSpecMap)
    writeJSON(dir + "/unmodeled.json", unmodeled)
    writeJSON(dir + "/known-divergences.json", divergences)
    writeJSON(dir + "/enum-exclusions.json", enumExclusions)
    writeJSON(dir + "/nested-omissions.json", nestedOmissions)
    writeJSON(dir + "/operation-exclusions.json", operationExclusions)
}

private func commonArgs(_ dir: String) -> [String] {
    ["--sources", "Models", "--services", "Services", "--spec-map", "spec-map.json", "--unmodeled", "unmodeled.json", "--known-divergences", "known-divergences.json",
     "--enum-exclusions", "enum-exclusions.json", "--nested-omissions", "nested-omissions.json", "--operation-exclusions", "operation-exclusions.json"]
}

// MARK: - Clean baseline

@Test func checkIsCleanOnMatchingBaseline() {
    let dir = makeFixtureDir()
    setupBaseline(dir)
    let result = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 0)
    #expect(result.stdout.isEmpty)
}

@Test func validateMapPassesOnValidMap() {
    let dir = makeFixtureDir()
    setupBaseline(dir)
    let result = runSync(in: dir, ["--validate-map", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 0)
    #expect(result.stdout.contains("PASS"))
}

@Test func validateMapFailsOnUnresolvableSymbol() {
    let dir = makeFixtureDir()
    var map = baseSpecMap
    map["types"] = [["spec": "ThingOut", "sdk": [["file": "Models/Thing.swift", "symbol": "NoSuchSymbol"]]]]
    setupBaseline(dir, specMap: map)
    let result = runSync(in: dir, ["--validate-map", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 1)
    #expect(result.stdout.contains("NoSuchSymbol"))
}

// MARK: - Applicable: enum case insertion + idempotency

@Test func enumCaseIsInsertedAndCheckGoesGreen() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var schemas = spec["components"] as! [String: Any]
    var thingOut = (schemas["schemas"] as! [String: Any])["ThingOut"] as! [String: Any]
    var props = thingOut["properties"] as! [String: Any]
    props["status"] = ["type": "string", "enum": ["active", "inactive", "pending"]]
    thingOut["properties"] = props
    var innerSchemas = schemas["schemas"] as! [String: Any]
    innerSchemas["ThingOut"] = thingOut
    schemas["schemas"] = innerSchemas
    spec["components"] = schemas

    setupBaseline(dir, spec: baseSpec()) // snapshot = old (2 values), matches SDK exactly
    writeJSON(dir + "/spec-current.json", spec) // new spec = 3 values, not yet committed

    // --check only ever looks at the committed snapshot, so it is clean before
    // the new spec has been applied (the "pending" drift only exists relative
    // to spec-current.json, which --apply consumes separately).
    let check1 = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(check1.exitCode == 0)

    let apply1 = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply1.exitCode == 0)
    #expect(apply1.stdout.contains("applied 1"))
    #expect(readSource(dir, "Models/Thing.swift").contains("case pending = \"pending\""))

    // idempotent: re-running --check against the now-refreshed snapshot is clean.
    let check2 = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(check2.exitCode == 0)

    // idempotent: applying again produces no further changes.
    let apply2 = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply2.exitCode == 0)
    #expect(apply2.stdout.contains("no changes"))
}

// MARK: - Applicable: field insertion, with and without CodingKeys

@Test func fieldInsertionWithCodingKeys() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]],
                                  "email_address": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    let source = readSource(dir, "Models/Thing.swift")
    #expect(source.contains("public let emailAddress: String?"))
    #expect(source.contains("case emailAddress = \"email_address\""))
    #expect(source.contains("emailAddress: String? = nil"))
    #expect(source.contains("self.emailAddress = emailAddress"))

    let check = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(check.exitCode == 0)
}

@Test func fieldInsertionWithoutCodingKeys() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["BareThingOut"] = schema(["status": ["type": "string"], "label": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    let source = readSource(dir, "Models/Bare.swift")
    #expect(source.contains("public let label: String?"))
    #expect(source.contains("label: String? = nil"))
    #expect(source.contains("self.label = label"))
    // No CodingKeys entry should be introduced: the struct had no CodingKeys enum at all.
    #expect(!source.contains("CodingKeys"))
}

// MARK: - Applicable: 2-space indentation preserved

@Test func fieldInsertionRespectsTwoSpaceIndentation() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["TwoSpaceOut"] = schema(["id": ["type": "string"], "tag": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    let source = readSource(dir, "Models/TwoSpace.swift")
    #expect(source.contains("  public let tag: String?"))
    #expect(!source.contains("    public let tag: String?"))
    #expect(source.contains("  case tag"))
}

// MARK: - Applicable: hand-rolled encode(to:) gets the matching encode line

@Test func fieldInsertionAddsEncodeIfPresentLineWhenThatIsTheFileStyle() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["EncodeIfPresentOut"] = schema(["id": ["type": "string"], "note": ["type": "string"], "extra": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    let source = readSource(dir, "Models/EncodeIfPresent.swift")
    #expect(source.contains("try container.encodeIfPresent(extra, forKey: .extra)"))
}

@Test func fieldInsertionAddsIfLetEncodeBlockWhenThatIsTheFileStyle() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["IfLetEncodeOut"] = schema(["id": ["type": "string"], "note": ["type": "string"], "extra": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    let source = readSource(dir, "Models/IfLetEncode.swift")
    #expect(source.contains("if let extra = extra {"))
    #expect(source.contains("try container.encode(extra, forKey: .extra)"))
}

// MARK: - NEEDS_HUMAN: amount-shaped field on a cents-converting encoder

@Test func amountShapedFieldOnQuoteEncoderIsNeedsHuman() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["CreateQuoteInputOut"] = schema(["id": ["type": "string"], "extra_amount": ["type": "number"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("amount-shaped"))
    // nothing should have been written
    #expect(!readSource(dir, "Models/AmountEncoder.swift").contains("extraAmount"))
}

// MARK: - NEEDS_HUMAN: required new property

@Test func requiredNewPropertyIsNeedsHuman() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]],
                                  "must_have": ["type": "string"]], required: ["id", "name", "must_have"])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("REQUIRED"))
    #expect(!readSource(dir, "Models/Thing.swift").contains("mustHave"))
}

// MARK: - NEEDS_HUMAN: anchor not found (stale spec-map entry)

@Test func unresolvableAnchorIsNeedsHuman() {
    let dir = makeFixtureDir()
    var map = baseSpecMap
    map["types"] = [["spec": "NoSuchSchema", "sdk": [["file": "Models/Thing.swift", "symbol": "FixtureThing"]]]]
    setupBaseline(dir, specMap: map)
    let result = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 1)
    #expect(result.stdout.contains("anchor not found") || result.stdout.contains("not found"))
}

// MARK: - NEEDS_HUMAN: removal, new schema, new operation, required-ness change, enum removal

@Test func propertyRemovalIsNeedsHuman() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]]]) // "name" removed
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("removed from ThingOut"))
}

@Test func newUnmappedSchemaIsNeedsHuman() {
    // Reachable via a path response, so the new-schema gate still applies.
    let dir = makeFixtureDir()
    let spec = baseSpec(
        extraSchemas: ["BrandNewOut": schema(["id": ["type": "string"]])],
        extraPaths: ["/brand-new": ["get": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/BrandNewOut"]]]]]]]]
    )
    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("new schema \"BrandNewOut\""))
}

// MARK: - Reachability

@Test func orphanUnreachableSchemaProducesNoFinding() {
    // Not referenced from any path, webhook, or shared component section --
    // an orphan schema requires no SDK work at all.
    let dir = makeFixtureDir()
    let spec = baseSpec(extraSchemas: ["OrphanOut": schema(["id": ["type": "string"]])])
    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    #expect(!apply.stdout.contains("OrphanOut"))
}

@Test func webhookOnlyReachableSchemaIsNeedsHuman() {
    // Reachable ONLY via the top-level "webhooks" section, never from a path.
    let dir = makeFixtureDir()
    let spec = baseSpec(
        extraSchemas: ["WebhookOnlyOut": schema(["id": ["type": "string"]])],
        extraTopLevel: ["webhooks": ["thing.new": ["post": ["requestBody": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/WebhookOnlyOut"]]]]]]]]
    )
    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("new schema \"WebhookOnlyOut\""))
}

@Test func parameterOnlyReachableSchemaIsNeedsHuman() {
    // Reachable ONLY via a shared components/parameters entry, never inlined
    // in any single path's own request/response body.
    let dir = makeFixtureDir()
    let spec = baseSpec(
        extraSchemas: ["ParamOnlyOut": schema(["id": ["type": "string"]])],
        extraComponents: ["parameters": ["FilterParam": ["name": "filter", "in": "query", "schema": ["$ref": "#/components/schemas/ParamOnlyOut"]]]]
    )
    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("new schema \"ParamOnlyOut\""))
}

@Test func transitivelyReachableSchemaIsNeedsHuman() {
    // BrandNewOut is reachable from a path only through an intermediate
    // schema ("WrapperOut") it is nested inside -- two $ref hops away.
    let dir = makeFixtureDir()
    let spec = baseSpec(
        extraSchemas: [
            "BrandNewOut": schema(["id": ["type": "string"]]),
            "WrapperOut": schema(["inner": ["$ref": "#/components/schemas/BrandNewOut"]]),
        ],
        extraPaths: ["/wrapper": ["get": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/WrapperOut"]]]]]]]]
    )
    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("new schema \"BrandNewOut\""))
    #expect(apply.stdout.contains("new schema \"WrapperOut\""))
}

@Test func newOperationIsNeedsHuman() {
    let dir = makeFixtureDir()
    let spec = baseSpec(extraPaths: ["/new-thing": ["post": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/ThingOut"]]]]]]]])
    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("new operation \"POST /new-thing\""))
}

@Test func requiredNessChangeIsNeedsHuman() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]]], required: ["id", "name"])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec()) // no "required" array at all on the old ThingOut
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("required-ness"))
}

@Test func enumMemberRemovalIsNeedsHuman() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active"]]]) // "inactive" removed
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("enum member \"inactive\" removed"))
}

// MARK: - Snapshot refresh copies bytes verbatim (never a decode/re-encode round trip)

@Test func applyRefreshesSnapshotAsByteIdenticalCopyOfSpecFile() {
    let dir = makeFixtureDir()
    writeAllFixtureSources(dir)
    // Scoped to just ThingOut/FixtureStatus, matching the hand-crafted spec
    // below -- not the full baseSpecMap, which references five other schemas
    // this minimal spec doesn't define.
    let minimalMap: [String: Any] = [
        "enums": [
            ["spec": ["schema": "ThingOut", "property": "status"], "sdk": ["file": "Models/Thing.swift", "symbol": "FixtureStatus"]],
        ],
        "types": [
            ["spec": "ThingOut", "sdk": [["file": "Models/Thing.swift", "symbol": "FixtureThing"]]],
        ],
        "ignore": ["schemas": [] as [Any]],
    ]
    writeJSON(dir + "/spec-map.json", minimalMap)
    writeJSON(dir + "/unmodeled.json", [] as [Any])
    writeJSON(dir + "/known-divergences.json", [] as [Any])

    // Deliberately non-canonical formatting (unsorted keys, unusual spacing,
    // no trailing newline) that a JSONSerialization round trip would rewrite.
    // If sync.swift ever regresses to decode-then-re-encode when refreshing
    // the snapshot, this byte-for-byte comparison catches it immediately.
    let handCraftedSpec = """
    {"paths":{"/things":{"get":{"responses":{"200":{"content":{"application/json":{"schema":{"$ref":"#/components/schemas/ThingOut"}}}}}}}},"openapi":"3.0.0","info":{"version":"1.0","title":"fixture"},"components":{"schemas":{"ThingOut":{"required":[],"type":"object","properties":{"status":{"enum":["active","inactive"],"type":"string"},"name":{"type":"string"},"id":{"type":"string"}}}}}}
    """
    write(dir + "/spec-current.json", handCraftedSpec)
    write(dir + "/spec-snapshot.json", handCraftedSpec) // same content, so there is no pending drift

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)

    let specBytes = FileManager.default.contents(atPath: dir + "/spec-current.json")
    let snapshotBytes = FileManager.default.contents(atPath: dir + "/spec-snapshot.json")
    #expect(specBytes != nil)
    #expect(snapshotBytes == specBytes)
}

// MARK: - Init parameter is always appended at the end (never inserted mid-signature)

@Test func newInitParameterIsAppendedLastAndExistingParametersAreUnmovedOnAStructWithSeveralParameters() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["MultiParamOut"] = schema(["id": ["type": "string"], "alpha": ["type": "string"],
                                       "beta": ["type": "integer"], "gamma": ["type": "boolean"],
                                       "delta": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)

    let source = readSource(dir, "Models/MultiParam.swift")
    let initRange = source.range(of: "public init(")!
    let closeParenRange = source.range(of: ")", range: initRange.upperBound..<source.endIndex)!
    let signature = String(source[initRange.upperBound..<closeParenRange.lowerBound])
    let paramLabels = signature.components(separatedBy: ",").map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":").first ?? ""
    }
    #expect(paramLabels == ["id", "alpha", "beta", "gamma", "delta"])
    #expect(source.contains("delta: String? = nil"))
}

// MARK: - Type mismatch detection

@Test func stringToIntegerOnAPlainPropertyIsNeedsHuman() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "integer"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("type mismatch"))
    #expect(apply.stdout.contains("spec type \"integer\" vs SDK type String"))
}

@Test func nullableSpecPropertyAgainstNonOptionalSDKTypeIsNeedsHuman() {
    // This is the direction --check/--apply gate on: the spec relaxes a
    // property to allow null while the SDK stays non-optional, which is a
    // real Codable decode-crash risk. (The reverse direction -- SDK optional
    // while the spec's type still excludes null -- is a long-standing,
    // harmless convention across ~70 fields in this SDK; --audit-types
    // reports that direction too, non-blockingly, for full visibility.)
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": ["string", "null"]],
                                  "status": ["type": "string", "enum": ["active", "inactive"]]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec()) // FixtureThing.name is non-optional String
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("nullability mismatch"))
    #expect(apply.stdout.contains("spec allows null"))
}

@Test func enumTypedPropertyChangingToABareStringIsNeedsHuman() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string"]]) // "enum" removed
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec()) // FixtureThing.status: FixtureStatus (a registered enum)
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("no longer enum-valued"))
}

@Test func numberSpecTypeAgainstIntSDKTypeIsDeliberatelyCompatible() {
    // A case this checker treats as compatible on purpose: JSON Schema does
    // not distinguish integral from fractional "number" values, and this SDK
    // has existing fields that are Int (smallest-unit) against a spec
    // "number" property.
    let dir = makeFixtureDir()
    setupBaseline(dir) // baseSpec() already has NumericOut.count: "number" vs FixtureNumeric.count: Int
    let check = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(check.exitCode == 0)
    #expect(check.stdout.isEmpty)
}

// MARK: - Bump classification

@Test func bumpIsNoneWhenSpecIsUnchanged() {
    let dir = makeFixtureDir()
    setupBaseline(dir)
    writeJSON(dir + "/spec-current.json", baseSpec())
    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json", "--report", "report.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    #expect(readReportBump(dir) == "none")
}

@Test func bumpIsMinorWhenAnEnumMemberIsAdded() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive", "pending"]]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json", "--report", "report.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    #expect(readReportBump(dir) == "minor")
}

@Test func bumpIsPatchForFieldOnlyAdditions() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]],
                                  "email_address": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json", "--report", "report.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    #expect(readReportBump(dir) == "patch")
}

// MARK: - unmodeled.json / known-divergences.json honoring

@Test func unmodeledEntrySuppressesFieldFinding() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]],
                                  "internal_note": ["type": "string"]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: spec, unmodeled: [["schema": "ThingOut", "field": "internal_note", "reason": "internal only", "owner": "eric@blindpay.com"]])
    let check = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(check.exitCode == 0)
}

@Test func knownDivergenceSuppressesEnumFinding() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string"], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive", "pending"]]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: spec, divergences: [["enum": "FixtureStatus", "kind": "deferred-addition", "specValues": ["pending"], "reason": "deferred", "owner": "eric@blindpay.com"]])
    let check = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(check.exitCode == 0)
}

// MARK: - Enum coverage (blocking, folded into --validate-map)

@Test func enumCoverageFlagsAnEnumConstrainedPropertyModeledAsABareType() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    // "id" is spec-enum-constrained but FixtureThing.id is a bare String,
    // not a registered spec-map enum symbol.
    schemas["ThingOut"] = schema(["id": ["type": "string", "enum": ["a", "b"]], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: spec)
    let result = runSync(in: dir, ["--validate-map", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 1)
    #expect(result.stdout.contains("enum coverage"))
    #expect(result.stdout.contains("\"id\" on ThingOut"))
}

@Test func enumExclusionEntrySuppressesEnumCoverageFinding() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["ThingOut"] = schema(["id": ["type": "string", "enum": ["a", "b"]], "name": ["type": "string"],
                                  "status": ["type": "string", "enum": ["active", "inactive"]]])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: spec, enumExclusions: [["schema": "ThingOut", "field": "id", "reason": "legacy bare id", "owner": "eric@blindpay.com"]])
    let result = runSync(in: dir, ["--validate-map", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 0)
}

// MARK: - Nested-object coverage (blocking, folded into --validate-map)

@Test func nestedObjectCoverageFlagsAnUnmappedInlineObjectShape() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["BareThingOut"] = schema(["status": ["type": "string"], "detail": schema(["note": ["type": "string"]])])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: spec)
    let result = runSync(in: dir, ["--validate-map", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 1)
    #expect(result.stdout.contains("nested-object coverage"))
    #expect(result.stdout.contains("\"detail\" on BareThingOut"))
}

@Test func nestedOmissionEntrySuppressesNestedObjectCoverageFinding() {
    let dir = makeFixtureDir()
    var spec = baseSpec()
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["BareThingOut"] = schema(["status": ["type": "string"], "detail": schema(["note": ["type": "string"]])])
    comps["schemas"] = schemas
    spec["components"] = comps

    setupBaseline(dir, spec: spec, nestedOmissions: [["schema": "BareThingOut", "field": "detail", "reason": "not modeled", "owner": "eric@blindpay.com"]])
    let result = runSync(in: dir, ["--validate-map", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 0)
}

// MARK: - Operation-insert: new operations with no SDK endpoint at all

@Test func pendingOperationInsertFailsCheck() {
    let dir = makeFixtureDir()
    let spec = baseSpec(extraPaths: [
        "/things/{id}": ["get": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/ThingOut"]]]]]]],
    ])
    setupBaseline(dir, spec: spec)
    let result = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 1)
    #expect(result.stdout.contains("operation-insert"))
    #expect(result.stdout.contains("GET /things/{id}"))
}

@Test func standardGetOperationIsAutoGeneratedReusingAnExistingMappedType() {
    let dir = makeFixtureDir()
    setupBaseline(dir) // snapshot = baseline ("GET /things" only, already covered)
    let spec = baseSpec(extraPaths: [
        "/things/{id}": ["get": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/ThingOut"]]]]]]],
    ])
    writeJSON(dir + "/spec-current.json", spec)

    let apply1 = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json", "--report", "report.json"] + commonArgs(dir))
    #expect(apply1.exitCode == 0)
    #expect(apply1.stdout.contains("operation-insert"))
    #expect(readReportBump(dir) == "minor")

    let service = readSource(dir, "Services/ThingsService.swift")
    #expect(service.contains("public func get(id: String) async throws -> APIResponse<FixtureThing>"))
    #expect(service.contains("endpoint: \"/things/\\(id)\""))
    #expect(service.contains("method: .get"))
    // No new model needed: the response reuses the already-mapped FixtureThing.
    #expect(!readSource(dir, "Models/Thing.swift").contains("Auto-generated by sync.swift"))

    // idempotent: re-running --check against the refreshed snapshot is clean.
    let check2 = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(check2.exitCode == 0)

    // idempotent: applying again against the same (now-committed) spec produces no further changes.
    let apply2 = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply2.exitCode == 0)
    #expect(apply2.stdout.contains("no changes"))
}

@Test func standardPostOperationSynthesizesNewInputModelAndSpecMapEntry() {
    let dir = makeFixtureDir()
    setupBaseline(dir)
    var spec = baseSpec(extraPaths: [
        "/things/bulk": ["post": [
            "requestBody": ["required": true, "content": ["application/json": ["schema": ["$ref": "#/components/schemas/NewThingIn"]]]],
            "responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/ThingOut"]]]]],
        ]],
    ])
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["NewThingIn"] = schema(["name": ["type": "string"]], required: ["name"])
    comps["schemas"] = schemas
    spec["components"] = comps
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json", "--report", "report.json"] + commonArgs(dir))
    #expect(apply.exitCode == 0)
    #expect(readReportBump(dir) == "minor")

    let service = readSource(dir, "Services/ThingsService.swift")
    #expect(service.contains("public func createBulk(data: NewThingInput) async throws -> APIResponse<FixtureThing>"))
    #expect(service.contains("endpoint: \"/things/bulk\""))
    #expect(service.contains("method: .post,"))
    #expect(service.contains("body: data"))

    let model = readSource(dir, "Models/Thing.swift")
    #expect(model.contains("public struct NewThingInput: Codable, Sendable, Equatable"))
    #expect(model.contains("public let name: String"))
    #expect(model.contains("try container.encode(name, forKey: .name)"))

    let specMap = readSource(dir, "spec-map.json")
    #expect(specMap.contains("\"symbol\": \"NewThingInput\""))
    #expect(specMap.contains("\"spec\": \"NewThingIn\""))

    // idempotent: a second apply against the same committed spec is a no-op.
    let apply2 = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply2.exitCode == 0)
    #expect(apply2.stdout.contains("no changes"))
}

@Test func multipartRequestBodyOperationIsNeedsHumanWithPreciseReason() {
    let dir = makeFixtureDir()
    setupBaseline(dir)
    let spec = baseSpec(extraPaths: [
        "/things/upload": ["post": [
            "requestBody": ["content": ["multipart/form-data": ["schema": ["type": "object"]]]],
            "responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/ThingOut"]]]]],
        ]],
    ])
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("new operation \"POST /things/upload\" needs a human decision: multipart/form-data request body not supported by the generator (JSON-only)"))
}

@Test func operationExclusionEntrySuppressesOperationInsertFinding() {
    let dir = makeFixtureDir()
    let spec = baseSpec(extraPaths: [
        "/things/{id}": ["get": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/ThingOut"]]]]]]],
    ])
    setupBaseline(dir, spec: spec, operationExclusions: [["method": "GET", "path": "/things/{id}", "reason": "deferred", "owner": "eric@blindpay.com"]])
    let result = runSync(in: dir, ["--check", "--snapshot", "spec-snapshot.json"] + commonArgs(dir))
    #expect(result.exitCode == 0)
}

@Test func enumConstrainedNewFieldRoutesToNeedsHumanNotSilentStringField() {
    let dir = makeFixtureDir()
    var spec = baseSpec(extraPaths: [
        "/things/kinds": ["get": ["responses": ["200": ["content": ["application/json": ["schema": ["$ref": "#/components/schemas/KindOut"]]]]]]],
    ])
    var comps = spec["components"] as! [String: Any]
    var schemas = comps["schemas"] as! [String: Any]
    schemas["KindOut"] = schema(["kind": ["type": "string", "enum": ["a", "b"]]])
    comps["schemas"] = schemas
    spec["components"] = comps
    setupBaseline(dir, spec: baseSpec())
    writeJSON(dir + "/spec-current.json", spec)

    let apply = runSync(in: dir, ["--apply", "--snapshot", "spec-snapshot.json", "--spec", "spec-current.json"] + commonArgs(dir))
    #expect(apply.exitCode == 1)
    #expect(apply.stdout.contains("is enum-constrained; enum naming/placement requires a human decision"))
}
