//
//  Quote.swift
//  blindpay-swift
//
//  Created by Eric Viana on 03/11/25.
//

import Foundation

// MARK: - Enums

/// Type of currency (sender or receiver)
public enum CurrencyType: String, Codable, Sendable {
    case sender = "sender"
    case receiver = "receiver"
}

/// Blockchain network
public enum Network: String, Codable, Sendable {
    case base = "base"
    case sepolia = "sepolia"
    case arbitrumSepolia = "arbitrum_sepolia"
    case baseSepolia = "base_sepolia"
    case arbitrum = "arbitrum"
    case polygon = "polygon"
    case polygonAmoy = "polygon_amoy"
    case ethereum = "ethereum"
    case stellar = "stellar"
    case stellarTestnet = "stellar_testnet"
    case tron = "tron"
}

/// Stablecoin token
public enum StablecoinToken: String, Codable, Sendable {
    case usdc = "USDC"
    case usdt = "USDT"
    case usdb = "USDB"
}

/// Transaction document type
public enum TransactionDocumentType: String, Codable, Sendable {
    case invoice = "invoice"
    case purchaseOrder = "purchase_order"
    case deliverySlip = "delivery_slip"
    case contract = "contract"
    case customsDeclaration = "customs_declaration"
    case billOfLading = "bill_of_lading"
    case others = "others"
}

/// Currency type
public enum Currency: String, Codable, Sendable {
    case usdc = "USDC"
    case usdt = "USDT"
    case usdb = "USDB"
    case brl = "BRL"
    case usd = "USD"
    case mxn = "MXN"
    case cop = "COP"
    case ars = "ARS"
}

// MARK: - Create Quote

/// Input for creating a quote
public struct CreateQuoteInput: Codable, Sendable {
    /// Bank account ID
    public let bankAccountId: String
    
    /// Currency type (sender or receiver)
    public let currencyType: CurrencyType
    
    /// Network (optional)
    public let network: Network?
    
    /// Request amount
    public let requestAmount: Double
    
    /// Token (optional)
    public let token: StablecoinToken?
    
    /// Whether to cover fees
    public let coverFees: Bool?
    
    /// Description (optional)
    public let description: String?
    
    /// Partner fee ID (optional)
    public let partnerFeeId: String?
    
    /// Transaction document file (optional)
    public let transactionDocumentFile: String?
    
    /// Transaction document ID (optional)
    public let transactionDocumentId: String?
    
    /// Transaction document type
    public let transactionDocumentType: TransactionDocumentType
    
    public init(
        bankAccountId: String,
        currencyType: CurrencyType,
        network: Network? = nil,
        requestAmount: Double,
        token: StablecoinToken? = nil,
        coverFees: Bool? = nil,
        description: String? = nil,
        partnerFeeId: String? = nil,
        transactionDocumentFile: String? = nil,
        transactionDocumentId: String? = nil,
        transactionDocumentType: TransactionDocumentType
    ) {
        self.bankAccountId = bankAccountId
        self.currencyType = currencyType
        self.network = network
        self.requestAmount = requestAmount
        self.token = token
        self.coverFees = coverFees
        self.description = description
        self.partnerFeeId = partnerFeeId
        self.transactionDocumentFile = transactionDocumentFile
        self.transactionDocumentId = transactionDocumentId
        self.transactionDocumentType = transactionDocumentType
    }
    
    enum CodingKeys: String, CodingKey {
        case bankAccountId = "bank_account_id"
        case currencyType = "currency_type"
        case network
        case requestAmount = "request_amount"
        case token
        case coverFees = "cover_fees"
        case description
        case partnerFeeId = "partner_fee_id"
        case transactionDocumentFile = "transaction_document_file"
        case transactionDocumentId = "transaction_document_id"
        case transactionDocumentType = "transaction_document_type"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bankAccountId, forKey: .bankAccountId)
        try container.encode(currencyType, forKey: .currencyType)
        try container.encodeIfPresent(network, forKey: .network)
        // Convert to integer smallest unit (100 = 1.00)
        try container.encode(Int(requestAmount * 100), forKey: .requestAmount)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(coverFees, forKey: .coverFees)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(partnerFeeId, forKey: .partnerFeeId)
        try container.encodeIfPresent(transactionDocumentFile, forKey: .transactionDocumentFile)
        try container.encodeIfPresent(transactionDocumentId, forKey: .transactionDocumentId)
        try container.encode(transactionDocumentType, forKey: .transactionDocumentType)
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
    public let expiresAt: Int
    
    /// Commercial quotation
    public let commercialQuotation: Double
    
    /// BlindPay quotation
    public let blindpayQuotation: Double
    
    /// Receiver amount
    public let receiverAmount: Double
    
    /// Sender amount
    public let senderAmount: Double
    
    /// Partner fee amount
    public let partnerFeeAmount: Double
    
    /// Flat fee
    public let flatFee: Double
    
    /// Contract information
    public let contract: QuoteContract
    
    /// Receiver local amount
    public let receiverLocalAmount: Double
    
    /// Description
    public let description: String
    
    public init(
        id: String,
        expiresAt: Int,
        commercialQuotation: Double,
        blindpayQuotation: Double,
        receiverAmount: Double,
        senderAmount: Double,
        partnerFeeAmount: Double,
        flatFee: Double,
        contract: QuoteContract,
        receiverLocalAmount: Double,
        description: String
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
        self.receiverLocalAmount = receiverLocalAmount
        self.description = description
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
        case receiverLocalAmount = "receiver_local_amount"
        case description
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
    
    /// Request amount
    public let requestAmount: Double
    
    public init(
        currencyType: CurrencyType,
        from: Currency,
        to: Currency,
        requestAmount: Double
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currencyType, forKey: .currencyType)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        // Convert to integer smallest unit (100 = 1.00)
        try container.encode(Int(requestAmount * 100), forKey: .requestAmount)
    }
}

/// Response for getting FX rate
public struct GetFxRateResponse: Codable, Sendable, Equatable {
    /// Commercial quotation
    public let commercialQuotation: Double
    
    /// BlindPay quotation
    public let blindpayQuotation: Double
    
    /// Result amount
    public let resultAmount: Double
    
    /// Instance flat fee
    public let instanceFlatFee: Double
    
    /// Instance percentage fee
    public let instancePercentageFee: Double
    
    public init(
        commercialQuotation: Double,
        blindpayQuotation: Double,
        resultAmount: Double,
        instanceFlatFee: Double,
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
        switch (lhs.value, rhs.value) {
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
        case let (lhs as [AnyCodable], rhs as [AnyCodable]):
            return lhs == rhs
        case let (lhs as [String: AnyCodable], rhs as [String: AnyCodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

