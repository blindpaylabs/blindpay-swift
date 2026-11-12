//
//  Quote.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

// MARK: - Enums

/// Type of currency (sender or receiver)
public struct CurrencyType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let sender = CurrencyType(rawValue: "sender")
    public static let receiver = CurrencyType(rawValue: "receiver")
}

/// Blockchain network
public struct Network: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let base = Network(rawValue: "base")
    public static let sepolia = Network(rawValue: "sepolia")
    public static let arbitrumSepolia = Network(rawValue: "arbitrum_sepolia")
    public static let baseSepolia = Network(rawValue: "base_sepolia")
    public static let arbitrum = Network(rawValue: "arbitrum")
    public static let polygon = Network(rawValue: "polygon")
    public static let polygonAmoy = Network(rawValue: "polygon_amoy")
    public static let ethereum = Network(rawValue: "ethereum")
    public static let stellar = Network(rawValue: "stellar")
    public static let stellarTestnet = Network(rawValue: "stellar_testnet")
    public static let tron = Network(rawValue: "tron")
    public static let solana = Network(rawValue: "solana")
    public static let solanaDevnet = Network(rawValue: "solana_devnet")
    public static let arc = Network(rawValue: "arc")
    public static let arcTestnet = Network(rawValue: "arc_testnet")
    public static let tempo = Network(rawValue: "tempo")
    public static let tempoTestnet = Network(rawValue: "tempo_testnet")
}

/// Stablecoin token
public struct StablecoinToken: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let usdc = StablecoinToken(rawValue: "USDC")
    public static let usdt = StablecoinToken(rawValue: "USDT")
    public static let usdb = StablecoinToken(rawValue: "USDB")
}

/// Transaction document type
public struct TransactionDocumentType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let invoice = TransactionDocumentType(rawValue: "invoice")
    public static let purchaseOrder = TransactionDocumentType(rawValue: "purchase_order")
    public static let deliverySlip = TransactionDocumentType(rawValue: "delivery_slip")
    public static let contract = TransactionDocumentType(rawValue: "contract")
    public static let customsDeclaration = TransactionDocumentType(rawValue: "customs_declaration")
    public static let billOfLading = TransactionDocumentType(rawValue: "bill_of_lading")
    public static let others = TransactionDocumentType(rawValue: "others")
}

/// Currency type
public struct Currency: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let usdc = Currency(rawValue: "USDC")
    public static let usdt = Currency(rawValue: "USDT")
    public static let usdb = Currency(rawValue: "USDB")
    public static let brl = Currency(rawValue: "BRL")
    public static let usd = Currency(rawValue: "USD")
    public static let mxn = Currency(rawValue: "MXN")
    public static let cop = Currency(rawValue: "COP")
    public static let ars = Currency(rawValue: "ARS")
    public static let gbp = Currency(rawValue: "GBP")
    public static let eur = Currency(rawValue: "EUR")
}

// MARK: - Create Quote

/// Input for creating a payout quote (`QuoteIn`).
///
/// Set exactly one of `bankAccountId` (pay a bank account) or `payableId`
/// (pay a payable); the API rejects both or neither with a 400. Bank account
/// quotes also need `currencyType` and `requestAmount`; payable quotes take
/// the amount from the payable and always cover fees.
public struct CreateQuoteInput: Codable, Sendable {
    /// The bank account to pay. Exactly one of this or `payableId`.
    public let bankAccountId: String?

    /// The payable to pay. Exactly one of this or `bankAccountId`.
    public let payableId: String?

    /// Whether `requestAmount` is what the sender sends or the receiver gets.
    public let currencyType: CurrencyType?

    /// The network the stablecoins are sent from.
    public let network: Network

    /// Amount in integer cents (`1999` = 19.99). See ``Amount/cents(fromMajorUnits:)``.
    public let requestAmount: Int?

    /// The token the stablecoins are sent in.
    public let token: StablecoinToken

    /// Whether the sender covers the fees. Defaults to false on bank account quotes.
    public let coverFees: Bool?

    public let description: String?

    public let partnerFeeId: String?

    /// Where refunds go if the payout fails after funding.
    public let refundWalletAddress: String?

    public init(
        bankAccountId: String? = nil,
        payableId: String? = nil,
        currencyType: CurrencyType? = nil,
        network: Network,
        requestAmount: Int? = nil,
        token: StablecoinToken,
        coverFees: Bool? = nil,
        description: String? = nil,
        partnerFeeId: String? = nil,
        refundWalletAddress: String? = nil
    ) {
        self.bankAccountId = bankAccountId
        self.payableId = payableId
        self.currencyType = currencyType
        self.network = network
        self.requestAmount = requestAmount
        self.token = token
        self.coverFees = coverFees
        self.description = description
        self.partnerFeeId = partnerFeeId
        self.refundWalletAddress = refundWalletAddress
    }

    enum CodingKeys: String, CodingKey {
        case bankAccountId = "bank_account_id"
        case payableId = "payable_id"
        case currencyType = "currency_type"
        case network
        case requestAmount = "request_amount"
        case token
        case coverFees = "cover_fees"
        case description
        case partnerFeeId = "partner_fee_id"
        case refundWalletAddress = "refund_wallet_address"
    }
}

/// Network information for a contract
public struct QuoteNetwork: Codable, Sendable, Equatable {
    /// Network name
    public let name: String
    
    /// Chain ID
    public let chainId: Int
    
    public init(name: String, chainId: Int) {
        self.name = name
        self.chainId = chainId
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case chainId = "chainId"
    }
}

/// Contract information for a quote
public struct QuoteContract: Codable, Equatable, @unchecked Sendable {
    /// Contract ABI
    public let abi: [[String: AnyCodable]]
    
    /// Contract address
    public let address: String
    
    /// Function name
    public let functionName: String
    
    /// BlindPay contract address
    public let blindpayContractAddress: String
    
    /// Amount
    public let amount: String
    
    /// Network information
    public let network: QuoteNetwork
    
    public init(
        abi: [[String: AnyCodable]],
        address: String,
        functionName: String,
        blindpayContractAddress: String,
        amount: String,
        network: QuoteNetwork
    ) {
        self.abi = abi
        self.address = address
        self.functionName = functionName
        self.blindpayContractAddress = blindpayContractAddress
        self.amount = amount
        self.network = network
    }
    
    enum CodingKeys: String, CodingKey {
        case abi
        case address
        case functionName
        case blindpayContractAddress
        case amount
        case network
    }
}

/// Response for creating a quote
public struct CreateQuoteResponse: Codable, Equatable, @unchecked Sendable {
    /// Quote ID
    public let id: String
    
    /// Expiration timestamp
    public let expiresAt: Int?
    
    /// Commercial quotation
    public let commercialQuotation: Double?
    
    /// BlindPay quotation
    public let blindpayQuotation: Double?
    
    /// Receiver amount
    public let receiverAmount: Int?
    
    /// Sender amount
    public let senderAmount: Int?
    
    /// Partner fee amount
    public let partnerFeeAmount: Int?
    
    /// Flat fee
    public let flatFee: Double?
    
    /// Contract information
    public let contract: QuoteContract?

    /// Customer local amount
    public let customerLocalAmount: Int?

    /// Description
    public let description: String?

    /// Billing fee in cents (charged via invoice at the end of the month)
    public let billingFeeAmount: Int?

    public init(
        id: String,
        expiresAt: Int? = nil,
        commercialQuotation: Double? = nil,
        blindpayQuotation: Double? = nil,
        receiverAmount: Int? = nil,
        senderAmount: Int? = nil,
        partnerFeeAmount: Int? = nil,
        flatFee: Double? = nil,
        contract: QuoteContract? = nil,
        customerLocalAmount: Int? = nil,
        description: String? = nil,
        billingFeeAmount: Int? = nil
    ) {
        self.id = id
        self.expiresAt = expiresAt
        self.commercialQuotation = commercialQuotation
        self.blindpayQuotation = blindpayQuotation
        self.receiverAmount = receiverAmount
        self.senderAmount = senderAmount
        self.partnerFeeAmount = partnerFeeAmount
        self.flatFee = flatFee
        self.contract = contract
        self.customerLocalAmount = customerLocalAmount
        self.description = description
        self.billingFeeAmount = billingFeeAmount
    }

    enum CodingKeys: String, CodingKey {
        case id
        case expiresAt = "expires_at"
        case commercialQuotation = "commercial_quotation"
        case blindpayQuotation = "blindpay_quotation"
        case receiverAmount = "receiver_amount"
        case senderAmount = "sender_amount"
        case partnerFeeAmount = "partner_fee_amount"
        case flatFee = "flat_fee"
        case contract
        case customerLocalAmount = "customer_local_amount"
        case description
        case billingFeeAmount = "billing_fee_amount"
    }
}

// MARK: - Get FX Rate

/// Input for getting FX rate
public struct GetFxRateInput: Codable, Sendable {
    /// Currency type (sender or receiver)
    public let currencyType: CurrencyType
    
    /// From currency
    public let from: Currency
    
    /// To currency
    public let to: Currency
    
    /// Amount in integer cents (`1999` = 19.99); convert with
    /// ``Amount/cents(fromMajorUnits:)``. For a currency without minor units
    /// and `currencyType: .sender`, it must be a multiple of 100. The API
    /// enforces a per-currency minimum and returns 400 below it.
    public let requestAmount: Int
    
    public init(
        currencyType: CurrencyType,
        from: Currency,
        to: Currency,
        requestAmount: Int
    ) {
        self.currencyType = currencyType
        self.from = from
        self.to = to
        self.requestAmount = requestAmount
    }
    
    enum CodingKeys: String, CodingKey {
        case currencyType = "currency_type"
        case from
        case to
        case requestAmount = "request_amount"
    }
}

/// Response for getting FX rate
public struct GetFxRateResponse: Codable, Sendable, Equatable {
    /// Commercial quotation
    public let commercialQuotation: Double?
    
    /// BlindPay quotation
    public let blindpayQuotation: Double?
    
    /// Result amount
    public let resultAmount: Double
    
    /// Instance flat fee
    public let instanceFlatFee: Double?
    
    /// Instance percentage fee
    public let instancePercentageFee: Double
    
    public init(
        commercialQuotation: Double? = nil,
        blindpayQuotation: Double? = nil,
        resultAmount: Double,
        instanceFlatFee: Double? = nil,
        instancePercentageFee: Double
    ) {
        self.commercialQuotation = commercialQuotation
        self.blindpayQuotation = blindpayQuotation
        self.resultAmount = resultAmount
        self.instanceFlatFee = instanceFlatFee
        self.instancePercentageFee = instancePercentageFee
    }
    
    enum CodingKeys: String, CodingKey {
        case commercialQuotation = "commercial_quotation"
        case blindpayQuotation = "blindpay_quotation"
        case resultAmount = "result_amount"
        case instanceFlatFee = "instance_flat_fee"
        case instancePercentageFee = "instance_percentage_fee"
    }
}

// MARK: - AnyCodable Helper

/// A type-erased codable value
public struct AnyCodable: Codable, Equatable, @unchecked Sendable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "AnyCodable value cannot be decoded"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "AnyCodable value cannot be encoded"
            )
            throw EncodingError.invalidValue(value, context)
        }
    }
    
    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        return AnyCodable.isEqual(lhs.value, rhs.value)
    }

    /// Structural equality over decoded JSON values. Decoding stores nested
    /// arrays and objects as `[Any]` / `[String: Any]` (not `[AnyCodable]`),
    /// so those are compared element by element.
    private static func isEqual(_ lhs: Any, _ rhs: Any) -> Bool {
        switch (lhs, rhs) {
        case is (NSNull, NSNull):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as AnyCodable, rhs):
            return isEqual(lhs.value, rhs)
        case let (lhs, rhs as AnyCodable):
            return isEqual(lhs, rhs.value)
        case let (lhs as [Any], rhs as [Any]):
            return lhs.count == rhs.count && zip(lhs, rhs).allSatisfy { isEqual($0, $1) }
        case let (lhs as [String: Any], rhs as [String: Any]):
            return lhs.count == rhs.count && lhs.allSatisfy { key, value in
                rhs[key].map { isEqual(value, $0) } ?? false
            }
        default:
            return false
        }
    }
}
