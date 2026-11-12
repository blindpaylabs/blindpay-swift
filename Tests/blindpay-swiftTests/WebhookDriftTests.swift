//
//  WebhookDriftTests.swift
//  blindpay-swift
//
//  Every *WebhookOut schema is mapped in spec-map.json (not ignored), so a
//  field that only a webhook payload gains still fails `sync.swift --check`.
//

import Foundation
import Testing

private let packageRoot = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().path

struct WebhookDriftTests {
    @Test func aWebhookOnlyFieldFailsTheSyncCheck() throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: packageRoot + "/.api-sync/spec-snapshot.json"))
        var spec = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        var components = try #require(spec["components"] as? [String: Any])
        var schemas = try #require(components["schemas"] as? [String: Any])
        var webhook = try #require(schemas["LimitIncreaseUpdateWebhookOut"] as? [String: Any])
        var properties = try #require(webhook["properties"] as? [String: Any])
        properties["zz_webhook_only_field"] = ["type": ["string", "null"]]
        webhook["properties"] = properties
        schemas["LimitIncreaseUpdateWebhookOut"] = webhook
        components["schemas"] = schemas
        spec["components"] = components
        let path = FileManager.default.temporaryDirectory.appendingPathComponent("webhook-drift-\(UUID().uuidString).json").path
        try JSONSerialization.data(withJSONObject: spec).write(to: URL(fileURLWithPath: path))

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", ".api-sync/sync.swift", "--check", "--snapshot", path]
        process.currentDirectoryURL = URL(fileURLWithPath: packageRoot)
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        try process.run()
        let output = String(decoding: pipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        process.waitUntilExit()

        #expect(process.terminationStatus == 1)
        #expect(output.contains("zz_webhook_only_field"), "\(output)")
        #expect(output.contains("LimitIncreaseUpdateWebhookOut"), "\(output)")
    }
}
