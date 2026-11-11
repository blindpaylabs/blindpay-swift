//
//  QueryParameters.swift
//  blindpay-swift
//

import Foundation

/// Ordered query parameters. Unset (`nil`) and empty values are never sent,
/// and insertion order is kept so the wire query string is deterministic.
struct QueryParameters: Sendable, Equatable, ExpressibleByDictionaryLiteral {
    private(set) var items: [(name: String, value: String)] = []

    init() {}

    init(dictionaryLiteral elements: (String, String?)...) {
        for (name, value) in elements { self[name] = value }
    }

    /// Setting `nil` or `""` removes the parameter.
    subscript(name: String) -> String? {
        get { items.first { $0.name == name }?.value }
        set {
            if let index = items.firstIndex(where: { $0.name == name }) {
                if let value = newValue, !value.isEmpty { items[index].value = value } else { items.remove(at: index) }
            } else if let value = newValue, !value.isEmpty {
                items.append((name, value))
            }
        }
    }

    var isEmpty: Bool { items.isEmpty }

    var queryItems: [URLQueryItem] { items.map { URLQueryItem(name: $0.name, value: $0.value) } }

    static func == (lhs: QueryParameters, rhs: QueryParameters) -> Bool {
        lhs.items.map { [$0.name, $0.value] } == rhs.items.map { [$0.name, $0.value] }
    }
}
