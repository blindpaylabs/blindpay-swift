//
//  Endpoint.swift
//  blindpay-swift
//

import Foundation

/// A request path such as `"/v1/instances/\(instanceId)/payouts/\(id)"`.
///
/// Literal text is kept as written; every interpolated value is a single
/// path segment and is percent-encoded, so an id containing `/`, `?` or `#`
/// can't change the route (plan C9).
struct Endpoint: ExpressibleByStringInterpolation, Sendable, Equatable {
    let path: String

    init(stringLiteral value: String) {
        path = value
    }

    init(stringInterpolation: Interpolation) {
        path = stringInterpolation.path
    }

    struct Interpolation: StringInterpolationProtocol {
        fileprivate var path = ""

        init(literalCapacity: Int, interpolationCount: Int) {
            path.reserveCapacity(literalCapacity)
        }

        mutating func appendLiteral(_ literal: String) {
            path += literal
        }

        mutating func appendInterpolation(_ segment: String) {
            path += segment.addingPercentEncoding(withAllowedCharacters: .pathSegmentAllowed) ?? segment
        }
    }
}

extension CharacterSet {
    /// Characters allowed unescaped inside one path segment.
    static let pathSegmentAllowed: CharacterSet = {
        var allowed = CharacterSet.urlPathAllowed
        allowed.remove(charactersIn: "/;")
        return allowed
    }()
}
