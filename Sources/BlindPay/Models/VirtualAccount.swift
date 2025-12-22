//
//  VirtualAccount.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Banking Partner

/// Banking partner for virtual accounts
public enum BankingPartner: String, Codable, Sendable {
    case jpmorgan = "jpmorgan"
    case citi = "citi"
}

// MARK: - Blockchain Wallet Reference

/// Blockchain wallet reference embedded in virtual account responses
public struct BlockchainWalletRef: Codable, Sendable, Equatable {
    /// Blockchain network
    public let network: Network
    
    /// Wallet address
    public let address: String
    
    public init(network: Network, address: String) {
        self.network = network
        self.address = address
    }
}

// MARK: - Virtual Account Account Type

/// Represents the account type for a virtual account
public enum VirtualAccountAccountType: String, Codable, Sendable {
    case personalChecking = "Personal checking"
    case businessChecking = "Business checking"
}

// MARK: - Virtual Account ACH

/// ACH account details for a virtual account
public struct VirtualAccountACH: Codable, Sendable, Equatable {
    /// Routing number
    public let routingNumber: String
    
    /// Account number
    public let accountNumber: String
    
    public init(routingNumber: String, accountNumber: String) {
        self.routingNumber = routingNumber
        self.accountNumber = accountNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case routingNumber = "routing_number"
        case accountNumber = "account_number"
    }
}

// MARK: - Virtual Account RTP

/// RTP account details for a virtual account
public struct VirtualAccountRTP: Codable, Sendable, Equatable {
    /// Routing number
    public let routingNumber: String
    
    /// Account number
    public let accountNumber: String
    
    public init(routingNumber: String, accountNumber: String) {
        self.routingNumber = routingNumber
        self.accountNumber = accountNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case routingNumber = "routing_number"
        case accountNumber = "account_number"
    }
}

// MARK: - Virtual Account Wire

/// Wire account details for a virtual account
public struct VirtualAccountWire: Codable, Sendable, Equatable {
    /// Routing number
    public let routingNumber: String
    
    /// Account number
    public let accountNumber: String
    
    public init(routingNumber: String, accountNumber: String) {
        self.routingNumber = routingNumber
        self.accountNumber = accountNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case routingNumber = "routing_number"
        case accountNumber = "account_number"
    }
}

// MARK: - Virtual Account Beneficiary

/// Beneficiary information for a virtual account
public struct VirtualAccountBeneficiary: Codable, Sendable, Equatable {
    /// Beneficiary name
    public let name: String
    
    /// Address line 1
    public let addressLine1: String
    
    /// Address line 2
    public let addressLine2: String
    
    public init(name: String, addressLine1: String, addressLine2: String) {
        self.name = name
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
    }
}

// MARK: - Virtual Account Receiving Bank

/// Receiving bank information for a virtual account
public struct VirtualAccountReceivingBank: Codable, Sendable, Equatable {
    /// Bank name
    public let name: String
    
    /// Address line 1
    public let addressLine1: String
    
    /// Address line 2
    public let addressLine2: String
    
    /// SWIFT BIC code (optional)
    public let swiftBicCode: String?
    
    public init(name: String, addressLine1: String, addressLine2: String, swiftBicCode: String? = nil) {
        self.name = name
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.swiftBicCode = swiftBicCode
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case swiftBicCode = "swift_bic_code"
    }
}

// MARK: - Virtual Account US

/// US account details for a virtual account
public struct VirtualAccountUS: Codable, Sendable, Equatable {
    /// ACH account details
    public let ach: VirtualAccountACH
    
    /// RTP account details
    public let rtp: VirtualAccountRTP
    
    /// Wire account details
    public let wire: VirtualAccountWire
    
    /// SWIFT BIC code (optional)
    public let swiftBicCode: String?
    
    /// Account type (optional)
    public let accountType: VirtualAccountAccountType?
    
    /// Beneficiary information (optional)
    public let beneficiary: VirtualAccountBeneficiary?
    
    /// Receiving bank information (optional)
    public let receivingBank: VirtualAccountReceivingBank?
    
    public init(
        ach: VirtualAccountACH,
        rtp: VirtualAccountRTP,
        wire: VirtualAccountWire,
        swiftBicCode: String? = nil,
        accountType: VirtualAccountAccountType? = nil,
        beneficiary: VirtualAccountBeneficiary? = nil,
        receivingBank: VirtualAccountReceivingBank? = nil
    ) {
        self.ach = ach
        self.rtp = rtp
        self.wire = wire
        self.swiftBicCode = swiftBicCode
        self.accountType = accountType
        self.beneficiary = beneficiary
        self.receivingBank = receivingBank
    }
    
    enum CodingKeys: String, CodingKey {
        case ach
        case rtp
        case wire
        case swiftBicCode = "swift_bic_code"
        case accountType = "account_type"
        case beneficiary
        case receivingBank = "receiving_bank"
    }
}

// MARK: - Virtual Account

/// Represents a virtual account
public struct VirtualAccount: Codable, Sendable, Equatable {
    /// Unique identifier for the virtual account
    public let id: String
    
    /// Banking partner
    public let bankingPartner: BankingPartner
    
    /// KYC status (optional)
    public let kycStatus: KYCStatus?
    
    /// US account details
    public let us: VirtualAccountUS
    
    /// Token (USDC, USDT, or USDB)
    public let token: StablecoinToken
    
    /// Blockchain wallet ID (optional)
    public let blockchainWalletId: String?
    
    /// Blockchain wallet reference (optional)
    public let blockchainWallet: BlockchainWalletRef?
    
    public init(
        id: String,
        bankingPartner: BankingPartner,
        kycStatus: KYCStatus? = nil,
        us: VirtualAccountUS,
        token: StablecoinToken,
        blockchainWalletId: String? = nil,
        blockchainWallet: BlockchainWalletRef? = nil
    ) {
        self.id = id
        self.bankingPartner = bankingPartner
        self.kycStatus = kycStatus
        self.us = us
        self.token = token
        self.blockchainWalletId = blockchainWalletId
        self.blockchainWallet = blockchainWallet
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case bankingPartner = "banking_partner"
        case kycStatus = "kyc_status"
        case us
        case token
        case blockchainWalletId = "blockchain_wallet_id"
        case blockchainWallet = "blockchain_wallet"
    }
}

// MARK: - Response Types

/// Response type for getting a virtual account
public typealias VirtualAccountResponse = VirtualAccount

/// Response type for listing virtual accounts
public typealias VirtualAccountsResponse = [VirtualAccount]

/// Response type for creating a virtual account
public typealias CreateVirtualAccountResponse = VirtualAccount

/// Response type for updating a virtual account
public struct UpdateVirtualAccountResponse: Codable, Sendable, Equatable {
    /// Indicates if the update was successful
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}

// MARK: - Input Types

/// Input for creating a virtual account
public struct CreateVirtualAccountInput: Codable, Sendable {
    /// Banking partner
    public let bankingPartner: BankingPartner
    
    /// Token (USDC, USDT, or USDB)
    public let token: StablecoinToken
    
    /// Blockchain wallet ID
    public let blockchainWalletId: String
    
    public init(bankingPartner: BankingPartner, token: StablecoinToken, blockchainWalletId: String) {
        self.bankingPartner = bankingPartner
        self.token = token
        self.blockchainWalletId = blockchainWalletId
    }
    
    enum CodingKeys: String, CodingKey {
        case bankingPartner = "banking_partner"
        case token
        case blockchainWalletId = "blockchain_wallet_id"
    }
}

/// Input for updating a virtual account
public struct UpdateVirtualAccountInput: Codable, Sendable {
    /// Blockchain wallet ID
    public let blockchainWalletId: String
    
    /// Token (USDC, USDT, or USDB)
    public let token: StablecoinToken
    
    public init(blockchainWalletId: String, token: StablecoinToken) {
        self.blockchainWalletId = blockchainWalletId
        self.token = token
    }
    
    enum CodingKeys: String, CodingKey {
        case blockchainWalletId = "blockchain_wallet_id"
        case token
    }
}

