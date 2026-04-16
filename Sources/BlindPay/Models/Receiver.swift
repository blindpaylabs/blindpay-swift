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
    case investmentLoans = "investment_loans"
    case pensionRetirement = "pension_retirement"
    case saleOfAssetsRealEstate = "sale_of_assets_real_estate"
    case savings = "savings"
    case esops = "esops"
    case investmentProceeds = "investment_proceeds"
    case someoneElseFunds = "someone_else_funds"
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
    case other = "other"
    case protectWealth = "protect_wealth"
    case purchaseGoodAndServices = "purchase_good_and_services"
    case receivePaymentForFreelancing = "receive_payment_for_freelancing"
    case receiveSalary = "receive_salary"
}

// MARK: - Account Purpose

/// Purpose of the account
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
    case payroll = "payroll"
    case treasuryManagement = "treasury_management"
    case other = "other"
}

// MARK: - Business Type

/// Type of business entity
public enum BusinessType: String, Codable, Sendable {
    case corporation = "corporation"
    case llc = "llc"
    case partnership = "partnership"
    case soleProprietorship = "sole_proprietorship"
    case trust = "trust"
    case nonProfit = "non_profit"
}

// MARK: - Business Industry

/// NAICS code for business industry classification
public enum BusinessIndustry: String, Codable, Sendable {
    case n111998 = "111998"
    case n112120 = "112120"
    case n113310 = "113310"
    case n115114 = "115114"
    case n541211 = "541211"
    case n541810 = "541810"
    case n541430 = "541430"
    case n541715 = "541715"
    case n541930 = "541930"
    case n561422 = "561422"
    case n561311 = "561311"
    case n561612 = "561612"
    case n561740 = "561740"
    case n561730 = "561730"
    case n236115 = "236115"
    case n236220 = "236220"
    case n237310 = "237310"
    case n238210 = "238210"
    case n811111 = "811111"
    case n812111 = "812111"
    case n812112 = "812112"
    case n532111 = "532111"
    case n624410 = "624410"
    case n541922 = "541922"
    case n811210 = "811210"
    case n812199 = "812199"
    case n611110 = "611110"
    case n611310 = "611310"
    case n611410 = "611410"
    case n611710 = "611710"
    case n211120 = "211120"
    case n212114 = "212114"
    case n221310 = "221310"
    case n562111 = "562111"
    case n562920 = "562920"
    case n213112 = "213112"
    case n522110 = "522110"
    case n522210 = "522210"
    case n522320 = "522320"
    case n523150 = "523150"
    case n523940 = "523940"
    case n523999 = "523999"
    case n524113 = "524113"
    case n813110 = "813110"
    case n813211 = "813211"
    case n813219 = "813219"
    case n551112 = "551112"
    case n721110 = "721110"
    case n722511 = "722511"
    case n722513 = "722513"
    case n561510 = "561510"
    case n713110 = "713110"
    case n713210 = "713210"
    case n712110 = "712110"
    case n711110 = "711110"
    case n711211 = "711211"
    case n621111 = "621111"
    case n621210 = "621210"
    case n622110 = "622110"
    case n623110 = "623110"
    case n621511 = "621511"
    case n623220 = "623220"
    case n541940 = "541940"
    case n621399 = "621399"
    case n621910 = "621910"
    case n541110 = "541110"
    case n311421 = "311421"
    case n337121 = "337121"
    case n322220 = "322220"
    case n339920 = "339920"
    case n334210 = "334210"
    case n339930 = "339930"
    case n312130 = "312130"
    case n334111 = "334111"
    case n334118 = "334118"
    case n325412 = "325412"
    case n339112 = "339112"
    case n336110 = "336110"
    case n336390 = "336390"
    case n315990 = "315990"
    case n313110 = "313110"
    case n339910 = "339910"
    case n516120 = "516120"
    case n513130 = "513130"
    case n512250 = "512250"
    case n519130 = "519130"
    case n711410 = "711410"
    case n711510 = "711510"
    case n531110 = "531110"
    case n531120 = "531120"
    case n531130 = "531130"
    case n531190 = "531190"
    case n531210 = "531210"
    case n531311 = "531311"
    case n531312 = "531312"
    case n531320 = "531320"
    case n531390 = "531390"
    case n454110 = "454110"
    case n445110 = "445110"
    case n455110 = "455110"
    case n457110 = "457110"
    case n449210 = "449210"
    case n444110 = "444110"
    case n459210 = "459210"
    case n459120 = "459120"
    case n445320 = "445320"
    case n458110 = "458110"
    case n458210 = "458210"
    case n458310 = "458310"
    case n455219 = "455219"
    case n424210 = "424210"
    case n456110 = "456110"
    case n541511 = "541511"
    case n541512 = "541512"
    case n541519 = "541519"
    case n518210 = "518210"
    case n511210 = "511210"
    case n517111 = "517111"
    case n517112 = "517112"
    case n517410 = "517410"
    case n481111 = "481111"
    case n483111 = "483111"
    case n485210 = "485210"
    case n488510 = "488510"
    case n484121 = "484121"
    case n493110 = "493110"
    case n423430 = "423430"
    case n423690 = "423690"
    case n423110 = "423110"
    case n423830 = "423830"
    case n423840 = "423840"
    case n423510 = "423510"
    case n424690 = "424690"
    case n424990 = "424990"
    case n424410 = "424410"
    case n424480 = "424480"
    case n423940 = "423940"
    case n541611 = "541611"
    case n541618 = "541618"
    case n541330 = "541330"
    case n541990 = "541990"
    case n541214 = "541214"
    case n561499 = "561499"
}

// MARK: - Estimated Annual Revenue

/// Estimated annual revenue range
public enum EstimatedAnnualRevenue: String, Codable, Sendable {
    case zeroTo99999 = "0_99999"
    case hundredKTo999999 = "100000_999999"
    case oneMillionTo9999999 = "1000000_9999999"
    case tenMillionTo49999999 = "10000000_49999999"
    case fiftyMillionTo249999999 = "50000000_249999999"
    case twoAndAHalfBillionPlus = "2500000000_plus"
}

// MARK: - Source of Wealth

/// Source of wealth for business receivers
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

// MARK: - AML Status

/// AML screening status
public enum AmlStatus: String, Codable, Sendable {
    case clear = "clear"
    case hit = "hit"
    case error = "error"
}

// MARK: - Owner Tax Type

/// Tax identifier type for owner
public enum OwnerTaxType: String, Codable, Sendable {
    case ssn = "SSN"
    case itin = "ITIN"
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
public enum OwnerRole: String, Codable, Sendable {
    case beneficialOwner = "beneficial_owner"
    case authorizedSigner = "authorized_signer"
    case other = "other"
    case beneficialControlling = "beneficial_controlling"
    case controllingPerson = "controlling_person"
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

    /// Instance ID (optional, present in response)
    public let instanceId: String?

    /// Receiver ID (optional, present in response)
    public let receiverId: String?

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
        receiverId: String? = nil,
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
        self.receiverId = receiverId
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
        case receiverId = "receiver_id"
        case proofOfAddressDocType = "proof_of_address_doc_type"
        case proofOfAddressDocFile = "proof_of_address_doc_file"
        case ownershipPercentage = "ownership_percentage"
        case title
        case taxType = "tax_type"
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

    /// Account purpose description when account_purpose is "other" (optional)
    public let accountPurposeOther: String?

    /// Business entity type (optional)
    public let businessType: BusinessType?

    /// Business description (optional)
    public let businessDescription: String?

    /// Business industry NAICS code (optional)
    public let businessIndustry: BusinessIndustry?

    /// Estimated annual revenue range (optional)
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Source of wealth (optional)
    public let sourceOfWealth: SourceOfWealth?

    /// Whether the business is publicly traded (optional)
    public let publiclyTraded: Bool?

    /// Occupation (optional)
    public let occupation: String?

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
        accountPurposeOther: String? = nil,
        businessType: BusinessType? = nil,
        businessDescription: String? = nil,
        businessIndustry: BusinessIndustry? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        sourceOfWealth: SourceOfWealth? = nil,
        publiclyTraded: Bool? = nil,
        occupation: String? = nil
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
        self.accountPurposeOther = accountPurposeOther
        self.businessType = businessType
        self.businessDescription = businessDescription
        self.businessIndustry = businessIndustry
        self.estimatedAnnualRevenue = estimatedAnnualRevenue
        self.sourceOfWealth = sourceOfWealth
        self.publiclyTraded = publiclyTraded
        self.occupation = occupation
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
        case accountPurposeOther = "account_purpose_other"
        case businessType = "business_type"
        case businessDescription = "business_description"
        case businessIndustry = "business_industry"
        case estimatedAnnualRevenue = "estimated_annual_revenue"
        case sourceOfWealth = "source_of_wealth"
        case publiclyTraded = "publicly_traded"
        case occupation
    }
}

// MARK: - KYC Status

/// KYC verification status
public enum KYCStatus: String, Codable, Sendable {
    case verifying = "verifying"
    case approved = "approved"
    case rejected = "rejected"
    case pending = "pending"
    case deprecated = "deprecated"
    case pendingReview = "pending_review"
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

    /// Account purpose description when account_purpose is "other"
    public let accountPurposeOther: String?

    /// Business entity type
    public let businessType: BusinessType?

    /// Business description
    public let businessDescription: String?

    /// Business industry NAICS code
    public let businessIndustry: BusinessIndustry?

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
        accountPurposeOther: String? = nil,
        businessType: BusinessType? = nil,
        businessDescription: String? = nil,
        businessIndustry: BusinessIndustry? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        sourceOfWealth: SourceOfWealth? = nil,
        publiclyTraded: Bool? = nil,
        occupation: String? = nil,
        amlStatus: AmlStatus? = nil,
        amlHits: AmlHits? = nil
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
    }
}

// MARK: - Update Receiver Input

/// Input for updating a receiver
public struct UpdateReceiverInput: Codable, Sendable {
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
    
    /// Whether this is an FBO account (optional)
    public let isFbo: Bool?
    
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

    /// Account purpose description when account_purpose is "other" (optional)
    public let accountPurposeOther: String?

    /// Business entity type (optional)
    public let businessType: BusinessType?

    /// Business description (optional)
    public let businessDescription: String?

    /// Business industry NAICS code (optional)
    public let businessIndustry: BusinessIndustry?

    /// Estimated annual revenue range (optional)
    public let estimatedAnnualRevenue: EstimatedAnnualRevenue?

    /// Source of wealth (optional)
    public let sourceOfWealth: SourceOfWealth?

    /// Whether the business is publicly traded (optional)
    public let publiclyTraded: Bool?

    /// Occupation (optional)
    public let occupation: String?

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
        isFbo: Bool? = nil,
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
        accountPurposeOther: String? = nil,
        businessType: BusinessType? = nil,
        businessDescription: String? = nil,
        businessIndustry: BusinessIndustry? = nil,
        estimatedAnnualRevenue: EstimatedAnnualRevenue? = nil,
        sourceOfWealth: SourceOfWealth? = nil,
        publiclyTraded: Bool? = nil,
        occupation: String? = nil
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
        self.isFbo = isFbo
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
        case isFbo = "is_fbo"
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

