//
//  WebhookReceiver (example E1)
//
//  A BlindPay webhook handler: raw body -> verify the Svix signature ->
//  dispatch on the event type -> drop redeliveries by `svix-id`.
//
//  Plug `WebhookHandler.handle(rawBody:headers:)` into your HTTP server and
//  return its status code. Pass the body bytes exactly as received: verifying
//  a re-serialized body fails. This program feeds it one delivery from stdin:
//
//    BLINDPAY_WEBHOOK_SECRET=whsec_... SVIX_ID=msg_... SVIX_TIMESTAMP=... \
//    SVIX_SIGNATURE='v1,...' swift run WebhookReceiver < body.json
//

import BlindPay
import Foundation

/// Remembers delivered message ids. Svix retries a delivery until it gets a
/// 2xx, so the same `svix-id` can arrive more than once. Use a shared store
/// (a database table with a unique key, Redis SETNX, ...) in production.
actor DeliveryLog {
    private var seen: Set<String> = []

    /// True the first time an id is recorded.
    func record(_ id: String) -> Bool { seen.insert(id).inserted }
}

struct WebhookHandler {
    let secret: String
    let deliveries = DeliveryLog()

    /// Returns the HTTP status to answer with.
    func handle(rawBody: Data, headers: [String: String]) async -> Int {
        let event: WebhookEvent
        do {
            event = try Webhooks.constructEvent(payload: rawBody, headers: headers, secret: secret)
        } catch {
            // Bad signature, stale timestamp or missing headers: reject.
            return 400
        }
        // Verified, so the id header is present (svix-id or webhook-id).
        let id = headers.first { ["svix-id", "webhook-id"].contains($0.key.lowercased()) }?.value ?? ""
        guard await deliveries.record(id) else { return 200 }  // already handled

        switch event {
        case .payinComplete(let payin):
            print("payin \(payin.id) completed")
        case .payoutComplete(let payout):
            print("payout \(payout.id) is \(payout.status.rawValue)")
        case .walletInbound(let inbound):
            print("wallet deposit: \(inbound)")
        case .limitIncreaseUpdate(let request):
            print("limit increase \(request.id) is \(request.status.rawValue)", request.reviewReason.map { "(\($0))" } ?? "")
        case .customerUpdate(let customer):
            print("customer \(customer.id) KYC is \(customer.kycStatus?.rawValue ?? "unknown")")
        case .unknown(let type, _):
            // A newer event than this SDK knows: acknowledge it so it isn't retried.
            print("unhandled event \(type.rawValue)")
        default:
            print("event \(event.type.rawValue)")
        }
        return 200
    }
}

let environment = ProcessInfo.processInfo.environment
guard let secret = environment["BLINDPAY_WEBHOOK_SECRET"] else {
    print("Set BLINDPAY_WEBHOOK_SECRET (whsec_...), SVIX_ID, SVIX_TIMESTAMP and SVIX_SIGNATURE, and pipe the raw body to stdin.")
    exit(64)
}
let headers = [
    "svix-id": environment["SVIX_ID"] ?? "",
    "svix-timestamp": environment["SVIX_TIMESTAMP"] ?? "",
    "svix-signature": environment["SVIX_SIGNATURE"] ?? "",
]
let body = FileHandle.standardInput.readDataToEndOfFile()
let handler = WebhookHandler(secret: secret)
let first = await handler.handle(rawBody: body, headers: headers)
let redelivery = await handler.handle(rawBody: body, headers: headers)
print("status \(first); redelivery status \(redelivery)")
