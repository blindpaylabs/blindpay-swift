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

    /// SEPA beneficiary BIC
    public let sepaBeneficiaryBic: String?

    /// SEPA IBAN
    public let sepaIban: String?

    /// SEPA beneficiary legal name
    public let sepaBeneficiaryLegalName: String?

    /// SEPA beneficiary address line 1
    public let sepaBeneficiaryAddressLine1: String?

    /// SEPA beneficiary address line 2
    public let sepaBeneficiaryAddressLine2: String?

    /// SEPA beneficiary city
    public let sepaBeneficiaryCity: String?

    /// SEPA beneficiary state/province/region
    public let sepaBeneficiaryStateProvinceRegion: String?

    /// SEPA beneficiary postal code
    public let sepaBeneficiaryPostalCode: String?

    /// SEPA beneficiary country
    public let sepaBeneficiaryCountry: Country?

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

    /// TED bank code
    public let tedBankCode: String?

    /// TED branch code
    public let tedBranchCode: String?

    /// TED CPF/CNPJ
    public let tedCpfCnpj: String?

    /// Tron wallet hash
    public let tronWalletHash: String?
    
    /// Offramp wallets
    public let offrampWallets: [OfframpWallet]?
    
    /// Timestamp when the bank account was created
    public let createdAt: String?
    
    public let fasterPaymentsAccountNumber: String?

    public let fasterPaymentsBeneficiaryAddressLine1: String?

    public let fasterPaymentsBeneficiaryAddressLine2: String?

    public let fasterPaymentsBeneficiaryCity: String?

    public let fasterPaymentsBeneficiaryCountry: Country?

    public let fasterPaymentsBeneficiaryLegalName: String?

    public let fasterPaymentsBeneficiaryPostalCode: String?

    public let fasterPaymentsBeneficiaryStateProvinceRegion: String?

    public let fasterPaymentsSortCode: String?

    public let plaidConnectedAt: String?

    public let swiftIntermediaryBankRoutingNumber: String?

    /// NAICS code of the beneficiary business.
    public let businessIndustry: String?

    /// Beneficiary date of birth (ISO 8601).
    public let dateOfBirth: String?

    /// Beneficiary phone number.
    public let phoneNumber: String?

    /// How the customer relates to the beneficiary.
    public let recipientRelationship: RecipientRelationship?

    /// Review status of the bank account.
    public let status: BankAccountStatus?

    /// IFSC branch code for India SWIFT payouts (e.g. `BARB0AHIMCI`).
    public let swiftIfscBranchCode: String?

    /// Country-specific SWIFT payment purpose code.
    public let swiftPaymentCode: String?

    /// Beneficiary tax id.
    public let taxId: String?

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
        sepaBeneficiaryBic: String? = nil,
        sepaIban: String? = nil,
        sepaBeneficiaryLegalName: String? = nil,
        sepaBeneficiaryAddressLine1: String? = nil,
        sepaBeneficiaryAddressLine2: String? = nil,
        sepaBeneficiaryCity: String? = nil,
        sepaBeneficiaryStateProvinceRegion: String? = nil,
        sepaBeneficiaryPostalCode: String? = nil,
        sepaBeneficiaryCountry: Country? = nil,
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
        tedBankCode: String? = nil,
        tedBranchCode: String? = nil,
        tedCpfCnpj: String? = nil,
        tronWalletHash: String? = nil,
        offrampWallets: [OfframpWallet]? = nil,
        createdAt: String? = nil,
        fasterPaymentsAccountNumber: String? = nil,
        fasterPaymentsBeneficiaryAddressLine1: String? = nil,
        fasterPaymentsBeneficiaryAddressLine2: String? = nil,
        fasterPaymentsBeneficiaryCity: String? = nil,
        fasterPaymentsBeneficiaryCountry: Country? = nil,
        fasterPaymentsBeneficiaryLegalName: String? = nil,
        fasterPaymentsBeneficiaryPostalCode: String? = nil,
        fasterPaymentsBeneficiaryStateProvinceRegion: String? = nil,
        fasterPaymentsSortCode: String? = nil,
        plaidConnectedAt: String? = nil,
        swiftIntermediaryBankRoutingNumber: String? = nil,
        businessIndustry: String? = nil,
        dateOfBirth: String? = nil,
        phoneNumber: String? = nil,
        recipientRelationship: RecipientRelationship? = nil,
        status: BankAccountStatus? = nil,
        swiftIfscBranchCode: String? = nil,
        swiftPaymentCode: String? = nil,
        taxId: String? = nil
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
        self.sepaBeneficiaryBic = sepaBeneficiaryBic
        self.sepaIban = sepaIban
        self.sepaBeneficiaryLegalName = sepaBeneficiaryLegalName
        self.sepaBeneficiaryAddressLine1 = sepaBeneficiaryAddressLine1
        self.sepaBeneficiaryAddressLine2 = sepaBeneficiaryAddressLine2
        self.sepaBeneficiaryCity = sepaBeneficiaryCity
        self.sepaBeneficiaryStateProvinceRegion = sepaBeneficiaryStateProvinceRegion
        self.sepaBeneficiaryPostalCode = sepaBeneficiaryPostalCode
        self.sepaBeneficiaryCountry = sepaBeneficiaryCountry
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
        self.tedBankCode = tedBankCode
        self.tedBranchCode = tedBranchCode
        self.tedCpfCnpj = tedCpfCnpj
        self.tronWalletHash = tronWalletHash
        self.offrampWallets = offrampWallets
        self.createdAt = createdAt
        self.fasterPaymentsAccountNumber = fasterPaymentsAccountNumber
        self.fasterPaymentsBeneficiaryAddressLine1 = fasterPaymentsBeneficiaryAddressLine1
        self.fasterPaymentsBeneficiaryAddressLine2 = fasterPaymentsBeneficiaryAddressLine2
        self.fasterPaymentsBeneficiaryCity = fasterPaymentsBeneficiaryCity
        self.fasterPaymentsBeneficiaryCountry = fasterPaymentsBeneficiaryCountry
        self.fasterPaymentsBeneficiaryLegalName = fasterPaymentsBeneficiaryLegalName
        self.fasterPaymentsBeneficiaryPostalCode = fasterPaymentsBeneficiaryPostalCode
        self.fasterPaymentsBeneficiaryStateProvinceRegion = fasterPaymentsBeneficiaryStateProvinceRegion
        self.fasterPaymentsSortCode = fasterPaymentsSortCode
        self.plaidConnectedAt = plaidConnectedAt
        self.swiftIntermediaryBankRoutingNumber = swiftIntermediaryBankRoutingNumber
        self.businessIndustry = businessIndustry
        self.dateOfBirth = dateOfBirth
        self.phoneNumber = phoneNumber
        self.recipientRelationship = recipientRelationship
        self.status = status
        self.swiftIfscBranchCode = swiftIfscBranchCode
        self.swiftPaymentCode = swiftPaymentCode
        self.taxId = taxId
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
        case sepaBeneficiaryBic = "sepa_beneficiary_bic"
        case sepaIban = "sepa_iban"
        case sepaBeneficiaryLegalName = "sepa_beneficiary_legal_name"
        case sepaBeneficiaryAddressLine1 = "sepa_beneficiary_address_line_1"
        case sepaBeneficiaryAddressLine2 = "sepa_beneficiary_address_line_2"
        case sepaBeneficiaryCity = "sepa_beneficiary_city"
        case sepaBeneficiaryStateProvinceRegion = "sepa_beneficiary_state_province_region"
        case sepaBeneficiaryPostalCode = "sepa_beneficiary_postal_code"
        case sepaBeneficiaryCountry = "sepa_beneficiary_country"
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
        case tedBankCode = "ted_bank_code"
        case tedBranchCode = "ted_branch_code"
        case tedCpfCnpj = "ted_cpf_cnpj"
        case tronWalletHash = "tron_wallet_hash"
        case offrampWallets = "offramp_wallets"
        case createdAt = "created_at"
        case fasterPaymentsAccountNumber = "faster_payments_account_number"
        case fasterPaymentsBeneficiaryAddressLine1 = "faster_payments_beneficiary_address_line_1"
        case fasterPaymentsBeneficiaryAddressLine2 = "faster_payments_beneficiary_address_line_2"
        case fasterPaymentsBeneficiaryCity = "faster_payments_beneficiary_city"
        case fasterPaymentsBeneficiaryCountry = "faster_payments_beneficiary_country"
        case fasterPaymentsBeneficiaryLegalName = "faster_payments_beneficiary_legal_name"
        case fasterPaymentsBeneficiaryPostalCode = "faster_payments_beneficiary_postal_code"
        case fasterPaymentsBeneficiaryStateProvinceRegion = "faster_payments_beneficiary_state_province_region"
        case fasterPaymentsSortCode = "faster_payments_sort_code"
        case plaidConnectedAt = "plaid_connected_at"
        case swiftIntermediaryBankRoutingNumber = "swift_intermediary_bank_routing_number"
        case businessIndustry = "business_industry"
        case dateOfBirth = "date_of_birth"
        case phoneNumber = "phone_number"
        case recipientRelationship = "recipient_relationship"
        case status
        case swiftIfscBranchCode = "swift_ifsc_branch_code"
        case swiftPaymentCode = "swift_payment_code"
        case taxId = "tax_id"
    }
}

// MARK: - Response Types

/// Response type for listing bank accounts
public typealias BankAccountsResponse = [BankAccount]

/// Response type for a single bank account
public typealias BankAccountResponse = BankAccount

/// Response type for creating a bank account
public typealias CreateBankAccountResponse = BankAccount


/// Review status of a bank account.
public struct BankAccountStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let verifying = BankAccountStatus(rawValue: "verifying")
    public static let approved = BankAccountStatus(rawValue: "approved")
    public static let rejected = BankAccountStatus(rawValue: "rejected")
    public static let deprecated = BankAccountStatus(rawValue: "deprecated")
}

/// Filters for listing a customer's bank accounts. Every value is optional; unset ones are not sent.
public struct ListBankAccountsInput: Sendable {
    /// Only this status.
    public var status: BankAccountStatus?

    /// Only this rail.
    public var type: Rail?

    /// Name contains this text.
    public var name: String?

    /// Only this bank account.
    public var bankAccountId: String?

    /// Only this country.
    public var country: Country?

    public init(
        status: BankAccountStatus? = nil,
        type: Rail? = nil,
        name: String? = nil,
        bankAccountId: String? = nil,
        country: Country? = nil
    ) {
        self.status = status
        self.type = type
        self.name = name
        self.bankAccountId = bankAccountId
        self.country = country
    }

    func toQueryParameters() -> QueryParameters {
        var params = QueryParameters()
        params["status"] = status?.rawValue
        params["type"] = type?.rawValue
        params["name"] = name
        params["bank_account_id"] = bankAccountId
        params["country"] = country?.rawValue
        return params
    }
}

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

    /// Recipient relationship
    public let recipientRelationship: RecipientRelationship?

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

    /// SEPA beneficiary BIC
    public let sepaBeneficiaryBic: String?

    /// SEPA IBAN
    public let sepaIban: String?

    /// SEPA beneficiary legal name
    public let sepaBeneficiaryLegalName: String?

    /// SEPA beneficiary address line 1
    public let sepaBeneficiaryAddressLine1: String?

    /// SEPA beneficiary address line 2
    public let sepaBeneficiaryAddressLine2: String?

    /// SEPA beneficiary city
    public let sepaBeneficiaryCity: String?

    /// SEPA beneficiary state/province/region
    public let sepaBeneficiaryStateProvinceRegion: String?

    /// SEPA beneficiary postal code
    public let sepaBeneficiaryPostalCode: String?

    /// SEPA beneficiary country
    public let sepaBeneficiaryCountry: Country?

    /// SWIFT payment code (required for PK, PH, KE, JP, IN, ID, CN, CH, BH)
    public let swiftPaymentCode: String?

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

    /// Business industry (NAICS code, required when account_class is business)
    public let businessIndustry: String?

    /// Phone number (required for certain countries)
    public let phoneNumber: String?

    /// Tax ID (required for certain countries)
    public let taxId: String?

    /// Date of birth
    public let dateOfBirth: String?

    /// TED bank code
    public let tedBankCode: String?

    /// TED branch code
    public let tedBranchCode: String?

    /// TED CPF/CNPJ
    public let tedCpfCnpj: String?

    public let fasterPaymentsAccountNumber: String?

    public let fasterPaymentsBeneficiaryAddressLine1: String?

    public let fasterPaymentsBeneficiaryAddressLine2: String?

    public let fasterPaymentsBeneficiaryCity: String?

    public let fasterPaymentsBeneficiaryCountry: Country?

    public let fasterPaymentsBeneficiaryLegalName: String?

    public let fasterPaymentsBeneficiaryPostalCode: String?

    public let fasterPaymentsBeneficiaryStateProvinceRegion: String?

    public let fasterPaymentsSortCode: String?

    public let swiftIntermediaryBankRoutingNumber: String?

    /// Force CPF/CNPJ validation for PIX key
    public let forceCpfCnpj: Bool?

    /// Initial review status. Usually omitted; BlindPay sets it.
    public let status: BankAccountStatus?

    /// IFSC branch code, required for India (`international_swift` to INR): four letters, `0`, then six characters (e.g. `BARB0AHIMCI`).
    public let swiftIfscBranchCode: String?

    public init(
        name: String,
        type: Rail,
        accountClass: AccountClass? = nil,
        accountNumber: String? = nil,
        accountType: BankAccountType? = nil,
        recipientRelationship: RecipientRelationship? = nil,
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
        sepaBeneficiaryBic: String? = nil,
        sepaIban: String? = nil,
        sepaBeneficiaryLegalName: String? = nil,
        sepaBeneficiaryAddressLine1: String? = nil,
        sepaBeneficiaryAddressLine2: String? = nil,
        sepaBeneficiaryCity: String? = nil,
        sepaBeneficiaryStateProvinceRegion: String? = nil,
        sepaBeneficiaryPostalCode: String? = nil,
        sepaBeneficiaryCountry: Country? = nil,
        swiftPaymentCode: String? = nil,
        swiftIntermediaryBankAccountNumberIban: String? = nil,
        swiftIntermediaryBankCountry: Country? = nil,
        swiftIntermediaryBankName: String? = nil,
        swiftIntermediaryBankSwiftCodeBic: String? = nil,
        transfersAccount: String? = nil,
        transfersType: TransfersType? = nil,
        businessIndustry: String? = nil,
        phoneNumber: String? = nil,
        taxId: String? = nil,
        dateOfBirth: String? = nil,
        tedBankCode: String? = nil,
        tedBranchCode: String? = nil,
        tedCpfCnpj: String? = nil,
        fasterPaymentsAccountNumber: String? = nil,
        fasterPaymentsBeneficiaryAddressLine1: String? = nil,
        fasterPaymentsBeneficiaryAddressLine2: String? = nil,
        fasterPaymentsBeneficiaryCity: String? = nil,
        fasterPaymentsBeneficiaryCountry: Country? = nil,
        fasterPaymentsBeneficiaryLegalName: String? = nil,
        fasterPaymentsBeneficiaryPostalCode: String? = nil,
        fasterPaymentsBeneficiaryStateProvinceRegion: String? = nil,
        fasterPaymentsSortCode: String? = nil,
        swiftIntermediaryBankRoutingNumber: String? = nil,
        forceCpfCnpj: Bool? = nil,
        status: BankAccountStatus? = nil,
        swiftIfscBranchCode: String? = nil
    ) {
        self.name = name
        self.type = type
        self.accountClass = accountClass
        self.accountNumber = accountNumber
        self.accountType = accountType
        self.recipientRelationship = recipientRelationship
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
        self.sepaBeneficiaryBic = sepaBeneficiaryBic
        self.sepaIban = sepaIban
        self.sepaBeneficiaryLegalName = sepaBeneficiaryLegalName
        self.sepaBeneficiaryAddressLine1 = sepaBeneficiaryAddressLine1
        self.sepaBeneficiaryAddressLine2 = sepaBeneficiaryAddressLine2
        self.sepaBeneficiaryCity = sepaBeneficiaryCity
        self.sepaBeneficiaryStateProvinceRegion = sepaBeneficiaryStateProvinceRegion
        self.sepaBeneficiaryPostalCode = sepaBeneficiaryPostalCode
        self.sepaBeneficiaryCountry = sepaBeneficiaryCountry
        self.swiftPaymentCode = swiftPaymentCode
        self.swiftIntermediaryBankAccountNumberIban = swiftIntermediaryBankAccountNumberIban
        self.swiftIntermediaryBankCountry = swiftIntermediaryBankCountry
        self.swiftIntermediaryBankName = swiftIntermediaryBankName
        self.swiftIntermediaryBankSwiftCodeBic = swiftIntermediaryBankSwiftCodeBic
        self.transfersAccount = transfersAccount
        self.transfersType = transfersType
        self.businessIndustry = businessIndustry
        self.phoneNumber = phoneNumber
        self.taxId = taxId
        self.dateOfBirth = dateOfBirth
        self.tedBankCode = tedBankCode
        self.tedBranchCode = tedBranchCode
        self.tedCpfCnpj = tedCpfCnpj
        self.fasterPaymentsAccountNumber = fasterPaymentsAccountNumber
        self.fasterPaymentsBeneficiaryAddressLine1 = fasterPaymentsBeneficiaryAddressLine1
        self.fasterPaymentsBeneficiaryAddressLine2 = fasterPaymentsBeneficiaryAddressLine2
        self.fasterPaymentsBeneficiaryCity = fasterPaymentsBeneficiaryCity
        self.fasterPaymentsBeneficiaryCountry = fasterPaymentsBeneficiaryCountry
        self.fasterPaymentsBeneficiaryLegalName = fasterPaymentsBeneficiaryLegalName
        self.fasterPaymentsBeneficiaryPostalCode = fasterPaymentsBeneficiaryPostalCode
        self.fasterPaymentsBeneficiaryStateProvinceRegion = fasterPaymentsBeneficiaryStateProvinceRegion
        self.fasterPaymentsSortCode = fasterPaymentsSortCode
        self.swiftIntermediaryBankRoutingNumber = swiftIntermediaryBankRoutingNumber
        self.forceCpfCnpj = forceCpfCnpj
        self.status = status
        self.swiftIfscBranchCode = swiftIfscBranchCode
    }

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case accountClass = "account_class"
        case accountNumber = "account_number"
        case accountType = "account_type"
        case recipientRelationship = "recipient_relationship"
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
        case sepaBeneficiaryBic = "sepa_beneficiary_bic"
        case sepaIban = "sepa_iban"
        case sepaBeneficiaryLegalName = "sepa_beneficiary_legal_name"
        case sepaBeneficiaryAddressLine1 = "sepa_beneficiary_address_line_1"
        case sepaBeneficiaryAddressLine2 = "sepa_beneficiary_address_line_2"
        case sepaBeneficiaryCity = "sepa_beneficiary_city"
        case sepaBeneficiaryStateProvinceRegion = "sepa_beneficiary_state_province_region"
        case sepaBeneficiaryPostalCode = "sepa_beneficiary_postal_code"
        case sepaBeneficiaryCountry = "sepa_beneficiary_country"
        case swiftPaymentCode = "swift_payment_code"
        case swiftIntermediaryBankAccountNumberIban = "swift_intermediary_bank_account_number_iban"
        case swiftIntermediaryBankCountry = "swift_intermediary_bank_country"
        case swiftIntermediaryBankName = "swift_intermediary_bank_name"
        case swiftIntermediaryBankSwiftCodeBic = "swift_intermediary_bank_swift_code_bic"
        case transfersAccount = "transfers_account"
        case transfersType = "transfers_type"
        case businessIndustry = "business_industry"
        case phoneNumber = "phone_number"
        case taxId = "tax_id"
        case dateOfBirth = "date_of_birth"
        case tedBankCode = "ted_bank_code"
        case tedBranchCode = "ted_branch_code"
        case tedCpfCnpj = "ted_cpf_cnpj"
        case fasterPaymentsAccountNumber = "faster_payments_account_number"
        case fasterPaymentsBeneficiaryAddressLine1 = "faster_payments_beneficiary_address_line_1"
        case fasterPaymentsBeneficiaryAddressLine2 = "faster_payments_beneficiary_address_line_2"
        case fasterPaymentsBeneficiaryCity = "faster_payments_beneficiary_city"
        case fasterPaymentsBeneficiaryCountry = "faster_payments_beneficiary_country"
        case fasterPaymentsBeneficiaryLegalName = "faster_payments_beneficiary_legal_name"
        case fasterPaymentsBeneficiaryPostalCode = "faster_payments_beneficiary_postal_code"
        case fasterPaymentsBeneficiaryStateProvinceRegion = "faster_payments_beneficiary_state_province_region"
        case fasterPaymentsSortCode = "faster_payments_sort_code"
        case swiftIntermediaryBankRoutingNumber = "swift_intermediary_bank_routing_number"
        case forceCpfCnpj = "force_cpf_cnpj"
        case status
        case swiftIfscBranchCode = "swift_ifsc_branch_code"
    }
}

// MARK: - Plaid

/// Input for creating a Plaid Link session for a customer's bank account.
public struct CreatePlaidLinkInput: Codable, Sendable {
    /// Where Plaid sends the customer when they finish.
    public let redirectUrl: String?

    public init(redirectUrl: String? = nil) {
        self.redirectUrl = redirectUrl
    }

    enum CodingKeys: String, CodingKey {
        case redirectUrl = "redirect_url"
    }
}

/// A Plaid Link session: send the customer to `url`.
public struct PlaidLinkResponse: Codable, Sendable, Equatable {
    public let url: String

    public init(url: String) {
        self.url = url
    }
}
