//
//  Available.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

// MARK: - Enums

/// Payment rail type
public enum Rail: String, Codable, Sendable {
    case wire = "wire"
    case ach = "ach"
    case pix = "pix"
    case pixSafe = "pix_safe"
    case speiBitso = "spei_bitso"
    case transfersBitso = "transfers_bitso"
    case achCopBitso = "ach_cop_bitso"
    case internationalSwift = "international_swift"
    case rtp = "rtp"
}

/// Bank account type
public enum BankAccountType: String, Codable, Sendable {
    case checking = "checking"
    case savings = "savings"
}

/// Account class type
public enum AccountClass: String, Codable, Sendable {
    case individual = "individual"
    case business = "business"
}

// MARK: - Rail Response

/// Represents an available payment rail
public struct RailResponse: Codable, Sendable, Equatable {
    /// Display name of the rail (e.g., "Domestic Wire")
    public let label: String

    /// Rail identifier (e.g., "wire", "ach", "pix")
    public let value: String

    /// Country code where this rail is available (e.g., "US", "BR", "MX")
    public let country: String

    public init(label: String, value: String, country: String) {
        self.label = label
        self.value = value
        self.country = country
    }
}

/// Represents a bank detail key field identifier
public enum BankDetailKey: String, Codable, Sendable {
    case type = "type"
    case name = "name"
    case pixKey = "pix_key"
    case beneficiaryName = "beneficiary_name"
    case routingNumber = "routing_number"
    case accountNumber = "account_number"
    case accountType = "account_type"
    case accountClass = "account_class"
    case addressLine1 = "address_line_1"
    case addressLine2 = "address_line_2"
    case city = "city"
    case stateProvinceRegion = "state_province_region"
    case country = "country"
    case postalCode = "postal_code"
    case checkbookAccountId = "checkbook_account_id"
    case checkbookUserKey = "checkbook_user_key"
    case speiProtocol = "spei_protocol"
    case speiInstitutionCode = "spei_institution_code"
    case speiClabe = "spei_clabe"
    case transfersType = "transfers_type"
    case transfersAccount = "transfers_account"
    case achCopBeneficiaryFirstName = "ach_cop_beneficiary_first_name"
    case achCopBeneficiaryLastName = "ach_cop_beneficiary_last_name"
    case achCopDocumentId = "ach_cop_document_id"
    case achCopDocumentType = "ach_cop_document_type"
    case achCopEmail = "ach_cop_email"
    case achCopBankCode = "ach_cop_bank_code"
    case achCopBankAccount = "ach_cop_bank_account"
    case swiftCodeBic = "swift_code_bic"
    case swiftAccountHolderName = "swift_account_holder_name"
    case swiftAccountNumberIban = "swift_account_number_iban"
    case swiftBeneficiaryAddressLine1 = "swift_beneficiary_address_line_1"
    case swiftBeneficiaryAddressLine2 = "swift_beneficiary_address_line_2"
    case swiftBeneficiaryCountry = "swift_beneficiary_country"
    case swiftBeneficiaryCity = "swift_beneficiary_city"
    case swiftBeneficiaryStateProvinceRegion =
        "swift_beneficiary_state_province_region"
    case swiftBeneficiaryPostalCode = "swift_beneficiary_postal_code"
    case swiftBankName = "swift_bank_name"
    case swiftBankAddressLine1 = "swift_bank_address_line_1"
    case swiftBankAddressLine2 = "swift_bank_address_line_2"
    case swiftBankCountry = "swift_bank_country"
    case swiftBankCity = "swift_bank_city"
    case swiftBankStateProvinceRegion = "swift_bank_state_province_region"
    case swiftBankPostalCode = "swift_bank_postal_code"
    case swiftIntermediaryBankSwiftCodeBic =
        "swift_intermediary_bank_swift_code_bic"
    case swiftIntermediaryBankAccountNumberIban =
        "swift_intermediary_bank_account_number_iban"
    case swiftIntermediaryBankName = "swift_intermediary_bank_name"
    case swiftIntermediaryBankCountry = "swift_intermediary_bank_country"
}

/// Represents an item within a bank detail field
public struct BankDetailItem: Codable, Sendable, Equatable {
    /// Display label for the item
    public let label: String

    /// Value for the item
    public let value: String

    /// Whether this item is currently active
    public let isActive: Bool?

    public init(label: String, value: String, isActive: Bool? = nil) {
        self.label = label
        self.value = value
        self.isActive = isActive
    }

    enum CodingKeys: String, CodingKey {
        case label
        case value
        case isActive = "is_active"
    }
}

/// Represents a bank detail field configuration
public struct BankDetailField: Codable, Sendable, Equatable {
    /// Display label for the field
    public let label: String

    /// Regular expression pattern for validation
    public let regex: String

    /// Key identifier for this field
    public let key: BankDetailKey

    /// Optional array of predefined items/options for this field
    public let items: [BankDetailItem]?

    /// Whether this field is required
    public let required: Bool

    public init(
        label: String,
        regex: String,
        key: BankDetailKey,
        items: [BankDetailItem]? = nil,
        required: Bool
    ) {
        self.label = label
        self.regex = regex
        self.key = key
        self.items = items
        self.required = required
    }
}

/// Response type for bank details query
public typealias BankDetailResponse = [BankDetailField]

// MARK: - Swift Code Response

/// Represents bank details for a SWIFT code
public struct SwiftCodeResponse: Codable, Sendable, Equatable {
    /// Unique identifier for the bank
    public let id: String

    /// Bank name
    public let bank: String

    /// City where the bank is located
    public let city: String

    /// Branch name or identifier
    public let branch: String

    /// SWIFT/BIC code
    public let swiftCode: String

    /// Link to SWIFT code information
    public let swiftCodeLink: String

    /// Country code
    public let country: String

    /// Country slug identifier
    public let countrySlug: String

    /// Bank address
    public let address: String

    /// Postal code
    public let postcode: String

    public init(
        id: String,
        bank: String,
        city: String,
        branch: String,
        swiftCode: String,
        swiftCodeLink: String,
        country: String,
        countrySlug: String,
        address: String,
        postcode: String
    ) {
        self.id = id
        self.bank = bank
        self.city = city
        self.branch = branch
        self.swiftCode = swiftCode
        self.swiftCodeLink = swiftCodeLink
        self.country = country
        self.countrySlug = countrySlug
        self.address = address
        self.postcode = postcode
    }
}
