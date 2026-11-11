//
//  Available.swift
//  blindpay-swift
//
//  Created by Eric Viana on 30/10/25.
//

import Foundation

// MARK: - Enums

/// Payment rail type
public struct Rail: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let wire = Rail(rawValue: "wire")
    public static let ach = Rail(rawValue: "ach")
    public static let pix = Rail(rawValue: "pix")
    public static let pixSafe = Rail(rawValue: "pix_safe")
    public static let speiBitso = Rail(rawValue: "spei_bitso")
    public static let transfersBitso = Rail(rawValue: "transfers_bitso")
    public static let achCopBitso = Rail(rawValue: "ach_cop_bitso")
    public static let internationalSwift = Rail(rawValue: "international_swift")
    public static let rtp = Rail(rawValue: "rtp")
    public static let ted = Rail(rawValue: "ted")
    public static let sepa = Rail(rawValue: "sepa")
}

/// Bank account type
public struct BankAccountType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let checking = BankAccountType(rawValue: "checking")
    public static let savings = BankAccountType(rawValue: "saving")
}

/// Account class type
public struct AccountClass: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let individual = AccountClass(rawValue: "individual")
    public static let business = AccountClass(rawValue: "business")
}

/// Recipient relationship type
public struct RecipientRelationship: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let firstParty = RecipientRelationship(rawValue: "first_party")
    public static let employee = RecipientRelationship(rawValue: "employee")
    public static let independentContractor = RecipientRelationship(rawValue: "independent_contractor")
    public static let vendorOrSupplier = RecipientRelationship(rawValue: "vendor_or_supplier")
    public static let subsidiaryOrAffiliate = RecipientRelationship(rawValue: "subsidiary_or_affiliate")
    public static let merchantOrPartner = RecipientRelationship(rawValue: "merchant_or_partner")
    public static let customer = RecipientRelationship(rawValue: "customer")
    public static let landlord = RecipientRelationship(rawValue: "landlord")
    public static let family = RecipientRelationship(rawValue: "family")
    public static let other = RecipientRelationship(rawValue: "other")
}

/// Represents a NAICS business industry code (an `AvailableNaicsList` item)
public struct NaicsCode: Codable, Sendable, Equatable {
    /// Display label, e.g. `"(339910) Jewelry and Silverware Manufacturing"`
    public let label: String

    /// NAICS code, e.g. `"339910"`. Send this as `business_industry`.
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }
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
public struct BankDetailKey: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let type = BankDetailKey(rawValue: "type")
    public static let name = BankDetailKey(rawValue: "name")
    public static let pixKey = BankDetailKey(rawValue: "pix_key")
    public static let beneficiaryName = BankDetailKey(rawValue: "beneficiary_name")
    public static let routingNumber = BankDetailKey(rawValue: "routing_number")
    public static let accountNumber = BankDetailKey(rawValue: "account_number")
    public static let accountType = BankDetailKey(rawValue: "account_type")
    public static let accountClass = BankDetailKey(rawValue: "account_class")
    public static let addressLine1 = BankDetailKey(rawValue: "address_line_1")
    public static let addressLine2 = BankDetailKey(rawValue: "address_line_2")
    public static let city = BankDetailKey(rawValue: "city")
    public static let stateProvinceRegion = BankDetailKey(rawValue: "state_province_region")
    public static let country = BankDetailKey(rawValue: "country")
    public static let postalCode = BankDetailKey(rawValue: "postal_code")
    public static let checkbookAccountId = BankDetailKey(rawValue: "checkbook_account_id")
    public static let checkbookUserKey = BankDetailKey(rawValue: "checkbook_user_key")
    public static let speiProtocol = BankDetailKey(rawValue: "spei_protocol")
    public static let speiInstitutionCode = BankDetailKey(rawValue: "spei_institution_code")
    public static let speiClabe = BankDetailKey(rawValue: "spei_clabe")
    public static let transfersType = BankDetailKey(rawValue: "transfers_type")
    public static let transfersAccount = BankDetailKey(rawValue: "transfers_account")
    public static let achCopBeneficiaryFirstName = BankDetailKey(rawValue: "ach_cop_beneficiary_first_name")
    public static let achCopBeneficiaryLastName = BankDetailKey(rawValue: "ach_cop_beneficiary_last_name")
    public static let achCopDocumentId = BankDetailKey(rawValue: "ach_cop_document_id")
    public static let achCopDocumentType = BankDetailKey(rawValue: "ach_cop_document_type")
    public static let achCopEmail = BankDetailKey(rawValue: "ach_cop_email")
    public static let achCopBankCode = BankDetailKey(rawValue: "ach_cop_bank_code")
    public static let achCopBankAccount = BankDetailKey(rawValue: "ach_cop_bank_account")
    public static let swiftCodeBic = BankDetailKey(rawValue: "swift_code_bic")
    public static let swiftAccountHolderName = BankDetailKey(rawValue: "swift_account_holder_name")
    public static let swiftAccountNumberIban = BankDetailKey(rawValue: "swift_account_number_iban")
    public static let swiftBeneficiaryAddressLine1 = BankDetailKey(rawValue: "swift_beneficiary_address_line_1")
    public static let swiftBeneficiaryAddressLine2 = BankDetailKey(rawValue: "swift_beneficiary_address_line_2")
    public static let swiftBeneficiaryCountry = BankDetailKey(rawValue: "swift_beneficiary_country")
    public static let swiftBeneficiaryCity = BankDetailKey(rawValue: "swift_beneficiary_city")
    public static let swiftBeneficiaryStateProvinceRegion = BankDetailKey(rawValue: "swift_beneficiary_state_province_region")
    public static let swiftBeneficiaryPostalCode = BankDetailKey(rawValue: "swift_beneficiary_postal_code")
    public static let swiftBankName = BankDetailKey(rawValue: "swift_bank_name")
    public static let swiftBankAddressLine1 = BankDetailKey(rawValue: "swift_bank_address_line_1")
    public static let swiftBankAddressLine2 = BankDetailKey(rawValue: "swift_bank_address_line_2")
    public static let swiftBankCountry = BankDetailKey(rawValue: "swift_bank_country")
    public static let swiftBankCity = BankDetailKey(rawValue: "swift_bank_city")
    public static let swiftBankStateProvinceRegion = BankDetailKey(rawValue: "swift_bank_state_province_region")
    public static let swiftBankPostalCode = BankDetailKey(rawValue: "swift_bank_postal_code")
    public static let swiftIntermediaryBankSwiftCodeBic = BankDetailKey(rawValue: "swift_intermediary_bank_swift_code_bic")
    public static let swiftIntermediaryBankAccountNumberIban = BankDetailKey(rawValue: "swift_intermediary_bank_account_number_iban")
    public static let swiftIntermediaryBankName = BankDetailKey(rawValue: "swift_intermediary_bank_name")
    public static let swiftIntermediaryBankCountry = BankDetailKey(rawValue: "swift_intermediary_bank_country")
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
    public let required: Bool?

    public init(
        label: String,
        regex: String,
        key: BankDetailKey,
        items: [BankDetailItem]? = nil,
        required: Bool? = nil
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

    /// Bank address. Not in the API spec; usually absent.
    public let address: String?

    /// Postal code. Not in the API spec; usually absent.
    public let postcode: String?

    public init(
        id: String,
        bank: String,
        city: String,
        branch: String,
        swiftCode: String,
        swiftCodeLink: String,
        country: String,
        countrySlug: String,
        address: String? = nil,
        postcode: String? = nil
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
