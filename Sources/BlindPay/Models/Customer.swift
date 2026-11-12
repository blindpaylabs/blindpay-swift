//
//  Customer.swift
//  blindpay-swift
//
//  Created by Eric Viana on 05/11/25.
//

import Foundation

// MARK: - KYC Type

/// KYC verification type
public struct KYCType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let light = KYCType(rawValue: "light")
    public static let standard = KYCType(rawValue: "standard")
    public static let enhanced = KYCType(rawValue: "enhanced")
}

// MARK: - Customer Type

/// Type of customer
public struct CustomerType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let individual = CustomerType(rawValue: "individual")
    public static let business = CustomerType(rawValue: "business")
}

// MARK: - ID Document Type

/// Type of ID document
public struct IDDocType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let passport = IDDocType(rawValue: "PASSPORT")
    public static let idCard = IDDocType(rawValue: "ID_CARD")
    public static let drivers = IDDocType(rawValue: "DRIVERS")
    public static let driversLicense = IDDocType(rawValue: "DRIVERS_LICENSE")
    public static let nationalId = IDDocType(rawValue: "NATIONAL_ID")
    public static let other = IDDocType(rawValue: "OTHER")
}

// MARK: - Proof of Address Document Type

/// Type of proof of address document
public struct ProofOfAddressDocType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let utilityBill = ProofOfAddressDocType(rawValue: "UTILITY_BILL")
    public static let bankStatement = ProofOfAddressDocType(rawValue: "BANK_STATEMENT")
    public static let rentalAgreement = ProofOfAddressDocType(rawValue: "RENTAL_AGREEMENT")
    public static let taxDocument = ProofOfAddressDocType(rawValue: "TAX_DOCUMENT")
    public static let governmentCorrespondence = ProofOfAddressDocType(rawValue: "GOVERNMENT_CORRESPONDENCE")
    public static let governmentLetter = ProofOfAddressDocType(rawValue: "GOVERNMENT_LETTER")
    public static let other = ProofOfAddressDocType(rawValue: "OTHER")
}

// MARK: - Sole Proprietor Document Type

/// Type of sole proprietor document
public struct SoleProprietorDocType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let bankStatement = SoleProprietorDocType(rawValue: "bank_statement")
    public static let masterServiceAgreement = SoleProprietorDocType(rawValue: "master_service_agreement")
    public static let salarySlip = SoleProprietorDocType(rawValue: "salary_slip")
}

// MARK: - Source of Funds Document Type

/// Type of source of funds document
public struct SourceOfFundsDocType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let businessIncome = SourceOfFundsDocType(rawValue: "business_income")
    public static let gamblingProceeds = SourceOfFundsDocType(rawValue: "gambling_proceeds")
    public static let gifts = SourceOfFundsDocType(rawValue: "gifts")
    public static let governmentBenefits = SourceOfFundsDocType(rawValue: "government_benefits")
    public static let inheritance = SourceOfFundsDocType(rawValue: "inheritance")
    public static let salary = SourceOfFundsDocType(rawValue: "salary")
    public static let investment = SourceOfFundsDocType(rawValue: "investment")
    public static let gift = SourceOfFundsDocType(rawValue: "gift")
    public static let other = SourceOfFundsDocType(rawValue: "other")
    public static let investmentLoans = SourceOfFundsDocType(rawValue: "investment_loans")
    public static let pensionRetirement = SourceOfFundsDocType(rawValue: "pension_retirement")
    public static let saleOfAssetsRealEstate = SourceOfFundsDocType(rawValue: "sale_of_assets_real_estate")
    public static let savings = SourceOfFundsDocType(rawValue: "savings")
    public static let esops = SourceOfFundsDocType(rawValue: "esops")
    public static let investmentProceeds = SourceOfFundsDocType(rawValue: "investment_proceeds")
    public static let someoneElseFunds = SourceOfFundsDocType(rawValue: "someone_else_funds")
}

// MARK: - Purpose of Transactions

/// Purpose of transactions
public struct PurposeOfTransactions: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let businessTransactions = PurposeOfTransactions(rawValue: "business_transactions")
    public static let charitableDonations = PurposeOfTransactions(rawValue: "charitable_donations")
    public static let investmentPurposes = PurposeOfTransactions(rawValue: "investment_purposes")
    public static let paymentsToFriendsOrFamilyAbroad = PurposeOfTransactions(rawValue: "payments_to_friends_or_family_abroad")
    public static let personalOrLivingExpenses = PurposeOfTransactions(rawValue: "personal_or_living_expenses")
    public static let personalTransactions = PurposeOfTransactions(rawValue: "personal_transactions")
    public static let investment = PurposeOfTransactions(rawValue: "investment")
    public static let other = PurposeOfTransactions(rawValue: "other")
    public static let protectWealth = PurposeOfTransactions(rawValue: "protect_wealth")
    public static let purchaseGoodAndServices = PurposeOfTransactions(rawValue: "purchase_good_and_services")
    public static let receivePaymentForFreelancing = PurposeOfTransactions(rawValue: "receive_payment_for_freelancing")
    public static let receiveSalary = PurposeOfTransactions(rawValue: "receive_salary")
}

// MARK: - Account Purpose

/// Purpose of the account
public struct AccountPurpose: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let charitableDonations = AccountPurpose(rawValue: "charitable_donations")
    public static let ecommerceRetailPayments = AccountPurpose(rawValue: "ecommerce_retail_payments")
    public static let investmentPurposes = AccountPurpose(rawValue: "investment_purposes")
    public static let businessExpenses = AccountPurpose(rawValue: "business_expenses")
    public static let paymentsToFriendsOrFamilyAbroad = AccountPurpose(rawValue: "payments_to_friends_or_family_abroad")
    public static let personalOrLivingExpenses = AccountPurpose(rawValue: "personal_or_living_expenses")
    public static let protectWealth = AccountPurpose(rawValue: "protect_wealth")
    public static let purchaseGoodsAndServices = AccountPurpose(rawValue: "purchase_goods_and_services")
    public static let receivePaymentsForGoodsAndServices = AccountPurpose(rawValue: "receive_payments_for_goods_and_services")
    public static let taxOptimization = AccountPurpose(rawValue: "tax_optimization")
    public static let thirdPartyMoneyTransmission = AccountPurpose(rawValue: "third_party_money_transmission")
    public static let payroll = AccountPurpose(rawValue: "payroll")
    public static let treasuryManagement = AccountPurpose(rawValue: "treasury_management")
    public static let other = AccountPurpose(rawValue: "other")
}

// MARK: - Business Type

/// Type of business entity
public struct BusinessType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let corporation = BusinessType(rawValue: "corporation")
    public static let llc = BusinessType(rawValue: "llc")
    public static let partnership = BusinessType(rawValue: "partnership")
    public static let soleProprietorship = BusinessType(rawValue: "sole_proprietorship")
    public static let trust = BusinessType(rawValue: "trust")
    public static let nonProfit = BusinessType(rawValue: "non_profit")
}

// MARK: - Business Industry

// MARK: - Estimated Annual Revenue

/// Estimated annual revenue range
public struct EstimatedAnnualRevenue: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let zeroTo99999 = EstimatedAnnualRevenue(rawValue: "0_99999")
    public static let hundredKTo999999 = EstimatedAnnualRevenue(rawValue: "100000_999999")
    public static let oneMillionTo9999999 = EstimatedAnnualRevenue(rawValue: "1000000_9999999")
    public static let tenMillionTo49999999 = EstimatedAnnualRevenue(rawValue: "10000000_49999999")
    public static let fiftyMillionTo249999999 = EstimatedAnnualRevenue(rawValue: "50000000_249999999")
    public static let twoHundredFiftyMillionPlus = EstimatedAnnualRevenue(rawValue: "250000000_plus")

    @available(*, deprecated, renamed: "twoHundredFiftyMillionPlus")
    public static var twoAndAHalfBillionPlus: Self { .twoHundredFiftyMillionPlus }
}

// MARK: - Source of Wealth

/// Source of wealth for business customers
public struct SourceOfWealth: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let businessDividendsOrProfits = SourceOfWealth(rawValue: "business_dividends_or_profits")
    public static let investments = SourceOfWealth(rawValue: "investments")
    public static let assetSales = SourceOfWealth(rawValue: "asset_sales")
    public static let clientInvestorContributions = SourceOfWealth(rawValue: "client_investor_contributions")
    public static let gambling = SourceOfWealth(rawValue: "gambling")
    public static let charitableContributions = SourceOfWealth(rawValue: "charitable_contributions")
    public static let inheritance = SourceOfWealth(rawValue: "inheritance")
    public static let affiliateOrRoyaltyIncome = SourceOfWealth(rawValue: "affiliate_or_royalty_income")
    public static let salaryOrWages = SourceOfWealth(rawValue: "salary_or_wages")
    public static let savings = SourceOfWealth(rawValue: "savings")
}

// MARK: - AML Status

/// AML screening status
public struct AmlStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let clear = AmlStatus(rawValue: "clear")
    public static let hit = AmlStatus(rawValue: "hit")
    public static let error = AmlStatus(rawValue: "error")
}

// MARK: - Owner Tax Type

/// Tax identifier type for owner
public struct OwnerTaxType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let ssn = OwnerTaxType(rawValue: "SSN")
    public static let itin = OwnerTaxType(rawValue: "ITIN")
}

// MARK: - AML Hits

/// AML screening match details
public struct AmlHits: Codable, Sendable, Equatable {
    /// Whether there is a sanction match
    public let hasSanctionMatch: Bool?

    /// Whether there is a PEP match
    public let hasPepMatch: Bool?

    /// Whether there is a watchlist match
    public let hasWatchlistMatch: Bool?

    /// Whether there is a crimelist match
    public let hasCrimelistMatch: Bool?

    /// Whether there is an adverse media match
    public let hasAdversemediaMatch: Bool?

    public init(
        hasSanctionMatch: Bool? = nil,
        hasPepMatch: Bool? = nil,
        hasWatchlistMatch: Bool? = nil,
        hasCrimelistMatch: Bool? = nil,
        hasAdversemediaMatch: Bool? = nil
    ) {
        self.hasSanctionMatch = hasSanctionMatch
        self.hasPepMatch = hasPepMatch
        self.hasWatchlistMatch = hasWatchlistMatch
        self.hasCrimelistMatch = hasCrimelistMatch
        self.hasAdversemediaMatch = hasAdversemediaMatch
    }

    enum CodingKeys: String, CodingKey {
        case hasSanctionMatch = "has_sanction_match"
        case hasPepMatch = "has_pep_match"
        case hasWatchlistMatch = "has_watchlist_match"
        case hasCrimelistMatch = "has_crimelist_match"
        case hasAdversemediaMatch = "has_adversemedia_match"
    }
}

// MARK: - Owner Role

/// Role of an owner
public struct OwnerRole: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let beneficialOwner = OwnerRole(rawValue: "beneficial_owner")
    public static let authorizedSigner = OwnerRole(rawValue: "authorized_signer")
    public static let other = OwnerRole(rawValue: "other")
    public static let beneficialControlling = OwnerRole(rawValue: "beneficial_controlling")
    public static let controllingPerson = OwnerRole(rawValue: "controlling_person")
}

// MARK: - Owner

/// Owner information for business customers
public struct CustomerOwner: Codable, Sendable, Equatable {
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

    /// Instance ID (optional, present in response)
    public let instanceId: String?

    /// Customer ID (optional, present in response)
    public let customerId: String?

    /// Proof of address document type (optional)
    public let proofOfAddressDocType: ProofOfAddressDocType?

    /// Proof of address document file URL (optional)
    public let proofOfAddressDocFile: String?

    /// Ownership percentage (0-100, optional)
    public let ownershipPercentage: Int?

    /// Job title of the owner (optional)
    public let title: String?

    /// Tax identifier type (optional)
    public let taxType: OwnerTaxType?

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
        instanceId: String? = nil,
        customerId: String? = nil,
        proofOfAddressDocType: ProofOfAddressDocType? = nil,
        proofOfAddressDocFile: String? = nil,
        ownershipPercentage: Int? = nil,
        title: String? = nil,
        taxType: OwnerTaxType? = nil
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
        self.instanceId = instanceId
        self.customerId = customerId
        self.proofOfAddressDocType = proofOfAddressDocType
        self.proofOfAddressDocFile = proofOfAddressDocFile
        self.ownershipPercentage = ownershipPercentage
        self.title = title
        self.taxType = taxType
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
        case instanceId = "instance_id"
        case customerId = "customer_id"
        case proofOfAddressDocType = "proof_of_address_doc_type"
        case proofOfAddressDocFile = "proof_of_address_doc_file"
        case ownershipPercentage = "ownership_percentage"
        case title
        case taxType = "tax_type"
    }
}

// MARK: - Additional Info

/// Category of an ``AdditionalInfoItem``.
public struct AdditionalInfoLabel: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let einLetter = AdditionalInfoLabel(rawValue: "EIN_LETTER")
    public static let kycProviderDocument = AdditionalInfoLabel(rawValue: "KYC_PROVIDER_DOCUMENT")
    public static let flowOfFunds = AdditionalInfoLabel(rawValue: "FLOW_OF_FUNDS")
    public static let bankStatement = AdditionalInfoLabel(rawValue: "BANK_STATEMENT")
    public static let taxReturn = AdditionalInfoLabel(rawValue: "TAX_RETURN")
    public static let auditedFinancials = AdditionalInfoLabel(rawValue: "AUDITED_FINANCIALS")
    public static let operatingAgreement = AdditionalInfoLabel(rawValue: "OPERATING_AGREEMENT")
    public static let boardResolution = AdditionalInfoLabel(rawValue: "BOARD_RESOLUTION")
    public static let certificateOfGoodStanding = AdditionalInfoLabel(rawValue: "CERTIFICATE_OF_GOOD_STANDING")
    public static let businessLicense = AdditionalInfoLabel(rawValue: "BUSINESS_LICENSE")
    public static let msbLicense = AdditionalInfoLabel(rawValue: "MSB_LICENSE")
    public static let powerOfAttorney = AdditionalInfoLabel(rawValue: "POWER_OF_ATTORNEY")
    public static let trustDeed = AdditionalInfoLabel(rawValue: "TRUST_DEED")
    public static let shareholderRegistry = AdditionalInfoLabel(rawValue: "SHAREHOLDER_REGISTRY")
    public static let beneficialOwnerDeclaration = AdditionalInfoLabel(rawValue: "BENEFICIAL_OWNER_DECLARATION")
    public static let complianceQuestionnaire = AdditionalInfoLabel(rawValue: "COMPLIANCE_QUESTIONNAIRE")
    public static let proofOfEmployment = AdditionalInfoLabel(rawValue: "PROOF_OF_EMPLOYMENT")
    public static let referenceLetter = AdditionalInfoLabel(rawValue: "REFERENCE_LETTER")
    public static let other = AdditionalInfoLabel(rawValue: "OTHER")
}

/// An extra document or note attached to a customer. `value` is a URL
/// (BlindPay downloads and re-hosts it) or a free-text description.
public struct AdditionalInfoItem: Codable, Sendable, Equatable {
    /// The kind of document or note.
    public let label: AdditionalInfoLabel

    /// A document URL or a free-text description.
    public let value: String

    public init(label: AdditionalInfoLabel, value: String) {
        self.label = label
        self.value = value
    }
}

// MARK: - Create Customer Input

/// Input for creating a customer
public struct CreateCustomerInput: Codable, Sendable {
    /// Country code
    public let country: Country
    
    /// Email address
    public let email: String
    
    /// KYC type
    public let kycType: KYCType
    
    /// Customer type
    public let type: CustomerType
    
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
    
    /// Owners (optional, for business customers)
    public let owners: [CustomerOwner]?
    
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
    
    
    /// Terms of service ID (optional)
    public let tosId: String?

    /// Account purpose (optional)
    public let accountPurpose: AccountPurpose?

    /// Account purpose description when account_purpose is "other" (optional)
    public let accountPurposeOther: String?

    /// Business entity type (optional)
    public let businessType: BusinessType?

    /// Business description (optional)
    public let businessDescription: String?

    /// Business industry NAICS code (optional)
    public let businessIndustry: String?

    /// Estimated annual revenue range (optional)
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Source of wealth (optional)
    public let sourceOfWealth: SourceOfWealth?

    /// Whether the business is publicly traded (optional)
    public let publiclyTraded: Bool?

    /// Occupation (optional)
    public let occupation: String?

    /// Optional extra documents or notes for this customer. `label` is a known category, `value` is either a URL to upload or a free-text description. Any URLs are downloaded and re-hosted on Blindpay storage before being stored.
    public let additionalInfo: [AdditionalInfoItem]?

    /// Optional geolocation latitude collected from the customer. Forwarded to AiPrise and SEON for fraud analysis.
    public let latitude: Double?

    /// Optional geolocation longitude collected from the customer. Forwarded to AiPrise and SEON for fraud analysis.
    public let longitude: Double?

    public init(
        country: Country,
        email: String,
        kycType: KYCType,
        type: CustomerType,
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
        owners: [CustomerOwner]? = nil,
        incorporationDocFile: String? = nil,
        proofOfOwnershipDocFile: String? = nil,
        sourceOfFundsDocType: SourceOfFundsDocType? = nil,
        sourceOfFundsDocFile: String? = nil,
        selfieFile: String? = nil,
        purposeOfTransactions: PurposeOfTransactions? = nil,
        purposeOfTransactionsExplanation: String? = nil,
        tosId: String? = nil,
        accountPurpose: AccountPurpose? = nil,
        accountPurposeOther: String? = nil,
        businessType: BusinessType? = nil,
        businessDescription: String? = nil,
        businessIndustry: String? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        sourceOfWealth: SourceOfWealth? = nil,
        publiclyTraded: Bool? = nil,
        occupation: String? = nil,
        additionalInfo: [AdditionalInfoItem]? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
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
        self.tosId = tosId
        self.accountPurpose = accountPurpose
        self.accountPurposeOther = accountPurposeOther
        self.businessType = businessType
        self.businessDescription = businessDescription
        self.businessIndustry = businessIndustry
        self.estimatedAnnualRevenue = estimatedAnnualRevenue
        self.sourceOfWealth = sourceOfWealth
        self.publiclyTraded = publiclyTraded
        self.occupation = occupation
        self.additionalInfo = additionalInfo
        self.latitude = latitude
        self.longitude = longitude
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
        case tosId = "tos_id"
        case accountPurpose = "account_purpose"
        case accountPurposeOther = "account_purpose_other"
        case businessType = "business_type"
        case businessDescription = "business_description"
        case businessIndustry = "business_industry"
        case estimatedAnnualRevenue = "estimated_annual_revenue"
        case sourceOfWealth = "source_of_wealth"
        case publiclyTraded = "publicly_traded"
        case occupation
        case additionalInfo = "additional_info"
        case latitude
        case longitude
    }
}

// MARK: - KYC Status

/// KYC verification status
public struct KYCStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let verifying = KYCStatus(rawValue: "verifying")
    public static let approved = KYCStatus(rawValue: "approved")
    public static let rejected = KYCStatus(rawValue: "rejected")
    public static let deprecated = KYCStatus(rawValue: "deprecated")
    public static let pendingReview = KYCStatus(rawValue: "pending_review")
    public static let awaitingContract = KYCStatus(rawValue: "awaiting_contract")
    public static let complianceRequest = KYCStatus(rawValue: "compliance_request")
    public static let approvedRFI = KYCStatus(rawValue: "approved_rfi")
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
    public let score: Double
    
    public init(id: String, name: String, operation: String, score: Double) {
        self.id = id
        self.name = name
        self.operation = operation
        self.score = score
    }
}

// MARK: - Customer Limits

/// Customer transaction limits
public struct CustomerLimits: Codable, Sendable, Equatable {
    /// Per transaction limit
    public let perTransaction: Int?
    
    /// Daily limit
    public let daily: Int?
    
    /// Monthly limit
    public let monthly: Int?
    
    public init(perTransaction: Int?, daily: Int?, monthly: Int?) {
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

// MARK: - Customer (Full Model)

/// Full customer model with all fields from API responses
public struct Customer: Codable, Sendable, Equatable {
    /// Unique identifier
    public let id: String
    
    /// Customer type
    public let type: CustomerType
    
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
    public let owners: [CustomerOwner]?
    
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
    public let createdAt: String?
    
    /// Updated at timestamp
    public let updatedAt: String?
    
    /// Transaction limits
    public let limit: CustomerLimits?
    
    /// Whether TOS is accepted
    public let isTosAccepted: Bool?

    /// Account purpose
    public let accountPurpose: AccountPurpose?

    /// Account purpose description when account_purpose is "other"
    public let accountPurposeOther: String?

    /// Business entity type
    public let businessType: BusinessType?

    /// Business description
    public let businessDescription: String?

    /// Business industry NAICS code
    public let businessIndustry: String?

    /// Estimated annual revenue range
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Source of wealth
    public let sourceOfWealth: SourceOfWealth?

    /// Whether the business is publicly traded
    public let publiclyTraded: Bool?

    /// Occupation
    public let occupation: String?

    /// AML screening status
    public let amlStatus: AmlStatus?

    /// AML screening match details
    public let amlHits: AmlHits?

    /// The customer id (same as `id`).
    public let customerId: String?

    public let cnaeCondition: [String: AnyCodable]?

    public let isNested: Bool?

    public let virtualAccountPreapproval: [String: AnyCodable]?

    /// Optional extra documents or notes for this customer. `label` is a known category, `value` is either a URL to upload or a free-text description. Any URLs are downloaded and re-hosted on Blindpay storage before being stored.
    public let additionalInfo: [AdditionalInfoItem]?

    /// Optional geolocation latitude collected from the customer. Forwarded to AiPrise and SEON for fraud analysis.
    public let latitude: Double?

    /// Optional geolocation longitude collected from the customer. Forwarded to AiPrise and SEON for fraud analysis.
    public let longitude: Double?

    public init(
        id: String,
        type: CustomerType,
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
        owners: [CustomerOwner]? = nil,
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
        createdAt: String? = nil,
        updatedAt: String? = nil,
        limit: CustomerLimits? = nil,
        isTosAccepted: Bool? = nil,
        accountPurpose: AccountPurpose? = nil,
        accountPurposeOther: String? = nil,
        businessType: BusinessType? = nil,
        businessDescription: String? = nil,
        businessIndustry: String? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        sourceOfWealth: SourceOfWealth? = nil,
        publiclyTraded: Bool? = nil,
        occupation: String? = nil,
        amlStatus: AmlStatus? = nil,
        amlHits: AmlHits? = nil,
        customerId: String? = nil,
        cnaeCondition: [String: AnyCodable]? = nil,
        isNested: Bool? = nil,
        virtualAccountPreapproval: [String: AnyCodable]? = nil,
        additionalInfo: [AdditionalInfoItem]? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
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
        self.accountPurposeOther = accountPurposeOther
        self.businessType = businessType
        self.businessDescription = businessDescription
        self.businessIndustry = businessIndustry
        self.estimatedAnnualRevenue = estimatedAnnualRevenue
        self.sourceOfWealth = sourceOfWealth
        self.publiclyTraded = publiclyTraded
        self.occupation = occupation
        self.amlStatus = amlStatus
        self.amlHits = amlHits
        self.customerId = customerId
        self.cnaeCondition = cnaeCondition
        self.isNested = isNested
        self.virtualAccountPreapproval = virtualAccountPreapproval
        self.additionalInfo = additionalInfo
        self.latitude = latitude
        self.longitude = longitude
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
        case accountPurposeOther = "account_purpose_other"
        case businessType = "business_type"
        case businessDescription = "business_description"
        case businessIndustry = "business_industry"
        case estimatedAnnualRevenue = "estimated_annual_revenue"
        case sourceOfWealth = "source_of_wealth"
        case publiclyTraded = "publicly_traded"
        case occupation
        case amlStatus = "aml_status"
        case amlHits = "aml_hits"
        case customerId = "customer_id"
        case cnaeCondition = "cnae_condition"
        case isNested = "is_nested"
        case virtualAccountPreapproval = "virtual_account_preapproval"
        case additionalInfo = "additional_info"
        case latitude
        case longitude
    }
}

// MARK: - Update Customer Input

/// Input for updating a customer
public struct UpdateCustomerInput: Codable, Sendable {
    /// Country code
    public let country: Country
    
    /// Email address
    public let email: String
    
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
    
    /// Owners (optional, for business customers)
    public let owners: [CustomerOwner]?
    
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

    /// Account purpose description when account_purpose is "other" (optional)
    public let accountPurposeOther: String?

    /// Business entity type (optional)
    public let businessType: BusinessType?

    /// Business description (optional)
    public let businessDescription: String?

    /// Business industry NAICS code (optional)
    public let businessIndustry: String?

    /// Estimated annual revenue range (optional)
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Source of wealth (optional)
    public let sourceOfWealth: SourceOfWealth?

    /// Whether the business is publicly traded (optional)
    public let publiclyTraded: Bool?

    /// Occupation (optional)
    public let occupation: String?

    /// Optional extra documents or notes for this customer. `label` is a known category, `value` is either a URL to upload or a free-text description. Any URLs are downloaded and re-hosted on Blindpay storage before being stored.
    public let additionalInfo: [AdditionalInfoItem]?

    /// Optional geolocation latitude collected from the customer. Forwarded to AiPrise and SEON for fraud analysis.
    public let latitude: Double?

    /// Optional geolocation longitude collected from the customer. Forwarded to AiPrise and SEON for fraud analysis.
    public let longitude: Double?

    public init(
        country: Country,
        email: String,
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
        owners: [CustomerOwner]? = nil,
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
        accountPurposeOther: String? = nil,
        businessType: BusinessType? = nil,
        businessDescription: String? = nil,
        businessIndustry: String? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        sourceOfWealth: SourceOfWealth? = nil,
        publiclyTraded: Bool? = nil,
        occupation: String? = nil,
        additionalInfo: [AdditionalInfoItem]? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
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
        self.accountPurposeOther = accountPurposeOther
        self.businessType = businessType
        self.businessDescription = businessDescription
        self.businessIndustry = businessIndustry
        self.estimatedAnnualRevenue = estimatedAnnualRevenue
        self.sourceOfWealth = sourceOfWealth
        self.publiclyTraded = publiclyTraded
        self.occupation = occupation
        self.additionalInfo = additionalInfo
        self.latitude = latitude
        self.longitude = longitude
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
        case accountPurposeOther = "account_purpose_other"
        case businessType = "business_type"
        case businessDescription = "business_description"
        case businessIndustry = "business_industry"
        case estimatedAnnualRevenue = "estimated_annual_revenue"
        case sourceOfWealth = "source_of_wealth"
        case publiclyTraded = "publicly_traded"
        case occupation
        case additionalInfo = "additional_info"
        case latitude
        case longitude
    }
}

// MARK: - Response Types

/// Response type for creating a customer
public struct CreateCustomerResponse: Codable, Sendable, Equatable {
    /// Unique identifier for the created customer
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

/// Response type for updating a customer
public struct UpdateCustomerResponse: Codable, Sendable, Equatable {
    /// Whether the update was successful
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}

/// Response type for deleting a customer
public struct DeleteCustomerResponse: Codable, Sendable, Equatable {
    /// Whether the deletion was successful
    public let success: Bool
    
    public init(success: Bool) {
        self.success = success
    }
}

/// Response type for listing customers — API returns a plain array
public typealias ListCustomersResponse = ListResult<Customer>

/// Filters and cursors for listing customers. Every value is optional; unset ones are not sent.
public struct ListCustomersInput: CursorPaginatedInput {
    /// Page size (10, 50, 100, 200, 500 or 1000).
    public var limit: Int?

    /// Return items after this id (the previous page's `pagination.nextPage`).
    public var startingAfter: String?

    /// Return items before this id.
    public var endingBefore: String?

    /// Full name contains this text.
    public var fullName: String?

    /// Customer name contains this text.
    public var customerName: String?

    /// Only this KYC status.
    public var status: KYCStatus?

    /// Only this customer.
    public var customerId: String?

    /// Only customers with this bank account.
    public var bankAccountId: String?

    /// Only this country.
    public var country: Country?

    /// Deprecated: the API ignores `offset`. Use `startingAfter`.
    @available(*, deprecated, message: "Ignored by the API; use startingAfter.")
    public var offset: Int? {
        get { legacyOffset }
        set { legacyOffset = newValue }
    }
    private var legacyOffset: Int?

    public init(
        limit: Int? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil,
        fullName: String? = nil,
        customerName: String? = nil,
        status: KYCStatus? = nil,
        customerId: String? = nil,
        bankAccountId: String? = nil,
        country: Country? = nil
    ) {
        self.limit = limit
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
        self.fullName = fullName
        self.customerName = customerName
        self.status = status
        self.customerId = customerId
        self.bankAccountId = bankAccountId
        self.country = country
    }

    func toQueryParameters() -> QueryParameters {
        var params = QueryParameters()
        params["limit"] = limit.map(String.init)
        params["offset"] = legacyOffset.map(String.init)
        params["starting_after"] = startingAfter
        params["ending_before"] = endingBefore
        params["full_name"] = fullName
        params["customer_name"] = customerName
        params["status"] = status?.rawValue
        params["customer_id"] = customerId
        params["bank_account_id"] = bankAccountId
        params["country"] = country?.rawValue
        return params
    }
}
