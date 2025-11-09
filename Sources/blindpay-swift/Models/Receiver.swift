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
    case governmentLetter = "GOVERNMENT_LETTER"
    case other = "OTHER"
}

// MARK: - Source of Funds Document Type

/// Type of source of funds document
public enum SourceOfFundsDocType: String, Codable, Sendable {
    case businessIncome = "business_income"
    case salary = "salary"
    case investment = "investment"
    case gift = "gift"
    case inheritance = "inheritance"
    case other = "other"
}

// MARK: - Purpose of Transactions

/// Purpose of transactions
public enum PurposeOfTransactions: String, Codable, Sendable {
    case businessTransactions = "business_transactions"
    case personalTransactions = "personal_transactions"
    case investment = "investment"
    case other = "other"
}

// MARK: - Owner Role

/// Role of an owner
public enum OwnerRole: String, Codable, Sendable {
    case beneficialOwner = "beneficial_owner"
    case authorizedSigner = "authorized_signer"
    case other = "other"
}

// MARK: - Owner

/// Owner information for business receivers
public struct ReceiverOwner: Codable, Sendable, Equatable {
    /// First name
    public let firstName: String
    
    /// Last name
    public let lastName: String
    
    /// Role of the owner
    public let role: OwnerRole
    
    /// Date of birth (ISO 8601 format)
    public let dateOfBirth: String
    
    /// Tax ID
    public let taxId: String
    
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
    
    public init(
        firstName: String,
        lastName: String,
        role: OwnerRole,
        dateOfBirth: String,
        taxId: String,
        addressLine1: String,
        addressLine2: String? = nil,
        city: String,
        stateProvinceRegion: String,
        country: Country,
        postalCode: String,
        idDocCountry: Country,
        idDocType: IDDocType,
        idDocFrontFile: String,
        idDocBackFile: String? = nil
    ) {
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
    }
    
    enum CodingKeys: String, CodingKey {
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
        tosId: String? = nil
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

