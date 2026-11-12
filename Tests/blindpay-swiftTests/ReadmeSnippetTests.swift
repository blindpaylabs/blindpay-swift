//
//  ReadmeSnippetTests.swift
//  blindpay-swift
//
//  The README's webhook handler, compiled verbatim (between the markers
//  below, public API only) and checked line for line against README.md.
//

import BlindPay
import Foundation
import Testing

/// The README "Webhooks" snippet. Its free variables are the parameters.
private func readmeWebhookHandler(body: Data, headers: [String: String], webhookSecret: String) {
    // README-WEBHOOK-BEGIN
    // Vapor:  let body = Data(buffer: req.body.data!)
    // Any framework: the raw bytes and the request headers.
    do {
        let event = try Webhooks.constructEvent(payload: body, headers: headers, secret: webhookSecret)
        switch event {
        case .payoutComplete(let payout), .payoutUpdate(let payout):
            // A failed payout can arrive on either event: branch on the status.
            if payout.status == .failed { /* handle the failure */ }
        case .payinComplete(let payin):
            print(payin.id)
        case .unknown(let type, let raw):
            print("unhandled event \(type), \(raw.count) bytes")
        default:
            break
        }
        // Answer 2xx once the event is handled.
    } catch BlindPayError.webhookVerificationFailed {
        // Bad signature, a timestamp outside the tolerance, or missing svix-* headers:
        // not a genuine delivery. Answer 400.
    } catch BlindPayError.decodingError {
        // The signature verified, but this SDK version couldn't decode the payload.
        // Answer 2xx anyway: any other status makes BlindPay redeliver it for hours.
        // Log the svix-id and the raw body, and replay the event from the dashboard
        // once your handler or the SDK is updated.
    } catch {
        // constructEvent throws only the two errors above, so this is your own
        // handling code failing. Answer 500: BlindPay redelivers the event later.
    }
    // README-WEBHOOK-END
}

struct ReadmeSnippetTests {
    private static let root = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()

    private func lines(between begin: String, and end: String, in text: String) throws -> [String] {
        let all = text.components(separatedBy: "\n")
        let start = try #require(all.firstIndex { $0.contains(begin) })
        let stop = try #require(all[(start + 1)...].firstIndex { $0.contains(end) })
        return all[(start + 1)..<stop].map { $0.trimmingCharacters(in: .whitespaces) }
    }

    @Test func theCompiledWebhookHandlerIsTheReadmeSnippet() throws {
        let source = try String(contentsOf: URL(fileURLWithPath: #filePath), encoding: .utf8)
        let compiled = try lines(between: "README-WEBHOOK-" + "BEGIN", and: "README-WEBHOOK-" + "END", in: source)
        let readme = try String(contentsOf: Self.root.appendingPathComponent("README.md"), encoding: .utf8)
        let section = try #require(readme.components(separatedBy: "## Webhooks").dropFirst().first)
        let snippet = try lines(between: "```swift", and: "```", in: section)
        #expect(snippet == compiled)
    }

    @Test func theHandlerRunsOnARejectedDelivery() {
        // No svix-* headers: the verification branch. The branches only comment and print.
        readmeWebhookHandler(body: Data("{}".utf8), headers: [:], webhookSecret: "whsec_MfKQ9r8GKYqrTwjUPD8ILPZIo2LaLaSw")
    }
}
