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

/// NAICS code for business industry classification
public struct BusinessIndustry: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let n111998 = BusinessIndustry(rawValue: "111998")
    public static let n112120 = BusinessIndustry(rawValue: "112120")
    public static let n113310 = BusinessIndustry(rawValue: "113310")
    public static let n115114 = BusinessIndustry(rawValue: "115114")
    public static let n541211 = BusinessIndustry(rawValue: "541211")
    public static let n541810 = BusinessIndustry(rawValue: "541810")
    public static let n541430 = BusinessIndustry(rawValue: "541430")
    public static let n541715 = BusinessIndustry(rawValue: "541715")
    public static let n541930 = BusinessIndustry(rawValue: "541930")
    public static let n561422 = BusinessIndustry(rawValue: "561422")
    public static let n561311 = BusinessIndustry(rawValue: "561311")
    public static let n561612 = BusinessIndustry(rawValue: "561612")
    public static let n561740 = BusinessIndustry(rawValue: "561740")
    public static let n561730 = BusinessIndustry(rawValue: "561730")
    public static let n236115 = BusinessIndustry(rawValue: "236115")
    public static let n236220 = BusinessIndustry(rawValue: "236220")
    public static let n237310 = BusinessIndustry(rawValue: "237310")
    public static let n238210 = BusinessIndustry(rawValue: "238210")
    public static let n811111 = BusinessIndustry(rawValue: "811111")
    public static let n812111 = BusinessIndustry(rawValue: "812111")
    public static let n812112 = BusinessIndustry(rawValue: "812112")
    public static let n532111 = BusinessIndustry(rawValue: "532111")
    public static let n624410 = BusinessIndustry(rawValue: "624410")
    public static let n541922 = BusinessIndustry(rawValue: "541922")
    public static let n811210 = BusinessIndustry(rawValue: "811210")
    public static let n812199 = BusinessIndustry(rawValue: "812199")
    public static let n611110 = BusinessIndustry(rawValue: "611110")
    public static let n611310 = BusinessIndustry(rawValue: "611310")
    public static let n611410 = BusinessIndustry(rawValue: "611410")
    public static let n611710 = BusinessIndustry(rawValue: "611710")
    public static let n211120 = BusinessIndustry(rawValue: "211120")
    public static let n212114 = BusinessIndustry(rawValue: "212114")
    public static let n221310 = BusinessIndustry(rawValue: "221310")
    public static let n562111 = BusinessIndustry(rawValue: "562111")
    public static let n562920 = BusinessIndustry(rawValue: "562920")
    public static let n213112 = BusinessIndustry(rawValue: "213112")
    public static let n522110 = BusinessIndustry(rawValue: "522110")
    public static let n522210 = BusinessIndustry(rawValue: "522210")
    public static let n522320 = BusinessIndustry(rawValue: "522320")
    public static let n523150 = BusinessIndustry(rawValue: "523150")
    public static let n523940 = BusinessIndustry(rawValue: "523940")
    public static let n523999 = BusinessIndustry(rawValue: "523999")
    public static let n524113 = BusinessIndustry(rawValue: "524113")
    public static let n813110 = BusinessIndustry(rawValue: "813110")
    public static let n813211 = BusinessIndustry(rawValue: "813211")
    public static let n813219 = BusinessIndustry(rawValue: "813219")
    public static let n551112 = BusinessIndustry(rawValue: "551112")
    public static let n721110 = BusinessIndustry(rawValue: "721110")
    public static let n722511 = BusinessIndustry(rawValue: "722511")
    public static let n722513 = BusinessIndustry(rawValue: "722513")
    public static let n561510 = BusinessIndustry(rawValue: "561510")
    public static let n713110 = BusinessIndustry(rawValue: "713110")
    public static let n713210 = BusinessIndustry(rawValue: "713210")
    public static let n712110 = BusinessIndustry(rawValue: "712110")
    public static let n711110 = BusinessIndustry(rawValue: "711110")
    public static let n711211 = BusinessIndustry(rawValue: "711211")
    public static let n621111 = BusinessIndustry(rawValue: "621111")
    public static let n621210 = BusinessIndustry(rawValue: "621210")
    public static let n622110 = BusinessIndustry(rawValue: "622110")
    public static let n623110 = BusinessIndustry(rawValue: "623110")
    public static let n621511 = BusinessIndustry(rawValue: "621511")
    public static let n623220 = BusinessIndustry(rawValue: "623220")
    public static let n541940 = BusinessIndustry(rawValue: "541940")
    public static let n621399 = BusinessIndustry(rawValue: "621399")
    public static let n621910 = BusinessIndustry(rawValue: "621910")
    public static let n541110 = BusinessIndustry(rawValue: "541110")
    public static let n311421 = BusinessIndustry(rawValue: "311421")
    public static let n337121 = BusinessIndustry(rawValue: "337121")
    public static let n322220 = BusinessIndustry(rawValue: "322220")
    public static let n339920 = BusinessIndustry(rawValue: "339920")
    public static let n334210 = BusinessIndustry(rawValue: "334210")
    public static let n339930 = BusinessIndustry(rawValue: "339930")
    public static let n312130 = BusinessIndustry(rawValue: "312130")
    public static let n334111 = BusinessIndustry(rawValue: "334111")
    public static let n334118 = BusinessIndustry(rawValue: "334118")
    public static let n325412 = BusinessIndustry(rawValue: "325412")
    public static let n339112 = BusinessIndustry(rawValue: "339112")
    public static let n336110 = BusinessIndustry(rawValue: "336110")
    public static let n336390 = BusinessIndustry(rawValue: "336390")
    public static let n315990 = BusinessIndustry(rawValue: "315990")
    public static let n313110 = BusinessIndustry(rawValue: "313110")
    public static let n339910 = BusinessIndustry(rawValue: "339910")
    public static let n516120 = BusinessIndustry(rawValue: "516120")
    public static let n513130 = BusinessIndustry(rawValue: "513130")
    public static let n512250 = BusinessIndustry(rawValue: "512250")
    public static let n519130 = BusinessIndustry(rawValue: "519130")
    public static let n711410 = BusinessIndustry(rawValue: "711410")
    public static let n711510 = BusinessIndustry(rawValue: "711510")
    public static let n531110 = BusinessIndustry(rawValue: "531110")
    public static let n531120 = BusinessIndustry(rawValue: "531120")
    public static let n531130 = BusinessIndustry(rawValue: "531130")
    public static let n531190 = BusinessIndustry(rawValue: "531190")
    public static let n531210 = BusinessIndustry(rawValue: "531210")
    public static let n531311 = BusinessIndustry(rawValue: "531311")
    public static let n531312 = BusinessIndustry(rawValue: "531312")
    public static let n531320 = BusinessIndustry(rawValue: "531320")
    public static let n531390 = BusinessIndustry(rawValue: "531390")
    public static let n454110 = BusinessIndustry(rawValue: "454110")
    public static let n445110 = BusinessIndustry(rawValue: "445110")
    public static let n455110 = BusinessIndustry(rawValue: "455110")
    public static let n457110 = BusinessIndustry(rawValue: "457110")
    public static let n449210 = BusinessIndustry(rawValue: "449210")
    public static let n444110 = BusinessIndustry(rawValue: "444110")
    public static let n459210 = BusinessIndustry(rawValue: "459210")
    public static let n459120 = BusinessIndustry(rawValue: "459120")
    public static let n445320 = BusinessIndustry(rawValue: "445320")
    public static let n458110 = BusinessIndustry(rawValue: "458110")
    public static let n458210 = BusinessIndustry(rawValue: "458210")
    public static let n458310 = BusinessIndustry(rawValue: "458310")
    public static let n455219 = BusinessIndustry(rawValue: "455219")
    public static let n424210 = BusinessIndustry(rawValue: "424210")
    public static let n456110 = BusinessIndustry(rawValue: "456110")
    public static let n541511 = BusinessIndustry(rawValue: "541511")
    public static let n541512 = BusinessIndustry(rawValue: "541512")
    public static let n541519 = BusinessIndustry(rawValue: "541519")
    public static let n518210 = BusinessIndustry(rawValue: "518210")
    public static let n511210 = BusinessIndustry(rawValue: "511210")
    public static let n517111 = BusinessIndustry(rawValue: "517111")
    public static let n517112 = BusinessIndustry(rawValue: "517112")
    public static let n517410 = BusinessIndustry(rawValue: "517410")
    public static let n481111 = BusinessIndustry(rawValue: "481111")
    public static let n483111 = BusinessIndustry(rawValue: "483111")
    public static let n485210 = BusinessIndustry(rawValue: "485210")
    public static let n488510 = BusinessIndustry(rawValue: "488510")
    public static let n484121 = BusinessIndustry(rawValue: "484121")
    public static let n493110 = BusinessIndustry(rawValue: "493110")
    public static let n423430 = BusinessIndustry(rawValue: "423430")
    public static let n423690 = BusinessIndustry(rawValue: "423690")
    public static let n423110 = BusinessIndustry(rawValue: "423110")
    public static let n423830 = BusinessIndustry(rawValue: "423830")
    public static let n423840 = BusinessIndustry(rawValue: "423840")
    public static let n423510 = BusinessIndustry(rawValue: "423510")
    public static let n424690 = BusinessIndustry(rawValue: "424690")
    public static let n424990 = BusinessIndustry(rawValue: "424990")
    public static let n424410 = BusinessIndustry(rawValue: "424410")
    public static let n424480 = BusinessIndustry(rawValue: "424480")
    public static let n423940 = BusinessIndustry(rawValue: "423940")
    public static let n541611 = BusinessIndustry(rawValue: "541611")
    public static let n541618 = BusinessIndustry(rawValue: "541618")
    public static let n541330 = BusinessIndustry(rawValue: "541330")
    public static let n541990 = BusinessIndustry(rawValue: "541990")
    public static let n541214 = BusinessIndustry(rawValue: "541214")
    public static let n561499 = BusinessIndustry(rawValue: "561499")
    public static let dapp = BusinessIndustry(rawValue: "dapp")
    public static let exchange = BusinessIndustry(rawValue: "exchange")
    public static let gambling = BusinessIndustry(rawValue: "gambling")
    public static let gaming = BusinessIndustry(rawValue: "gaming")
    public static let infra = BusinessIndustry(rawValue: "infra")
    public static let marketplace = BusinessIndustry(rawValue: "marketplace")
    public static let neoBank = BusinessIndustry(rawValue: "neo_bank")
    public static let other = BusinessIndustry(rawValue: "other")
    public static let saas = BusinessIndustry(rawValue: "saas")
    public static let social = BusinessIndustry(rawValue: "social")
    public static let wallet = BusinessIndustry(rawValue: "wallet")
}

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
    
    /// Whether this is an FBO account (optional)
    public let isFbo: Bool?
    
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
