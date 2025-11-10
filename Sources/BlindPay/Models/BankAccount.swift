//
//  BankAccount.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - Bank Account

/// Represents a bank account
public struct BankAccount: Codable, Sendable, Equatable {
    /// Unique identifier for the bank account
    public let id: String
    
    /// Bank account name
    public let name: String
    
    /// Bank account type (rail)
    public let type: Rail
    
    /// Account class (individual or business)
    public let accountClass: AccountClass?
    
    /// Account number
    public let accountNumber: String?
    
    /// Account type (checking or savings)
    public let accountType: BankAccountType?
    
    /// Address line 1
    public let addressLine1: String?
    
    /// Address line 2
    public let addressLine2: String?
    
    /// Beneficiary name
    public let beneficiaryName: String?
    
    /// City
    public let city: String?
    
    /// Country code
    public let country: Country?
    
    /// Postal code
    public let postalCode: String?
    
    /// Routing number
    public let routingNumber: String?
    
    /// State/province/region
    public let stateProvinceRegion: String?
    
    /// PIX key
    public let pixKey: String?
    
    /// PIX Safe bank code
    public let pixSafeBankCode: String?
    
    /// PIX Safe branch code
    public let pixSafeBranchCode: String?
    
    /// PIX Safe CPF/CNPJ
    public let pixSafeCpfCnpj: String?
    
    /// SPEI CLABE
    public let speiClabe: String?
    
    /// SPEI institution code
    public let speiInstitutionCode: String?
    
    /// SPEI protocol
    public let speiProtocol: SpeiProtocol?
    
    /// Transfers account
    public let transfersAccount: String?
    
    /// Transfers type
    public let transfersType: TransfersType?
    
    /// ACH COP bank account
    public let achCopBankAccount: String?
    
    /// ACH COP bank code
    public let achCopBankCode: String?
    
    /// ACH COP beneficiary first name
    public let achCopBeneficiaryFirstName: String?
    
    /// ACH COP beneficiary last name
    public let achCopBeneficiaryLastName: String?
    
    /// ACH COP document ID
    public let achCopDocumentId: String?
    
    /// ACH COP document type
    public let achCopDocumentType: AchCopDocumentType?
    
    /// ACH COP email
    public let achCopEmail: String?
    
    /// SWIFT code BIC
    public let swiftCodeBic: String?
    
    /// SWIFT account holder name
    public let swiftAccountHolderName: String?
    
    /// SWIFT account number IBAN
    public let swiftAccountNumberIban: String?
    
    /// SWIFT beneficiary address line 1
    public let swiftBeneficiaryAddressLine1: String?
    
    /// SWIFT beneficiary address line 2
    public let swiftBeneficiaryAddressLine2: String?
    
    /// SWIFT beneficiary city
    public let swiftBeneficiaryCity: String?
    
    /// SWIFT beneficiary country
    public let swiftBeneficiaryCountry: Country?
    
    /// SWIFT beneficiary postal code
    public let swiftBeneficiaryPostalCode: String?
    
    /// SWIFT beneficiary state/province/region
    public let swiftBeneficiaryStateProvinceRegion: String?
    
    /// SWIFT bank name
    public let swiftBankName: String?
    
    /// SWIFT bank address line 1
    public let swiftBankAddressLine1: String?
    
    /// SWIFT bank address line 2
    public let swiftBankAddressLine2: String?
    
    /// SWIFT bank country
    public let swiftBankCountry: Country?
    
    /// SWIFT bank city
    public let swiftBankCity: String?
    
    /// SWIFT bank postal code
    public let swiftBankPostalCode: String?
    
    /// SWIFT bank state/province/region
    public let swiftBankStateProvinceRegion: String?
    
    /// SWIFT intermediary bank SWIFT code BIC
    public let swiftIntermediaryBankSwiftCodeBic: String?
    
    /// SWIFT intermediary bank account number IBAN
    public let swiftIntermediaryBankAccountNumberIban: String?
    
    /// SWIFT intermediary bank name
    public let swiftIntermediaryBankName: String?
    
    /// SWIFT intermediary bank country
    public let swiftIntermediaryBankCountry: Country?
    
    /// Tron wallet hash
    public let tronWalletHash: String?
    
    /// Offramp wallets
    public let offrampWallets: [OfframpWallet]?
    
    /// Timestamp when the bank account was created
    public let createdAt: String
    
    public init(
        id: String,
        name: String,
        type: Rail,
        accountClass: AccountClass? = nil,
        accountNumber: String? = nil,
        accountType: BankAccountType? = nil,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        beneficiaryName: String? = nil,
        city: String? = nil,
        country: Country? = nil,
        postalCode: String? = nil,
        routingNumber: String? = nil,
        stateProvinceRegion: String? = nil,
        pixKey: String? = nil,
        pixSafeBankCode: String? = nil,
        pixSafeBranchCode: String? = nil,
        pixSafeCpfCnpj: String? = nil,
        speiClabe: String? = nil,
        speiInstitutionCode: String? = nil,
        speiProtocol: SpeiProtocol? = nil,
        transfersAccount: String? = nil,
        transfersType: TransfersType? = nil,
        achCopBankAccount: String? = nil,
        achCopBankCode: String? = nil,
        achCopBeneficiaryFirstName: String? = nil,
        achCopBeneficiaryLastName: String? = nil,
        achCopDocumentId: String? = nil,
        achCopDocumentType: AchCopDocumentType? = nil,
        achCopEmail: String? = nil,
        swiftCodeBic: String? = nil,
        swiftAccountHolderName: String? = nil,
        swiftAccountNumberIban: String? = nil,
        swiftBeneficiaryAddressLine1: String? = nil,
        swiftBeneficiaryAddressLine2: String? = nil,
        swiftBeneficiaryCity: String? = nil,
        swiftBeneficiaryCountry: Country? = nil,
        swiftBeneficiaryPostalCode: String? = nil,
        swiftBeneficiaryStateProvinceRegion: String? = nil,
        swiftBankName: String? = nil,
        swiftBankAddressLine1: String? = nil,
        swiftBankAddressLine2: String? = nil,
        swiftBankCountry: Country? = nil,
        swiftBankCity: String? = nil,
        swiftBankPostalCode: String? = nil,
        swiftBankStateProvinceRegion: String? = nil,
        swiftIntermediaryBankSwiftCodeBic: String? = nil,
        swiftIntermediaryBankAccountNumberIban: String? = nil,
        swiftIntermediaryBankName: String? = nil,
        swiftIntermediaryBankCountry: Country? = nil,
        tronWalletHash: String? = nil,
        offrampWallets: [OfframpWallet]? = nil,
        createdAt: String
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.accountClass = accountClass
        self.accountNumber = accountNumber
        self.accountType = accountType
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.beneficiaryName = beneficiaryName
        self.city = city
        self.country = country
        self.postalCode = postalCode
        self.routingNumber = routingNumber
        self.stateProvinceRegion = stateProvinceRegion
        self.pixKey = pixKey
        self.pixSafeBankCode = pixSafeBankCode
        self.pixSafeBranchCode = pixSafeBranchCode
        self.pixSafeCpfCnpj = pixSafeCpfCnpj
        self.speiClabe = speiClabe
        self.speiInstitutionCode = speiInstitutionCode
        self.speiProtocol = speiProtocol
        self.transfersAccount = transfersAccount
        self.transfersType = transfersType
        self.achCopBankAccount = achCopBankAccount
        self.achCopBankCode = achCopBankCode
        self.achCopBeneficiaryFirstName = achCopBeneficiaryFirstName
        self.achCopBeneficiaryLastName = achCopBeneficiaryLastName
        self.achCopDocumentId = achCopDocumentId
        self.achCopDocumentType = achCopDocumentType
        self.achCopEmail = achCopEmail
        self.swiftCodeBic = swiftCodeBic
        self.swiftAccountHolderName = swiftAccountHolderName
        self.swiftAccountNumberIban = swiftAccountNumberIban
        self.swiftBeneficiaryAddressLine1 = swiftBeneficiaryAddressLine1
        self.swiftBeneficiaryAddressLine2 = swiftBeneficiaryAddressLine2
        self.swiftBeneficiaryCity = swiftBeneficiaryCity
        self.swiftBeneficiaryCountry = swiftBeneficiaryCountry
        self.swiftBeneficiaryPostalCode = swiftBeneficiaryPostalCode
        self.swiftBeneficiaryStateProvinceRegion = swiftBeneficiaryStateProvinceRegion
        self.swiftBankName = swiftBankName
        self.swiftBankAddressLine1 = swiftBankAddressLine1
        self.swiftBankAddressLine2 = swiftBankAddressLine2
        self.swiftBankCountry = swiftBankCountry
        self.swiftBankCity = swiftBankCity
        self.swiftBankPostalCode = swiftBankPostalCode
        self.swiftBankStateProvinceRegion = swiftBankStateProvinceRegion
        self.swiftIntermediaryBankSwiftCodeBic = swiftIntermediaryBankSwiftCodeBic
        self.swiftIntermediaryBankAccountNumberIban = swiftIntermediaryBankAccountNumberIban
        self.swiftIntermediaryBankName = swiftIntermediaryBankName
        self.swiftIntermediaryBankCountry = swiftIntermediaryBankCountry
        self.tronWalletHash = tronWalletHash
        self.offrampWallets = offrampWallets
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case accountClass = "account_class"
        case accountNumber = "account_number"
        case accountType = "account_type"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case beneficiaryName = "beneficiary_name"
        case city
        case country
        case postalCode = "postal_code"
        case routingNumber = "routing_number"
        case stateProvinceRegion = "state_province_region"
        case pixKey = "pix_key"
        case pixSafeBankCode = "pix_safe_bank_code"
        case pixSafeBranchCode = "pix_safe_branch_code"
        case pixSafeCpfCnpj = "pix_safe_cpf_cnpj"
        case speiClabe = "spei_clabe"
        case speiInstitutionCode = "spei_institution_code"
        case speiProtocol = "spei_protocol"
        case transfersAccount = "transfers_account"
        case transfersType = "transfers_type"
        case achCopBankAccount = "ach_cop_bank_account"
        case achCopBankCode = "ach_cop_bank_code"
        case achCopBeneficiaryFirstName = "ach_cop_beneficiary_first_name"
        case achCopBeneficiaryLastName = "ach_cop_beneficiary_last_name"
        case achCopDocumentId = "ach_cop_document_id"
        case achCopDocumentType = "ach_cop_document_type"
        case achCopEmail = "ach_cop_email"
        case swiftCodeBic = "swift_code_bic"
        case swiftAccountHolderName = "swift_account_holder_name"
        case swiftAccountNumberIban = "swift_account_number_iban"
        case swiftBeneficiaryAddressLine1 = "swift_beneficiary_address_line_1"
        case swiftBeneficiaryAddressLine2 = "swift_beneficiary_address_line_2"
        case swiftBeneficiaryCity = "swift_beneficiary_city"
        case swiftBeneficiaryCountry = "swift_beneficiary_country"
        case swiftBeneficiaryPostalCode = "swift_beneficiary_postal_code"
        case swiftBeneficiaryStateProvinceRegion = "swift_beneficiary_state_province_region"
        case swiftBankName = "swift_bank_name"
        case swiftBankAddressLine1 = "swift_bank_address_line_1"
        case swiftBankAddressLine2 = "swift_bank_address_line_2"
        case swiftBankCountry = "swift_bank_country"
        case swiftBankCity = "swift_bank_city"
        case swiftBankPostalCode = "swift_bank_postal_code"
        case swiftBankStateProvinceRegion = "swift_bank_state_province_region"
        case swiftIntermediaryBankSwiftCodeBic = "swift_intermediary_bank_swift_code_bic"
        case swiftIntermediaryBankAccountNumberIban = "swift_intermediary_bank_account_number_iban"
        case swiftIntermediaryBankName = "swift_intermediary_bank_name"
        case swiftIntermediaryBankCountry = "swift_intermediary_bank_country"
        case tronWalletHash = "tron_wallet_hash"
        case offrampWallets = "offramp_wallets"
        case createdAt = "created_at"
    }
}

// MARK: - Response Types

/// Response type for listing bank accounts
public typealias BankAccountsResponse = [BankAccount]

/// Response type for a single bank account
public typealias BankAccountResponse = BankAccount

/// Response type for creating a bank account
public typealias CreateBankAccountResponse = BankAccount

// MARK: - Input Types

/// Input for creating a bank account
public struct CreateBankAccountInput: Codable, Sendable {
    /// Bank account name
    public let name: String
    
    /// Bank account type (rail)
    public let type: Rail
    
    /// Account class (individual or business)
    public let accountClass: AccountClass?
    
    /// Account number
    public let accountNumber: String?
    
    /// Account type (checking or savings)
    public let accountType: BankAccountType?
    
    /// ACH COP bank account
    public let achCopBankAccount: String?
    
    /// ACH COP bank code
    public let achCopBankCode: String?
    
    /// ACH COP beneficiary first name
    public let achCopBeneficiaryFirstName: String?
    
    /// ACH COP beneficiary last name
    public let achCopBeneficiaryLastName: String?
    
    /// ACH COP document ID
    public let achCopDocumentId: String?
    
    /// ACH COP document type
    public let achCopDocumentType: AchCopDocumentType?
    
    /// ACH COP email
    public let achCopEmail: String?
    
    /// Address line 1
    public let addressLine1: String?
    
    /// Address line 2
    public let addressLine2: String?
    
    /// Beneficiary name
    public let beneficiaryName: String?
    
    /// City
    public let city: String?
    
    /// Country code
    public let country: Country?
    
    /// Postal code
    public let postalCode: String?
    
    /// PIX key
    public let pixKey: String?
    
    /// PIX Safe bank code
    public let pixSafeBankCode: String?
    
    /// PIX Safe branch code
    public let pixSafeBranchCode: String?
    
    /// PIX Safe CPF/CNPJ
    public let pixSafeCpfCnpj: String?
    
    /// Routing number
    public let routingNumber: String?
    
    /// SPEI CLABE
    public let speiClabe: String?
    
    /// SPEI institution code
    public let speiInstitutionCode: String?
    
    /// SPEI protocol
    public let speiProtocol: SpeiProtocol?
    
    /// State/province/region
    public let stateProvinceRegion: String?
    
    /// SWIFT account holder name
    public let swiftAccountHolderName: String?
    
    /// SWIFT account number IBAN
    public let swiftAccountNumberIban: String?
    
    /// SWIFT bank address line 1
    public let swiftBankAddressLine1: String?
    
    /// SWIFT bank address line 2
    public let swiftBankAddressLine2: String?
    
    /// SWIFT bank city
    public let swiftBankCity: String?
    
    /// SWIFT bank country
    public let swiftBankCountry: Country?
    
    /// SWIFT bank name
    public let swiftBankName: String?
    
    /// SWIFT bank postal code
    public let swiftBankPostalCode: String?
    
    /// SWIFT bank state/province/region
    public let swiftBankStateProvinceRegion: String?
    
    /// SWIFT beneficiary address line 1
    public let swiftBeneficiaryAddressLine1: String?
    
    /// SWIFT beneficiary address line 2
    public let swiftBeneficiaryAddressLine2: String?
    
    /// SWIFT beneficiary city
    public let swiftBeneficiaryCity: String?
    
    /// SWIFT beneficiary country
    public let swiftBeneficiaryCountry: Country?
    
    /// SWIFT beneficiary postal code
    public let swiftBeneficiaryPostalCode: String?
    
    /// SWIFT beneficiary state/province/region
    public let swiftBeneficiaryStateProvinceRegion: String?
    
    /// SWIFT code BIC
    public let swiftCodeBic: String?
    
    /// SWIFT intermediary bank account number IBAN
    public let swiftIntermediaryBankAccountNumberIban: String?
    
    /// SWIFT intermediary bank country
    public let swiftIntermediaryBankCountry: Country?
    
    /// SWIFT intermediary bank name
    public let swiftIntermediaryBankName: String?
    
    /// SWIFT intermediary bank SWIFT code BIC
    public let swiftIntermediaryBankSwiftCodeBic: String?
    
    /// Transfers account
    public let transfersAccount: String?
    
    /// Transfers type
    public let transfersType: TransfersType?
    
    public init(
        name: String,
        type: Rail,
        accountClass: AccountClass? = nil,
        accountNumber: String? = nil,
        accountType: BankAccountType? = nil,
        achCopBankAccount: String? = nil,
        achCopBankCode: String? = nil,
        achCopBeneficiaryFirstName: String? = nil,
        achCopBeneficiaryLastName: String? = nil,
        achCopDocumentId: String? = nil,
        achCopDocumentType: AchCopDocumentType? = nil,
        achCopEmail: String? = nil,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        beneficiaryName: String? = nil,
        city: String? = nil,
        country: Country? = nil,
        postalCode: String? = nil,
        pixKey: String? = nil,
        pixSafeBankCode: String? = nil,
        pixSafeBranchCode: String? = nil,
        pixSafeCpfCnpj: String? = nil,
        routingNumber: String? = nil,
        speiClabe: String? = nil,
        speiInstitutionCode: String? = nil,
        speiProtocol: SpeiProtocol? = nil,
        stateProvinceRegion: String? = nil,
        swiftAccountHolderName: String? = nil,
        swiftAccountNumberIban: String? = nil,
        swiftBankAddressLine1: String? = nil,
        swiftBankAddressLine2: String? = nil,
        swiftBankCity: String? = nil,
        swiftBankCountry: Country? = nil,
        swiftBankName: String? = nil,
        swiftBankPostalCode: String? = nil,
        swiftBankStateProvinceRegion: String? = nil,
        swiftBeneficiaryAddressLine1: String? = nil,
        swiftBeneficiaryAddressLine2: String? = nil,
        swiftBeneficiaryCity: String? = nil,
        swiftBeneficiaryCountry: Country? = nil,
        swiftBeneficiaryPostalCode: String? = nil,
        swiftBeneficiaryStateProvinceRegion: String? = nil,
        swiftCodeBic: String? = nil,
        swiftIntermediaryBankAccountNumberIban: String? = nil,
        swiftIntermediaryBankCountry: Country? = nil,
        swiftIntermediaryBankName: String? = nil,
        swiftIntermediaryBankSwiftCodeBic: String? = nil,
        transfersAccount: String? = nil,
        transfersType: TransfersType? = nil
    ) {
        self.name = name
        self.type = type
        self.accountClass = accountClass
        self.accountNumber = accountNumber
        self.accountType = accountType
        self.achCopBankAccount = achCopBankAccount
        self.achCopBankCode = achCopBankCode
        self.achCopBeneficiaryFirstName = achCopBeneficiaryFirstName
        self.achCopBeneficiaryLastName = achCopBeneficiaryLastName
        self.achCopDocumentId = achCopDocumentId
        self.achCopDocumentType = achCopDocumentType
        self.achCopEmail = achCopEmail
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.beneficiaryName = beneficiaryName
        self.city = city
        self.country = country
        self.postalCode = postalCode
        self.pixKey = pixKey
        self.pixSafeBankCode = pixSafeBankCode
        self.pixSafeBranchCode = pixSafeBranchCode
        self.pixSafeCpfCnpj = pixSafeCpfCnpj
        self.routingNumber = routingNumber
        self.speiClabe = speiClabe
        self.speiInstitutionCode = speiInstitutionCode
        self.speiProtocol = speiProtocol
        self.stateProvinceRegion = stateProvinceRegion
        self.swiftAccountHolderName = swiftAccountHolderName
        self.swiftAccountNumberIban = swiftAccountNumberIban
        self.swiftBankAddressLine1 = swiftBankAddressLine1
        self.swiftBankAddressLine2 = swiftBankAddressLine2
        self.swiftBankCity = swiftBankCity
        self.swiftBankCountry = swiftBankCountry
        self.swiftBankName = swiftBankName
        self.swiftBankPostalCode = swiftBankPostalCode
        self.swiftBankStateProvinceRegion = swiftBankStateProvinceRegion
        self.swiftBeneficiaryAddressLine1 = swiftBeneficiaryAddressLine1
        self.swiftBeneficiaryAddressLine2 = swiftBeneficiaryAddressLine2
        self.swiftBeneficiaryCity = swiftBeneficiaryCity
        self.swiftBeneficiaryCountry = swiftBeneficiaryCountry
        self.swiftBeneficiaryPostalCode = swiftBeneficiaryPostalCode
        self.swiftBeneficiaryStateProvinceRegion = swiftBeneficiaryStateProvinceRegion
        self.swiftCodeBic = swiftCodeBic
        self.swiftIntermediaryBankAccountNumberIban = swiftIntermediaryBankAccountNumberIban
        self.swiftIntermediaryBankCountry = swiftIntermediaryBankCountry
        self.swiftIntermediaryBankName = swiftIntermediaryBankName
        self.swiftIntermediaryBankSwiftCodeBic = swiftIntermediaryBankSwiftCodeBic
        self.transfersAccount = transfersAccount
        self.transfersType = transfersType
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case accountClass = "account_class"
        case accountNumber = "account_number"
        case accountType = "account_type"
        case achCopBankAccount = "ach_cop_bank_account"
        case achCopBankCode = "ach_cop_bank_code"
        case achCopBeneficiaryFirstName = "ach_cop_beneficiary_first_name"
        case achCopBeneficiaryLastName = "ach_cop_beneficiary_last_name"
        case achCopDocumentId = "ach_cop_document_id"
        case achCopDocumentType = "ach_cop_document_type"
        case achCopEmail = "ach_cop_email"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case beneficiaryName = "beneficiary_name"
        case city
        case country
        case postalCode = "postal_code"
        case pixKey = "pix_key"
        case pixSafeBankCode = "pix_safe_bank_code"
        case pixSafeBranchCode = "pix_safe_branch_code"
        case pixSafeCpfCnpj = "pix_safe_cpf_cnpj"
        case routingNumber = "routing_number"
        case speiClabe = "spei_clabe"
        case speiInstitutionCode = "spei_institution_code"
        case speiProtocol = "spei_protocol"
        case stateProvinceRegion = "state_province_region"
        case swiftAccountHolderName = "swift_account_holder_name"
        case swiftAccountNumberIban = "swift_account_number_iban"
        case swiftBankAddressLine1 = "swift_bank_address_line_1"
        case swiftBankAddressLine2 = "swift_bank_address_line_2"
        case swiftBankCity = "swift_bank_city"
        case swiftBankCountry = "swift_bank_country"
        case swiftBankName = "swift_bank_name"
        case swiftBankPostalCode = "swift_bank_postal_code"
        case swiftBankStateProvinceRegion = "swift_bank_state_province_region"
        case swiftBeneficiaryAddressLine1 = "swift_beneficiary_address_line_1"
        case swiftBeneficiaryAddressLine2 = "swift_beneficiary_address_line_2"
        case swiftBeneficiaryCity = "swift_beneficiary_city"
        case swiftBeneficiaryCountry = "swift_beneficiary_country"
        case swiftBeneficiaryPostalCode = "swift_beneficiary_postal_code"
        case swiftBeneficiaryStateProvinceRegion = "swift_beneficiary_state_province_region"
        case swiftCodeBic = "swift_code_bic"
        case swiftIntermediaryBankAccountNumberIban = "swift_intermediary_bank_account_number_iban"
        case swiftIntermediaryBankCountry = "swift_intermediary_bank_country"
        case swiftIntermediaryBankName = "swift_intermediary_bank_name"
        case swiftIntermediaryBankSwiftCodeBic = "swift_intermediary_bank_swift_code_bic"
        case transfersAccount = "transfers_account"
        case transfersType = "transfers_type"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        if let accountClass = accountClass {
            try container.encode(accountClass, forKey: .accountClass)
        }
        if let accountNumber = accountNumber {
            try container.encode(accountNumber, forKey: .accountNumber)
        }
        if let accountType = accountType {
            try container.encode(accountType, forKey: .accountType)
        }
        if let achCopBankAccount = achCopBankAccount {
            try container.encode(achCopBankAccount, forKey: .achCopBankAccount)
        }
        if let achCopBankCode = achCopBankCode {
            try container.encode(achCopBankCode, forKey: .achCopBankCode)
        }
        if let achCopBeneficiaryFirstName = achCopBeneficiaryFirstName {
            try container.encode(achCopBeneficiaryFirstName, forKey: .achCopBeneficiaryFirstName)
        }
        if let achCopBeneficiaryLastName = achCopBeneficiaryLastName {
            try container.encode(achCopBeneficiaryLastName, forKey: .achCopBeneficiaryLastName)
        }
        if let achCopDocumentId = achCopDocumentId {
            try container.encode(achCopDocumentId, forKey: .achCopDocumentId)
        }
        if let achCopDocumentType = achCopDocumentType {
            try container.encode(achCopDocumentType, forKey: .achCopDocumentType)
        }
        if let achCopEmail = achCopEmail {
            try container.encode(achCopEmail, forKey: .achCopEmail)
        }
        if let addressLine1 = addressLine1 {
            try container.encode(addressLine1, forKey: .addressLine1)
        }
        if let addressLine2 = addressLine2 {
            try container.encode(addressLine2, forKey: .addressLine2)
        }
        if let beneficiaryName = beneficiaryName {
            try container.encode(beneficiaryName, forKey: .beneficiaryName)
        }
        if let city = city {
            try container.encode(city, forKey: .city)
        }
        if let country = country {
            try container.encode(country, forKey: .country)
        }
        if let postalCode = postalCode {
            try container.encode(postalCode, forKey: .postalCode)
        }
        if let pixKey = pixKey {
            try container.encode(pixKey, forKey: .pixKey)
        }
        if let pixSafeBankCode = pixSafeBankCode {
            try container.encode(pixSafeBankCode, forKey: .pixSafeBankCode)
        }
        if let pixSafeBranchCode = pixSafeBranchCode {
            try container.encode(pixSafeBranchCode, forKey: .pixSafeBranchCode)
        }
        if let pixSafeCpfCnpj = pixSafeCpfCnpj {
            try container.encode(pixSafeCpfCnpj, forKey: .pixSafeCpfCnpj)
        }
        if let routingNumber = routingNumber {
            try container.encode(routingNumber, forKey: .routingNumber)
        }
        if let speiClabe = speiClabe {
            try container.encode(speiClabe, forKey: .speiClabe)
        }
        if let speiInstitutionCode = speiInstitutionCode {
            try container.encode(speiInstitutionCode, forKey: .speiInstitutionCode)
        }
        if let speiProtocol = speiProtocol {
            try container.encode(speiProtocol, forKey: .speiProtocol)
        }
        if let stateProvinceRegion = stateProvinceRegion {
            try container.encode(stateProvinceRegion, forKey: .stateProvinceRegion)
        }
        if let swiftAccountHolderName = swiftAccountHolderName {
            try container.encode(swiftAccountHolderName, forKey: .swiftAccountHolderName)
        }
        if let swiftAccountNumberIban = swiftAccountNumberIban {
            try container.encode(swiftAccountNumberIban, forKey: .swiftAccountNumberIban)
        }
        if let swiftBankAddressLine1 = swiftBankAddressLine1 {
            try container.encode(swiftBankAddressLine1, forKey: .swiftBankAddressLine1)
        }
        if let swiftBankAddressLine2 = swiftBankAddressLine2 {
            try container.encode(swiftBankAddressLine2, forKey: .swiftBankAddressLine2)
        }
        if let swiftBankCity = swiftBankCity {
            try container.encode(swiftBankCity, forKey: .swiftBankCity)
        }
        if let swiftBankCountry = swiftBankCountry {
            try container.encode(swiftBankCountry, forKey: .swiftBankCountry)
        }
        if let swiftBankName = swiftBankName {
            try container.encode(swiftBankName, forKey: .swiftBankName)
        }
        if let swiftBankPostalCode = swiftBankPostalCode {
            try container.encode(swiftBankPostalCode, forKey: .swiftBankPostalCode)
        }
        if let swiftBankStateProvinceRegion = swiftBankStateProvinceRegion {
            try container.encode(swiftBankStateProvinceRegion, forKey: .swiftBankStateProvinceRegion)
        }
        if let swiftBeneficiaryAddressLine1 = swiftBeneficiaryAddressLine1 {
            try container.encode(swiftBeneficiaryAddressLine1, forKey: .swiftBeneficiaryAddressLine1)
        }
        if let swiftBeneficiaryAddressLine2 = swiftBeneficiaryAddressLine2 {
            try container.encode(swiftBeneficiaryAddressLine2, forKey: .swiftBeneficiaryAddressLine2)
        }
        if let swiftBeneficiaryCity = swiftBeneficiaryCity {
            try container.encode(swiftBeneficiaryCity, forKey: .swiftBeneficiaryCity)
        }
        if let swiftBeneficiaryCountry = swiftBeneficiaryCountry {
            try container.encode(swiftBeneficiaryCountry, forKey: .swiftBeneficiaryCountry)
        }
        if let swiftBeneficiaryPostalCode = swiftBeneficiaryPostalCode {
            try container.encode(swiftBeneficiaryPostalCode, forKey: .swiftBeneficiaryPostalCode)
        }
        if let swiftBeneficiaryStateProvinceRegion = swiftBeneficiaryStateProvinceRegion {
            try container.encode(swiftBeneficiaryStateProvinceRegion, forKey: .swiftBeneficiaryStateProvinceRegion)
        }
        if let swiftCodeBic = swiftCodeBic {
            try container.encode(swiftCodeBic, forKey: .swiftCodeBic)
        }
        if let swiftIntermediaryBankAccountNumberIban = swiftIntermediaryBankAccountNumberIban {
            try container.encode(swiftIntermediaryBankAccountNumberIban, forKey: .swiftIntermediaryBankAccountNumberIban)
        }
        if let swiftIntermediaryBankCountry = swiftIntermediaryBankCountry {
            try container.encode(swiftIntermediaryBankCountry, forKey: .swiftIntermediaryBankCountry)
        }
        if let swiftIntermediaryBankName = swiftIntermediaryBankName {
            try container.encode(swiftIntermediaryBankName, forKey: .swiftIntermediaryBankName)
        }
        if let swiftIntermediaryBankSwiftCodeBic = swiftIntermediaryBankSwiftCodeBic {
            try container.encode(swiftIntermediaryBankSwiftCodeBic, forKey: .swiftIntermediaryBankSwiftCodeBic)
        }
        if let transfersAccount = transfersAccount {
            try container.encode(transfersAccount, forKey: .transfersAccount)
        }
        if let transfersType = transfersType {
            try container.encode(transfersType, forKey: .transfersType)
        }
    }
}

