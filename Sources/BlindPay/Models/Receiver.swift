//
//  Receiver.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - KYC Type

/// KYC verification type
public enum KYCType: String, Codable, Sendable {
    case light = "light"
    case standard = "standard"
    case enhanced = "enhanced"
}

// MARK: - Receiver Type

/// Type of receiver
public enum ReceiverType: String, Codable, Sendable {
    case individual = "individual"
    case business = "business"
}

// MARK: - ID Document Type

/// Type of ID document
public enum IDDocType: String, Codable, Sendable {
    case passport = "PASSPORT"
    case idCard = "ID_CARD"
    case drivers = "DRIVERS"
    case driversLicense = "DRIVERS_LICENSE"
    case nationalId = "NATIONAL_ID"
    case other = "OTHER"
}

// MARK: - Proof of Address Document Type

/// Type of proof of address document
public enum ProofOfAddressDocType: String, Codable, Sendable {
    case utilityBill = "UTILITY_BILL"
    case bankStatement = "BANK_STATEMENT"
    case rentalAgreement = "RENTAL_AGREEMENT"
    case taxDocument = "TAX_DOCUMENT"
    case governmentCorrespondence = "GOVERNMENT_CORRESPONDENCE"
    case governmentLetter = "GOVERNMENT_LETTER"
    case other = "OTHER"
}

// MARK: - Source of Funds Document Type

/// Type of source of funds document
public enum SourceOfFundsDocType: String, Codable, Sendable {
    case businessIncome = "business_income"
    case gamblingProceeds = "gambling_proceeds"
    case gifts = "gifts"
    case governmentBenefits = "government_benefits"
    case inheritance = "inheritance"
    case salary = "salary"
    case investment = "investment"
    case gift = "gift"
    case other = "other"
}

// MARK: - Purpose of Transactions

/// Purpose of transactions
public enum PurposeOfTransactions: String, Codable, Sendable {
    case businessTransactions = "business_transactions"
    case charitableDonations = "charitable_donations"
    case investmentPurposes = "investment_purposes"
    case paymentsToFriendsOrFamilyAbroad = "payments_to_friends_or_family_abroad"
    case personalOrLivingExpenses = "personal_or_living_expenses"
    case personalTransactions = "personal_transactions"
    case investment = "investment"
    case receiveSalary = "receive_salary"
    case other = "other"
}

// MARK: - Owner Role

/// Role of an owner
public enum OwnerRole: String, Codable, Sendable {
    case beneficialOwner = "beneficial_owner"
    case authorizedSigner = "authorized_signer"
    case other = "other"
}

// MARK: - Account Purpose

/// Account purpose
public enum AccountPurpose: String, Codable, Sendable {
    case charitableDonations = "charitable_donations"
    case ecommerceRetailPayments = "ecommerce_retail_payments"
    case investmentPurposes = "investment_purposes"
    case businessExpenses = "business_expenses"
    case paymentsToFriendsOrFamilyAbroad = "payments_to_friends_or_family_abroad"
    case personalOrLivingExpenses = "personal_or_living_expenses"
    case protectWealth = "protect_wealth"
    case purchaseGoodsAndServices = "purchase_goods_and_services"
    case receivePaymentsForGoodsAndServices = "receive_payments_for_goods_and_services"
    case taxOptimization = "tax_optimization"
    case thirdPartyMoneyTransmission = "third_party_money_transmission"
    case other = "other"
    case payroll = "payroll"
    case treasuryManagement = "treasury_management"
}

// MARK: - Business Type

/// Legal structure of a business
public enum ReceiverBusinessType: String, Codable, Sendable {
    case corporation = "corporation"
    case llc = "llc"
    case partnership = "partnership"
    case soleProprietorship = "sole_proprietorship"
    case trust = "trust"
    case nonProfit = "non_profit"
}

// MARK: - Business Industry

/// NAICS industry code
public enum BusinessIndustry: String, Codable, Sendable {
    case naics541511 = "541511"
    case naics541512 = "541512"
    case naics541519 = "541519"
    case naics518210 = "518210"
    case naics511210 = "511210"
    case naics541611 = "541611"
    case naics541618 = "541618"
    case naics541330 = "541330"
    case naics541990 = "541990"
    case naics522110 = "522110"
    case naics523110 = "523110"
    case naics523920 = "523920"
    case naics423430 = "423430"
    case naics423690 = "423690"
    case naics423110 = "423110"
    case naics423830 = "423830"
    case naics423840 = "423840"
    case naics423510 = "423510"
    case naics424210 = "424210"
    case naics424690 = "424690"
    case naics424990 = "424990"
    case naics454110 = "454110"
    case naics334111 = "334111"
    case naics334118 = "334118"
    case naics325412 = "325412"
    case naics339112 = "339112"
    case naics336111 = "336111"
    case naics336390 = "336390"
    case naics551112 = "551112"
    case naics561499 = "561499"
    case naics488510 = "488510"
    case naics484121 = "484121"
    case naics493110 = "493110"
    case naics424410 = "424410"
    case naics424480 = "424480"
    case naics315990 = "315990"
    case naics313110 = "313110"
    case naics213112 = "213112"
    case naics517110 = "517110"
    case naics541214 = "541214"
}

// MARK: - Estimated Annual Revenue

/// Estimated annual revenue range
public enum EstimatedAnnualRevenue: String, Codable, Sendable {
    case range0to99999 = "0_99999"
    case range100000to999999 = "100000_999999"
    case range1000000to9999999 = "1000000_9999999"
    case range10000000to49999999 = "10000000_49999999"
    case range50000000to249999999 = "50000000_249999999"
    case range2500000000Plus = "2500000000_plus"
}

// MARK: - Source of Wealth

/// Source of wealth
public enum SourceOfWealth: String, Codable, Sendable {
    case businessDividendsOrProfits = "business_dividends_or_profits"
    case investments = "investments"
    case assetSales = "asset_sales"
    case clientInvestorContributions = "client_investor_contributions"
    case gambling = "gambling"
    case charitableContributions = "charitable_contributions"
    case inheritance = "inheritance"
    case affiliateOrRoyaltyIncome = "affiliate_or_royalty_income"
}

// MARK: - Owner

/// Owner information for business receivers
public struct ReceiverOwner: Codable, Sendable, Equatable {
    /// Owner ID (for response)
    public let id: String?
    
    /// First name
    public let firstName: String
    
    /// Last name
    public let lastName: String
    
    /// Role of the owner (optional in response)
    public let role: OwnerRole?
    
    /// Date of birth (ISO 8601 format, optional in response)
    public let dateOfBirth: String?
    
    /// Tax ID (optional in response)
    public let taxId: String?
    
    /// Address line 1
    public let addressLine1: String
    
    /// Address line 2 (optional)
    public let addressLine2: String?
    
    /// City
    public let city: String
    
    /// State/province/region
    public let stateProvinceRegion: String
    
    /// Country code
    public let country: Country
    
    /// Postal code
    public let postalCode: String
    
    /// ID document country code
    public let idDocCountry: Country
    
    /// ID document type
    public let idDocType: IDDocType
    
    /// ID document front file URL
    public let idDocFrontFile: String
    
    /// ID document back file URL (optional)
    public let idDocBackFile: String?

    /// Proof of address document type (optional)
    public let proofOfAddressDocType: ProofOfAddressDocType?

    /// Proof of address document file URL (optional)
    public let proofOfAddressDocFile: String?

    /// Ownership percentage (optional)
    public let ownershipPercentage: Double?

    /// Title (optional)
    public let title: String?

    public init(
        id: String? = nil,
        firstName: String,
        lastName: String,
        role: OwnerRole? = nil,
        dateOfBirth: String? = nil,
        taxId: String? = nil,
        addressLine1: String,
        addressLine2: String? = nil,
        city: String,
        stateProvinceRegion: String,
        country: Country,
        postalCode: String,
        idDocCountry: Country,
        idDocType: IDDocType,
        idDocFrontFile: String,
        idDocBackFile: String? = nil,
        proofOfAddressDocType: ProofOfAddressDocType? = nil,
        proofOfAddressDocFile: String? = nil,
        ownershipPercentage: Double? = nil,
        title: String? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.dateOfBirth = dateOfBirth
        self.taxId = taxId
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.stateProvinceRegion = stateProvinceRegion
        self.country = country
        self.postalCode = postalCode
        self.idDocCountry = idDocCountry
        self.idDocType = idDocType
        self.idDocFrontFile = idDocFrontFile
        self.idDocBackFile = idDocBackFile
        self.proofOfAddressDocType = proofOfAddressDocType
        self.proofOfAddressDocFile = proofOfAddressDocFile
        self.ownershipPercentage = ownershipPercentage
        self.title = title
    }

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case role
        case dateOfBirth = "date_of_birth"
        case taxId = "tax_id"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case city
        case stateProvinceRegion = "state_province_region"
        case country
        case postalCode = "postal_code"
        case idDocCountry = "id_doc_country"
        case idDocType = "id_doc_type"
        case idDocFrontFile = "id_doc_front_file"
        case idDocBackFile = "id_doc_back_file"
        case proofOfAddressDocType = "proof_of_address_doc_type"
        case proofOfAddressDocFile = "proof_of_address_doc_file"
        case ownershipPercentage = "ownership_percentage"
        case title
    }
}

// MARK: - Create Receiver Input

/// Input for creating a receiver
public struct CreateReceiverInput: Codable, Sendable {
    /// Country code
    public let country: Country
    
    /// Email address
    public let email: String
    
    /// KYC type
    public let kycType: KYCType
    
    /// Receiver type
    public let type: ReceiverType
    
    /// Address line 1 (optional)
    public let addressLine1: String?
    
    /// Address line 2 (optional)
    public let addressLine2: String?
    
    /// Alternate name (optional)
    public let alternateName: String?
    
    /// City (optional)
    public let city: String?
    
    /// Date of birth (optional, ISO 8601 format)
    public let dateOfBirth: String?
    
    /// External ID (optional)
    public let externalId: String?
    
    /// First name (optional)
    public let firstName: String?
    
    /// Formation date (optional, ISO 8601 format)
    public let formationDate: String?
    
    /// Last name (optional)
    public let lastName: String?
    
    /// Legal name (optional)
    public let legalName: String?
    
    /// State/province/region (optional)
    public let stateProvinceRegion: String?
    
    /// Postal code (optional)
    public let postalCode: String?
    
    /// Tax ID (optional)
    public let taxId: String?
    
    /// IP address (optional)
    public let ipAddress: String?
    
    /// Image URL (optional)
    public let imageUrl: String?
    
    /// Phone number (optional)
    public let phoneNumber: String?
    
    /// Proof of address document type (optional)
    public let proofOfAddressDocType: ProofOfAddressDocType?
    
    /// Proof of address document file URL (optional)
    public let proofOfAddressDocFile: String?
    
    /// ID document country (optional)
    public let idDocCountry: Country?
    
    /// ID document type (optional)
    public let idDocType: IDDocType?
    
    /// ID document front file URL (optional)
    public let idDocFrontFile: String?
    
    /// ID document back file URL (optional)
    public let idDocBackFile: String?
    
    /// Website (optional)
    public let website: String?
    
    /// Owners (optional, for business receivers)
    public let owners: [ReceiverOwner]?
    
    /// Incorporation document file URL (optional)
    public let incorporationDocFile: String?
    
    /// Proof of ownership document file URL (optional)
    public let proofOfOwnershipDocFile: String?
    
    /// Source of funds document type (optional)
    public let sourceOfFundsDocType: SourceOfFundsDocType?
    
    /// Source of funds document file URL (optional)
    public let sourceOfFundsDocFile: String?
    
    /// Selfie file URL (optional)
    public let selfieFile: String?
    
    /// Purpose of transactions (optional)
    public let purposeOfTransactions: PurposeOfTransactions?
    
    /// Purpose of transactions explanation (optional)
    public let purposeOfTransactionsExplanation: String?
    
    /// Whether this is an FBO account (optional)
    public let isFbo: Bool?
    
    /// Terms of service ID (optional)
    public let tosId: String?

    /// Account purpose (optional)
    public let accountPurpose: AccountPurpose?

    /// Business description (optional)
    public let businessDescription: String?

    /// Business industry (optional)
    public let businessIndustry: BusinessIndustry?

    /// Business type (optional)
    public let businessType: ReceiverBusinessType?

    /// Estimated annual revenue (optional)
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Publicly traded (optional)
    public let publiclyTraded: Bool?

    /// Source of wealth (optional)
    public let sourceOfWealth: SourceOfWealth?

    public init(
        country: Country,
        email: String,
        kycType: KYCType,
        type: ReceiverType,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        alternateName: String? = nil,
        city: String? = nil,
        dateOfBirth: String? = nil,
        externalId: String? = nil,
        firstName: String? = nil,
        formationDate: String? = nil,
        lastName: String? = nil,
        legalName: String? = nil,
        stateProvinceRegion: String? = nil,
        postalCode: String? = nil,
        taxId: String? = nil,
        ipAddress: String? = nil,
        imageUrl: String? = nil,
        phoneNumber: String? = nil,
        proofOfAddressDocType: ProofOfAddressDocType? = nil,
        proofOfAddressDocFile: String? = nil,
        idDocCountry: Country? = nil,
        idDocType: IDDocType? = nil,
        idDocFrontFile: String? = nil,
        idDocBackFile: String? = nil,
        website: String? = nil,
        owners: [ReceiverOwner]? = nil,
        incorporationDocFile: String? = nil,
        proofOfOwnershipDocFile: String? = nil,
        sourceOfFundsDocType: SourceOfFundsDocType? = nil,
        sourceOfFundsDocFile: String? = nil,
        selfieFile: String? = nil,
        purposeOfTransactions: PurposeOfTransactions? = nil,
        purposeOfTransactionsExplanation: String? = nil,
        isFbo: Bool? = nil,
        tosId: String? = nil,
        accountPurpose: AccountPurpose? = nil,
        businessDescription: String? = nil,
        businessIndustry: BusinessIndustry? = nil,
        businessType: ReceiverBusinessType? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        publiclyTraded: Bool? = nil,
        sourceOfWealth: SourceOfWealth? = nil
    ) {
        self.country = country
        self.email = email
        self.kycType = kycType
        self.type = type
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.alternateName = alternateName
        self.city = city
        self.dateOfBirth = dateOfBirth
        self.externalId = externalId
        self.firstName = firstName
        self.formationDate = formationDate
        self.lastName = lastName
        self.legalName = legalName
        self.stateProvinceRegion = stateProvinceRegion
        self.postalCode = postalCode
        self.taxId = taxId
        self.ipAddress = ipAddress
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
        self.proofOfAddressDocType = proofOfAddressDocType
        self.proofOfAddressDocFile = proofOfAddressDocFile
        self.idDocCountry = idDocCountry
        self.idDocType = idDocType
        self.idDocFrontFile = idDocFrontFile
        self.idDocBackFile = idDocBackFile
        self.website = website
        self.owners = owners
        self.incorporationDocFile = incorporationDocFile
        self.proofOfOwnershipDocFile = proofOfOwnershipDocFile
        self.sourceOfFundsDocType = sourceOfFundsDocType
        self.sourceOfFundsDocFile = sourceOfFundsDocFile
        self.selfieFile = selfieFile
        self.purposeOfTransactions = purposeOfTransactions
        self.purposeOfTransactionsExplanation = purposeOfTransactionsExplanation
        self.isFbo = isFbo
        self.tosId = tosId
        self.accountPurpose = accountPurpose
        self.businessDescription = businessDescription
        self.businessIndustry = businessIndustry
        self.businessType = businessType
        self.estimatedAnnualRevenue = estimatedAnnualRevenue
        self.publiclyTraded = publiclyTraded
        self.sourceOfWealth = sourceOfWealth
    }

    enum CodingKeys: String, CodingKey {
        case country
        case email
        case kycType = "kyc_type"
        case type
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case alternateName = "alternate_name"
        case city
        case dateOfBirth = "date_of_birth"
        case externalId = "external_id"
        case firstName = "first_name"
        case formationDate = "formation_date"
        case lastName = "last_name"
        case legalName = "legal_name"
        case stateProvinceRegion = "state_province_region"
        case postalCode = "postal_code"
        case taxId = "tax_id"
        case ipAddress = "ip_address"
        case imageUrl = "image_url"
        case phoneNumber = "phone_number"
        case proofOfAddressDocType = "proof_of_address_doc_type"
        case proofOfAddressDocFile = "proof_of_address_doc_file"
        case idDocCountry = "id_doc_country"
        case idDocType = "id_doc_type"
        case idDocFrontFile = "id_doc_front_file"
        case idDocBackFile = "id_doc_back_file"
        case website
        case owners
        case incorporationDocFile = "incorporation_doc_file"
        case proofOfOwnershipDocFile = "proof_of_ownership_doc_file"
        case sourceOfFundsDocType = "source_of_funds_doc_type"
        case sourceOfFundsDocFile = "source_of_funds_doc_file"
        case selfieFile = "selfie_file"
        case purposeOfTransactions = "purpose_of_transactions"
        case purposeOfTransactionsExplanation = "purpose_of_transactions_explanation"
        case isFbo = "is_fbo"
        case tosId = "tos_id"
        case accountPurpose = "account_purpose"
        case businessDescription = "business_description"
        case businessIndustry = "business_industry"
        case businessType = "business_type"
        case estimatedAnnualRevenue = "estimated_annual_revenue"
        case publiclyTraded = "publicly_traded"
        case sourceOfWealth = "source_of_wealth"
    }
}

// MARK: - KYC Status

/// KYC verification status
public enum KYCStatus: String, Codable, Sendable {
    case verifying = "verifying"
    case approved = "approved"
    case rejected = "rejected"
    case pending = "pending"
}

// MARK: - KYC Warning

/// KYC warning information
public struct KYCWarning: Codable, Sendable, Equatable {
    /// Warning code
    public let code: String
    
    /// Warning message
    public let message: String
    
    /// Resolution status
    public let resolutionStatus: String
    
    /// Warning ID
    public let warningId: String
    
    public init(code: String, message: String, resolutionStatus: String, warningId: String) {
        self.code = code
        self.message = message
        self.resolutionStatus = resolutionStatus
        self.warningId = warningId
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case resolutionStatus = "resolution_status"
        case warningId = "warning_id"
    }
}

// MARK: - Fraud Warning

/// Fraud warning information
public struct FraudWarning: Codable, Sendable, Equatable {
    /// Warning ID
    public let id: String
    
    /// Warning name
    public let name: String
    
    /// Operation type
    public let operation: String
    
    /// Score
    public let score: Int
    
    public init(id: String, name: String, operation: String, score: Int) {
        self.id = id
        self.name = name
        self.operation = operation
        self.score = score
    }
}

// MARK: - Receiver Limits

/// Receiver transaction limits
public struct ReceiverLimits: Codable, Sendable, Equatable {
    /// Per transaction limit
    public let perTransaction: Int
    
    /// Daily limit
    public let daily: Int
    
    /// Monthly limit
    public let monthly: Int
    
    public init(perTransaction: Int, daily: Int, monthly: Int) {
        self.perTransaction = perTransaction
        self.daily = daily
        self.monthly = monthly
    }
    
    enum CodingKeys: String, CodingKey {
        case perTransaction = "per_transaction"
        case daily
        case monthly
    }
}

// MARK: - Receiver (Full Model)

/// Full receiver model with all fields from API responses
public struct Receiver: Codable, Sendable, Equatable {
    /// Unique identifier
    public let id: String
    
    /// Receiver type
    public let type: ReceiverType
    
    /// KYC type
    public let kycType: KYCType
    
    /// KYC status
    public let kycStatus: KYCStatus?
    
    /// KYC warnings
    public let kycWarnings: [KYCWarning]?
    
    /// Fraud warnings
    public let fraudWarnings: [FraudWarning]?
    
    /// Email address
    public let email: String
    
    /// Tax ID
    public let taxId: String?
    
    /// Address line 1
    public let addressLine1: String?
    
    /// Address line 2
    public let addressLine2: String?
    
    /// City
    public let city: String?
    
    /// State/province/region
    public let stateProvinceRegion: String?
    
    /// Country code
    public let country: Country
    
    /// Postal code
    public let postalCode: String?
    
    /// IP address
    public let ipAddress: String?
    
    /// Image URL
    public let imageUrl: String?
    
    /// Phone number
    public let phoneNumber: String?
    
    /// Proof of address document type
    public let proofOfAddressDocType: ProofOfAddressDocType?
    
    /// Proof of address document file URL
    public let proofOfAddressDocFile: String?
    
    /// First name
    public let firstName: String?
    
    /// Last name
    public let lastName: String?
    
    /// Date of birth
    public let dateOfBirth: String?
    
    /// ID document country
    public let idDocCountry: Country?
    
    /// ID document type
    public let idDocType: IDDocType?
    
    /// ID document front file URL
    public let idDocFrontFile: String?
    
    /// ID document back file URL
    public let idDocBackFile: String?
    
    /// Legal name (for business)
    public let legalName: String?
    
    /// Alternate name (for business)
    public let alternateName: String?
    
    /// Formation date (for business)
    public let formationDate: String?
    
    /// Website (for business)
    public let website: String?
    
    /// Owners (for business)
    public let owners: [ReceiverOwner]?
    
    /// Incorporation document file URL
    public let incorporationDocFile: String?
    
    /// Proof of ownership document file URL
    public let proofOfOwnershipDocFile: String?
    
    /// Source of funds document type
    public let sourceOfFundsDocType: SourceOfFundsDocType?
    
    /// Source of funds document file URL
    public let sourceOfFundsDocFile: String?
    
    /// Selfie file URL
    public let selfieFile: String?
    
    /// Purpose of transactions
    public let purposeOfTransactions: PurposeOfTransactions?
    
    /// Purpose of transactions explanation
    public let purposeOfTransactionsExplanation: String?
    
    /// Whether this is an FBO account
    public let isFbo: Bool?
    
    /// External ID
    public let externalId: String?
    
    /// Instance ID
    public let instanceId: String
    
    /// Terms of service ID
    public let tosId: String?
    
    /// Aiprise validation key
    public let aipriseValidationKey: String?
    
    /// Created at timestamp
    public let createdAt: String
    
    /// Updated at timestamp
    public let updatedAt: String
    
    /// Transaction limits
    public let limit: ReceiverLimits?
    
    /// Whether TOS is accepted
    public let isTosAccepted: Bool?

    /// Account purpose
    public let accountPurpose: AccountPurpose?

    /// Business description
    public let businessDescription: String?

    /// Business industry
    public let businessIndustry: BusinessIndustry?

    /// Business type
    public let businessType: ReceiverBusinessType?

    /// Estimated annual revenue
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Publicly traded
    public let publiclyTraded: Bool?

    /// Source of wealth
    public let sourceOfWealth: SourceOfWealth?

    public init(
        id: String,
        type: ReceiverType,
        kycType: KYCType,
        kycStatus: KYCStatus? = nil,
        kycWarnings: [KYCWarning]? = nil,
        fraudWarnings: [FraudWarning]? = nil,
        email: String,
        taxId: String? = nil,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        city: String? = nil,
        stateProvinceRegion: String? = nil,
        country: Country,
        postalCode: String? = nil,
        ipAddress: String? = nil,
        imageUrl: String? = nil,
        phoneNumber: String? = nil,
        proofOfAddressDocType: ProofOfAddressDocType? = nil,
        proofOfAddressDocFile: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        dateOfBirth: String? = nil,
        idDocCountry: Country? = nil,
        idDocType: IDDocType? = nil,
        idDocFrontFile: String? = nil,
        idDocBackFile: String? = nil,
        legalName: String? = nil,
        alternateName: String? = nil,
        formationDate: String? = nil,
        website: String? = nil,
        owners: [ReceiverOwner]? = nil,
        incorporationDocFile: String? = nil,
        proofOfOwnershipDocFile: String? = nil,
        sourceOfFundsDocType: SourceOfFundsDocType? = nil,
        sourceOfFundsDocFile: String? = nil,
        selfieFile: String? = nil,
        purposeOfTransactions: PurposeOfTransactions? = nil,
        purposeOfTransactionsExplanation: String? = nil,
        isFbo: Bool? = nil,
        externalId: String? = nil,
        instanceId: String,
        tosId: String? = nil,
        aipriseValidationKey: String? = nil,
        createdAt: String,
        updatedAt: String,
        limit: ReceiverLimits? = nil,
        isTosAccepted: Bool? = nil,
        accountPurpose: AccountPurpose? = nil,
        businessDescription: String? = nil,
        businessIndustry: BusinessIndustry? = nil,
        businessType: ReceiverBusinessType? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        publiclyTraded: Bool? = nil,
        sourceOfWealth: SourceOfWealth? = nil
    ) {
        self.id = id
        self.type = type
        self.kycType = kycType
        self.kycStatus = kycStatus
        self.kycWarnings = kycWarnings
        self.fraudWarnings = fraudWarnings
        self.email = email
        self.taxId = taxId
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.stateProvinceRegion = stateProvinceRegion
        self.country = country
        self.postalCode = postalCode
        self.ipAddress = ipAddress
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
        self.proofOfAddressDocType = proofOfAddressDocType
        self.proofOfAddressDocFile = proofOfAddressDocFile
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.idDocCountry = idDocCountry
        self.idDocType = idDocType
        self.idDocFrontFile = idDocFrontFile
        self.idDocBackFile = idDocBackFile
        self.legalName = legalName
        self.alternateName = alternateName
        self.formationDate = formationDate
        self.website = website
        self.owners = owners
        self.incorporationDocFile = incorporationDocFile
        self.proofOfOwnershipDocFile = proofOfOwnershipDocFile
        self.sourceOfFundsDocType = sourceOfFundsDocType
        self.sourceOfFundsDocFile = sourceOfFundsDocFile
        self.selfieFile = selfieFile
        self.purposeOfTransactions = purposeOfTransactions
        self.purposeOfTransactionsExplanation = purposeOfTransactionsExplanation
        self.isFbo = isFbo
        self.externalId = externalId
        self.instanceId = instanceId
        self.tosId = tosId
        self.aipriseValidationKey = aipriseValidationKey
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.limit = limit
        self.isTosAccepted = isTosAccepted
        self.accountPurpose = accountPurpose
        self.businessDescription = businessDescription
        self.businessIndustry = businessIndustry
        self.businessType = businessType
        self.estimatedAnnualRevenue = estimatedAnnualRevenue
        self.publiclyTraded = publiclyTraded
        self.sourceOfWealth = sourceOfWealth
    }

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case kycType = "kyc_type"
        case kycStatus = "kyc_status"
        case kycWarnings = "kyc_warnings"
        case fraudWarnings = "fraud_warnings"
        case email
        case taxId = "tax_id"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case city
        case stateProvinceRegion = "state_province_region"
        case country
        case postalCode = "postal_code"
        case ipAddress = "ip_address"
        case imageUrl = "image_url"
        case phoneNumber = "phone_number"
        case proofOfAddressDocType = "proof_of_address_doc_type"
        case proofOfAddressDocFile = "proof_of_address_doc_file"
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case idDocCountry = "id_doc_country"
        case idDocType = "id_doc_type"
        case idDocFrontFile = "id_doc_front_file"
        case idDocBackFile = "id_doc_back_file"
        case legalName = "legal_name"
        case alternateName = "alternate_name"
        case formationDate = "formation_date"
        case website
        case owners
        case incorporationDocFile = "incorporation_doc_file"
        case proofOfOwnershipDocFile = "proof_of_ownership_doc_file"
        case sourceOfFundsDocType = "source_of_funds_doc_type"
        case sourceOfFundsDocFile = "source_of_funds_doc_file"
        case selfieFile = "selfie_file"
        case purposeOfTransactions = "purpose_of_transactions"
        case purposeOfTransactionsExplanation = "purpose_of_transactions_explanation"
        case isFbo = "is_fbo"
        case externalId = "external_id"
        case instanceId = "instance_id"
        case tosId = "tos_id"
        case aipriseValidationKey = "aiprise_validation_key"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case limit
        case isTosAccepted = "is_tos_accepted"
        case accountPurpose = "account_purpose"
        case businessDescription = "business_description"
        case businessIndustry = "business_industry"
        case businessType = "business_type"
        case estimatedAnnualRevenue = "estimated_annual_revenue"
        case publiclyTraded = "publicly_traded"
        case sourceOfWealth = "source_of_wealth"
    }
}

// MARK: - Update Receiver Input

/// Input for updating a receiver
public struct UpdateReceiverInput: Codable, Sendable {
    /// Country code (optional)
    public let country: Country?

    /// Email address (optional)
    public let email: String?
    
    /// Address line 1 (optional)
    public let addressLine1: String?
    
    /// Address line 2 (optional)
    public let addressLine2: String?
    
    /// Alternate name (optional)
    public let alternateName: String?
    
    /// City (optional)
    public let city: String?
    
    /// Date of birth (optional, ISO 8601 format)
    public let dateOfBirth: String?
    
    /// External ID (optional)
    public let externalId: String?
    
    /// First name (optional)
    public let firstName: String?
    
    /// Formation date (optional, ISO 8601 format)
    public let formationDate: String?
    
    /// ID document back file URL (optional)
    public let idDocBackFile: String?
    
    /// ID document country (optional)
    public let idDocCountry: Country?
    
    /// ID document front file URL (optional)
    public let idDocFrontFile: String?
    
    /// ID document type (optional)
    public let idDocType: IDDocType?
    
    /// Image URL (optional)
    public let imageUrl: String?
    
    /// Incorporation document file URL (optional)
    public let incorporationDocFile: String?
    
    /// IP address (optional)
    public let ipAddress: String?

    /// Last name (optional)
    public let lastName: String?
    
    /// Legal name (optional)
    public let legalName: String?
    
    /// Owners (optional, for business receivers)
    public let owners: [ReceiverOwner]?
    
    /// Phone number (optional)
    public let phoneNumber: String?
    
    /// Postal code (optional)
    public let postalCode: String?
    
    /// Proof of address document file URL (optional)
    public let proofOfAddressDocFile: String?
    
    /// Proof of address document type (optional)
    public let proofOfAddressDocType: ProofOfAddressDocType?
    
    /// Proof of ownership document file URL (optional)
    public let proofOfOwnershipDocFile: String?
    
    /// Purpose of transactions (optional)
    public let purposeOfTransactions: PurposeOfTransactions?
    
    /// Purpose of transactions explanation (optional)
    public let purposeOfTransactionsExplanation: String?
    
    /// Selfie file URL (optional)
    public let selfieFile: String?
    
    /// Source of funds document file URL (optional)
    public let sourceOfFundsDocFile: String?
    
    /// Source of funds document type (optional)
    public let sourceOfFundsDocType: SourceOfFundsDocType?
    
    /// State/province/region (optional)
    public let stateProvinceRegion: String?
    
    /// Tax ID (optional)
    public let taxId: String?
    
    /// Terms of service ID (optional)
    public let tosId: String?
    
    /// Website (optional)
    public let website: String?

    /// Account purpose (optional)
    public let accountPurpose: AccountPurpose?

    /// Business description (optional)
    public let businessDescription: String?

    /// Business industry (optional)
    public let businessIndustry: BusinessIndustry?

    /// Business type (optional)
    public let businessType: ReceiverBusinessType?

    /// Estimated annual revenue (optional)
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Publicly traded (optional)
    public let publiclyTraded: Bool?

    /// Source of wealth (optional)
    public let sourceOfWealth: SourceOfWealth?

    public init(
        country: Country? = nil,
        email: String? = nil,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        alternateName: String? = nil,
        city: String? = nil,
        dateOfBirth: String? = nil,
        externalId: String? = nil,
        firstName: String? = nil,
        formationDate: String? = nil,
        idDocBackFile: String? = nil,
        idDocCountry: Country? = nil,
        idDocFrontFile: String? = nil,
        idDocType: IDDocType? = nil,
        imageUrl: String? = nil,
        incorporationDocFile: String? = nil,
        ipAddress: String? = nil,
        lastName: String? = nil,
        legalName: String? = nil,
        owners: [ReceiverOwner]? = nil,
        phoneNumber: String? = nil,
        postalCode: String? = nil,
        proofOfAddressDocFile: String? = nil,
        proofOfAddressDocType: ProofOfAddressDocType? = nil,
        proofOfOwnershipDocFile: String? = nil,
        purposeOfTransactions: PurposeOfTransactions? = nil,
        purposeOfTransactionsExplanation: String? = nil,
        selfieFile: String? = nil,
        sourceOfFundsDocFile: String? = nil,
        sourceOfFundsDocType: SourceOfFundsDocType? = nil,
        stateProvinceRegion: String? = nil,
        taxId: String? = nil,
        tosId: String? = nil,
        website: String? = nil,
        accountPurpose: AccountPurpose? = nil,
        businessDescription: String? = nil,
        businessIndustry: BusinessIndustry? = nil,
        businessType: ReceiverBusinessType? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        publiclyTraded: Bool? = nil,
        sourceOfWealth: SourceOfWealth? = nil
    ) {
        self.country = country
        self.email = email
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.alternateName = alternateName
        self.city = city
        self.dateOfBirth = dateOfBirth
        self.externalId = externalId
        self.firstName = firstName
        self.formationDate = formationDate
        self.idDocBackFile = idDocBackFile
        self.idDocCountry = idDocCountry
        self.idDocFrontFile = idDocFrontFile
        self.idDocType = idDocType
        self.imageUrl = imageUrl
        self.incorporationDocFile = incorporationDocFile
        self.ipAddress = ipAddress
        self.lastName = lastName
        self.legalName = legalName
        self.owners = owners
        self.phoneNumber = phoneNumber
        self.postalCode = postalCode
        self.proofOfAddressDocFile = proofOfAddressDocFile
        self.proofOfAddressDocType = proofOfAddressDocType
        self.proofOfOwnershipDocFile = proofOfOwnershipDocFile
        self.purposeOfTransactions = purposeOfTransactions
        self.purposeOfTransactionsExplanation = purposeOfTransactionsExplanation
        self.selfieFile = selfieFile
        self.sourceOfFundsDocFile = sourceOfFundsDocFile
        self.sourceOfFundsDocType = sourceOfFundsDocType
        self.stateProvinceRegion = stateProvinceRegion
        self.taxId = taxId
        self.tosId = tosId
        self.website = website
        self.accountPurpose = accountPurpose
        self.businessDescription = businessDescription
        self.businessIndustry = businessIndustry
        self.businessType = businessType
        self.estimatedAnnualRevenue = estimatedAnnualRevenue
        self.publiclyTraded = publiclyTraded
        self.sourceOfWealth = sourceOfWealth
    }

    enum CodingKeys: String, CodingKey {
        case country
        case email
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case alternateName = "alternate_name"
        case city
        case dateOfBirth = "date_of_birth"
        case externalId = "external_id"
        case firstName = "first_name"
        case formationDate = "formation_date"
        case idDocBackFile = "id_doc_back_file"
        case idDocCountry = "id_doc_country"
        case idDocFrontFile = "id_doc_front_file"
        case idDocType = "id_doc_type"
        case imageUrl = "image_url"
        case incorporationDocFile = "incorporation_doc_file"
        case ipAddress = "ip_address"
        case lastName = "last_name"
        case legalName = "legal_name"
        case owners
        case phoneNumber = "phone_number"
        case postalCode = "postal_code"
        case proofOfAddressDocFile = "proof_of_address_doc_file"
        case proofOfAddressDocType = "proof_of_address_doc_type"
        case proofOfOwnershipDocFile = "proof_of_ownership_doc_file"
        case purposeOfTransactions = "purpose_of_transactions"
        case purposeOfTransactionsExplanation = "purpose_of_transactions_explanation"
        case selfieFile = "selfie_file"
        case sourceOfFundsDocFile = "source_of_funds_doc_file"
        case sourceOfFundsDocType = "source_of_funds_doc_type"
        case stateProvinceRegion = "state_province_region"
        case taxId = "tax_id"
        case tosId = "tos_id"
        case website
        case accountPurpose = "account_purpose"
        case businessDescription = "business_description"
        case businessIndustry = "business_industry"
        case businessType = "business_type"
        case estimatedAnnualRevenue = "estimated_annual_revenue"
        case publiclyTraded = "publicly_traded"
        case sourceOfWealth = "source_of_wealth"
    }
}

// MARK: - Response Types

/// Response type for creating a receiver
public struct CreateReceiverResponse: Codable, Sendable, Equatable {
    /// Unique identifier for the created receiver
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

/// Response type for updating a receiver
public struct UpdateReceiverResponse: Codable, Sendable, Equatable {
    /// Whether the update was successful
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}

/// Response type for deleting a receiver
public struct DeleteReceiverResponse: Codable, Sendable, Equatable {
    /// Whether the deletion was successful
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}

/// Pagination information
public struct Pagination: Codable, Sendable, Equatable {
    /// Whether there are more items
    public let hasMore: Bool
    
    /// Next page cursor
    public let nextPage: String?
    
    /// Previous page cursor
    public let prevPage: String?
    
    public init(hasMore: Bool, nextPage: String? = nil, prevPage: String? = nil) {
        self.hasMore = hasMore
        self.nextPage = nextPage
        self.prevPage = prevPage
    }
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case nextPage = "next_page"
        case prevPage = "prev_page"
    }
}

/// Response type for listing receivers
public struct ListReceiversResponse: Codable, Sendable, Equatable {
    /// Array of receivers
    public let data: [Receiver]
    
    /// Pagination information
    public let pagination: Pagination
    
    public init(data: [Receiver], pagination: Pagination) {
        self.data = data
        self.pagination = pagination
    }
}

