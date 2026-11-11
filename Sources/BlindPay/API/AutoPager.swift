//
//  AutoPager.swift
//  blindpay-swift
//

import Foundation

/// List inputs whose endpoint accepts cursor pagination.
public protocol CursorPaginatedInput: Sendable {
    /// Page size, sent as a string. Valid values are in the endpoint's spec.
    var limit: Int? { get set }
    /// Return items after this id (the previous page's `nextPage`).
    var startingAfter: String? { get set }
    /// Return items before this id. Auto-pagination rejects it.
    var endingBefore: String? { get set }
}

/// Builds the `AsyncThrowingStream` behind every `listAutoPaging` method.
///
/// Pull-based: a page is fetched only when the consumer has read every item
/// of the previous one, so breaking out of the loop stops the requests. Each
/// page goes through the normal request path (options, retries, timeouts).
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum AutoPager {
    /// Page size used when the caller sets none; valid in every limit enum.
    static let defaultLimit = 100

    static func stream<Input: CursorPaginatedInput, Element: Sendable>(
        params: Input,
        fetch: @escaping @Sendable (Input) async throws -> APIResponse<ListResult<Element>>
    ) -> AsyncThrowingStream<Element, Error> {
        guard params.endingBefore == nil else {
            return AsyncThrowingStream { continuation in
                continuation.finish(throwing: BlindPayError.invalidRequest(
                    "auto-pagination only goes forward; endingBefore is not supported"))
            }
        }
        var first = params
        if first.limit == nil { first.limit = defaultLimit }
        let state = State(params: first, fetch: fetch)
        return AsyncThrowingStream { try await state.next() }
    }

    private actor State<Input: CursorPaginatedInput, Element: Sendable> {
        private var params: Input
        private let fetch: @Sendable (Input) async throws -> APIResponse<ListResult<Element>>
        private var buffer: [Element] = []
        private var index = 0
        private var finished = false

        init(params: Input, fetch: @escaping @Sendable (Input) async throws -> APIResponse<ListResult<Element>>) {
            self.params = params
            self.fetch = fetch
        }

        func next() async throws -> Element? {
            while true {
                if index < buffer.count {
                    defer { index += 1 }
                    return buffer[index]
                }
                if finished { return nil }
                let response = try await fetch(params)
                if let error = response.error {
                    finished = true
                    throw error
                }
                let page = response.data ?? ListResult(data: [])
                buffer = page.data
                index = 0
                if let pagination = page.pagination, pagination.hasMore, let next = pagination.nextPage {
                    params.startingAfter = next
                } else {
                    finished = true
                }
            }
        }
    }
}
