//
//  Fixtures.swift
//  blindpay-swift
//
//  Loader for the shared spec-shaped fixtures in Tests/blindpay-swiftTests/Fixtures
//  (a verbatim copy of sdk-parity/reference/fixtures; see its README.md).
//

import Foundation

enum Fixtures {
    struct Missing: Error, CustomStringConvertible {
        let description: String
    }

    static var root: URL {
        Bundle.module.url(forResource: "Fixtures", withExtension: nil)!
    }

    /// The variants every touched response type must decode. `unknown_enum`
    /// joins once enums are forward-compatible (C7).
    static let decodeSafetyVariants = ["full", "required_only", "nullables_null", "decimals"]

    /// Returns the raw JSON bytes of one response variant for an operation
    /// keyed as in index.json, e.g. `"GET /v1/available/naics"`.
    static func response(_ operation: String, variant: String, status: String = "200") throws -> Data {
        guard let value = try variants(operation, status: status)[variant] else {
            throw Missing(description: "no variant \(variant) for \(operation) (\(status))")
        }
        return try JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed])
    }

    /// Variant names for an operation, filtered to `base`. List operations
    /// carry `.b0` (envelope) and `.b1` (bare array) suffixes.
    static func variantNames(_ operation: String, base: [String] = decodeSafetyVariants) throws -> [String] {
        try variants(operation).keys
            .filter { name in base.contains { name == $0 || name.hasPrefix($0 + ".") } }
            .sorted()
    }

    /// The `variants` object of an operation's fixture file.
    private static func variants(_ operation: String, status: String = "200") throws -> [String: Any] {
        let index = try json(at: root.appendingPathComponent("index.json"))
        guard let operations = index["operations"] as? [String: String],
              let file = operations[operation] else {
            throw Missing(description: "no fixture for operation \(operation)")
        }
        let fixture = try json(at: root.appendingPathComponent(file))
        guard let responses = fixture["responses"] as? [String: Any],
              let byStatus = responses[status] as? [String: Any],
              let variants = byStatus["variants"] as? [String: Any] else {
            throw Missing(description: "no \(status) variants for \(operation)")
        }
        return variants
    }

    static func json(at url: URL) throws -> [String: Any] {
        let data = try Data(contentsOf: url)
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw Missing(description: "fixture \(url.lastPathComponent) is not a JSON object")
        }
        return object
    }
}
