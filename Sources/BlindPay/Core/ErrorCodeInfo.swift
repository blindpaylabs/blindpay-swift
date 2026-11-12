//
//  ErrorCodeInfo.swift
//  blindpay-swift
//
//  Metadata for ``ErrorCode`` (generated in ErrorCode.swift from the spec's
//  error table) and the typed accessors on ``APIError``.
//

/// How to react to an error code, from the API's error table.
///
/// - `retryable`: the same request can succeed if sent again later.
/// - `terminal`: don't resend it.
/// - `actionable`: it succeeds only after you fix something (fund a balance,
///   correct bank details, request a new quote, ...).
/// - `unknown`: there was no code, or this SDK version doesn't know it.
///
/// Advisory only: the client's automatic retries follow
/// ``APIError/retryable`` and never read this.
public struct RetryClass: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let retryable = RetryClass(rawValue: "retryable")
    public static let terminal = RetryClass(rawValue: "terminal")
    public static let actionable = RetryClass(rawValue: "actionable")
    public static let unknown = RetryClass(rawValue: "unknown")
}

/// The documented HTTP status and retry class of an ``ErrorCode``. The
/// status is the one the code typically comes with; an endpoint may answer
/// a given code with a different one, so branch on the code.
public struct ErrorCodeInfo: Codable, Sendable, Equatable, Hashable {
    public let status: Int
    public let retry: RetryClass

    public init(status: Int, retry: RetryClass) {
        self.status = status
        self.retry = retry
    }
}

extension APIError {
    /// ``code`` as an ``ErrorCode``, or `nil` when the body had no code
    /// (idempotency errors, non-JSON bodies). Match on it, and fall back to
    /// ``message`` for the rejections that only it distinguishes:
    ///
    /// ```swift
    /// if error.errorCode == .transfersSwapAmountBelowMinimum { ... }
    /// ```
    public var errorCode: ErrorCode? { code.map(ErrorCode.init(rawValue:)) }

    /// The retry class of ``code`` from the API's error table: `.unknown`
    /// when there is no code or this SDK version doesn't know it.
    public var retryClass: RetryClass { errorCode?.info?.retry ?? .unknown }
}
