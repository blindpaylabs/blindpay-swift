//
//  Amount.swift
//  blindpay-swift
//

import Foundation

/// Unit conversion for amounts the API takes in integer cents.
enum Amount {
    /// Converts a major-unit amount (e.g. dollars) to integer cents, rounding
    /// half away from zero. Plain `Int(x * 100)` truncates binary floating
    /// point error, so `19.99` became `1998`; this returns `1999`.
    ///
    /// The value is read through its shortest decimal representation (what
    /// the caller wrote, e.g. `1.005`), so decimal halves round up instead of
    /// down.
    ///
    /// - Throws: `EncodingError.invalidValue` for NaN, infinity, or a value
    ///   whose cent amount does not fit in `Int` (instead of trapping).
    static func cents(fromMajorUnits value: Double, codingPath: [CodingKey] = []) throws -> Int {
        let scaled = (value * 100).rounded()
        guard value.isFinite, scaled.magnitude < Double(Int.max) else {
            throw EncodingError.invalidValue(value, EncodingError.Context(
                codingPath: codingPath,
                debugDescription: "Amount \(value) cannot be converted to integer cents"
            ))
        }
        if var decimal = Decimal(string: "\(value)", locale: Locale(identifier: "en_US_POSIX")) {
            decimal *= 100
            var rounded = Decimal()
            NSDecimalRound(&rounded, &decimal, 0, .plain)
            return NSDecimalNumber(decimal: rounded).intValue
        }
        return Int(scaled)
    }
}

extension KeyedEncodingContainer {
    /// Encodes a major-unit amount as rounded integer cents.
    mutating func encodeCents(_ majorUnits: Double, forKey key: Key) throws {
        try encode(Amount.cents(fromMajorUnits: majorUnits, codingPath: codingPath + [key]), forKey: key)
    }
}
