//
//  OpenEnum.swift
//  blindpay-swift
//

import Foundation

/// A string enum that also accepts values this SDK version doesn't know.
///
/// The API adds enum values (networks, tokens, statuses, webhook events)
/// without a major version, so every enum the SDK decodes is open: an
/// unknown value decodes to an instance carrying its raw string instead of
/// failing the whole response.
///
/// Known values are static members, so call sites read like enum cases:
///
/// ```swift
/// switch payout.status {
/// case .completed: ...
/// case .failed: ...
/// default: print("unhandled status \(payout.status.rawValue)")
/// }
/// ```
///
/// A `switch` therefore needs a `default` branch. Build any value with
/// `Network(rawValue: "new_network")` or the string literal `"new_network"`.
public protocol OpenEnum: RawRepresentable, Codable, Hashable, Sendable, CustomStringConvertible, ExpressibleByStringLiteral
    where RawValue == String {
    init(rawValue: String)
}

extension OpenEnum {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }

    public var description: String { rawValue }
}
