//
//  Instance.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Represents a role that can be assigned to an instance member
public struct InstanceMemberRole: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let owner = InstanceMemberRole(rawValue: "owner")
    public static let admin = InstanceMemberRole(rawValue: "admin")
    public static let finance = InstanceMemberRole(rawValue: "finance")
    public static let checker = InstanceMemberRole(rawValue: "checker")
    public static let operations = InstanceMemberRole(rawValue: "operations")
    public static let developer = InstanceMemberRole(rawValue: "developer")
    public static let viewer = InstanceMemberRole(rawValue: "viewer")
}

/// Represents a member of an instance
public struct InstanceMember: Codable, Sendable, Equatable {
    /// Unique identifier for the member
    public let id: String
    
    /// Email address of the member
    public let email: String
    
    /// First name of the member
    public let firstName: String
    
    /// Middle name of the member (may be empty)
    public let middleName: String?
    
    /// Last name of the member
    public let lastName: String
    
    /// URL to the member's profile image
    public let imageUrl: String
    
    /// Timestamp when the member was created
    public let createdAt: String?
    
    /// Role assigned to the member
    public let role: InstanceMemberRole
    
    /// Whether the member has registered a passkey.
    public let hasPasskey: Bool?

    public init(
        id: String,
        email: String,
        firstName: String,
        middleName: String? = nil,
        lastName: String,
        imageUrl: String,
        createdAt: String? = nil,
        role: InstanceMemberRole,
        hasPasskey: Bool? = nil
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.role = role
        self.hasPasskey = hasPasskey
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case role
        case hasPasskey = "has_passkey"
    }
}

/// Response type for instance members query
public typealias InstanceMembersResponse = [InstanceMember]

/// Input for updating an instance
public struct UpdateInstanceInput: Codable, Sendable {
    /// Name of the instance
    public let name: String

    /// Optional redirect URL for customer invites
    public let customerInviteRedirectUrl: String?

    /// Whether email notifications are enabled (optional)
    public let emailNotifications: Bool?

    /// Whether passkey authentication is required (optional)
    public let requirePasskey: Bool?

    public let accentColor: String?

    public let logoUrl: String?

    public let partnerTosLink: String?

    public let partnerTosScreenshot: String?

    public let partnerTosTermsAccepted: Bool?

    /// When non-empty, compliance Request for Information emails are sent only to these addresses instead of all instance members
    public let complianceEmails: [String]?

    /// Whether customer (customer) Request for Information notification emails are sent for this instance. Omit to leave unchanged.
    public let customerRfiEmailsEnabled: Bool?

    public init(
        name: String,
        customerInviteRedirectUrl: String? = nil,
        emailNotifications: Bool? = nil,
        requirePasskey: Bool? = nil,
        accentColor: String? = nil,
        logoUrl: String? = nil,
        partnerTosLink: String? = nil,
        partnerTosScreenshot: String? = nil,
        partnerTosTermsAccepted: Bool? = nil,
        complianceEmails: [String]? = nil,
        customerRfiEmailsEnabled: Bool? = nil
    ) {
        self.name = name
        self.customerInviteRedirectUrl = customerInviteRedirectUrl
        self.emailNotifications = emailNotifications
        self.requirePasskey = requirePasskey
        self.accentColor = accentColor
        self.logoUrl = logoUrl
        self.partnerTosLink = partnerTosLink
        self.partnerTosScreenshot = partnerTosScreenshot
        self.partnerTosTermsAccepted = partnerTosTermsAccepted
        self.complianceEmails = complianceEmails
        self.customerRfiEmailsEnabled = customerRfiEmailsEnabled
    }

    enum CodingKeys: String, CodingKey {
        case name
        case customerInviteRedirectUrl = "customer_invite_redirect_url"
        case emailNotifications = "email_notifications"
        case requirePasskey = "require_passkey"
        case accentColor = "accent_color"
        case logoUrl = "logo_url"
        case partnerTosLink = "partner_tos_link"
        case partnerTosScreenshot = "partner_tos_screenshot"
        case partnerTosTermsAccepted = "partner_tos_terms_accepted"
        case complianceEmails = "compliance_emails"
        case customerRfiEmailsEnabled = "customer_rfi_emails_enabled"
    }
}

/// Input for updating a member's role
public struct UpdateMemberRoleInput: Codable, Sendable {
    /// The new role to assign to the member
    public let userRole: InstanceMemberRole

    public init(role: InstanceMemberRole) {
        self.userRole = role
    }

    enum CodingKeys: String, CodingKey {
        case userRole = "user_role"
    }
}

/// Input for migrating instance ownership
public struct MigrateInstanceOwnershipInput: Codable, Sendable {
    /// User ID of the new owner
    public let userId: String

    public init(userId: String) {
        self.userId = userId
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

/// Response for migrating instance ownership
public struct MigrateInstanceOwnershipResponse: Codable, Sendable, Equatable {
    /// Success status
    public let success: Bool

    public init(success: Bool) {
        self.success = success
    }
}

/// Empty response type for void operations
public struct VoidResponse: Codable, Sendable {
    public init() {}
}

// MARK: - Instance and onboarding

/// Whether an instance is a production or a development (sandbox) instance.
public struct InstanceType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let production = InstanceType(rawValue: "production")
    public static let development = InstanceType(rawValue: "development")
}

/// Onboarding progress of an instance.
public struct OnboardingStep: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let initial = OnboardingStep(rawValue: "initial")
    public static let businessDetails = OnboardingStep(rawValue: "business_details")
    public static let businessProfile = OnboardingStep(rawValue: "business_profile")
    public static let documents = OnboardingStep(rawValue: "documents")
    public static let applicant = OnboardingStep(rawValue: "applicant")
    public static let completed = OnboardingStep(rawValue: "completed")
    public static let blocked = OnboardingStep(rawValue: "blocked")
}

/// How the business uses BlindPay, from onboarding.
public struct OnboardingScenario: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let custodial = OnboardingScenario(rawValue: "custodial")
    public static let custodialMtl = OnboardingScenario(rawValue: "custodial_mtl")
    public static let nonCustodial = OnboardingScenario(rawValue: "non_custodial")
    public static let other = OnboardingScenario(rawValue: "other")
}

/// Estimated monthly volume, from onboarding.
public struct EstimatedMonthlyVolume: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let upTo100 = EstimatedMonthlyVolume(rawValue: "up_to_100")
    public static let upTo500 = EstimatedMonthlyVolume(rawValue: "up_to_500")
    public static let upTo1000 = EstimatedMonthlyVolume(rawValue: "up_to_1000")
    public static let upTo10000 = EstimatedMonthlyVolume(rawValue: "up_to_10000")
    public static let moreThan10000 = EstimatedMonthlyVolume(rawValue: "more_than_10000")
}

/// An owner listed in the instance onboarding documents.
public struct OnboardingOwner: Codable, Sendable, Equatable {
    public let id: String?
    public let instanceId: String?
    public let role: OwnerRole?
    public let firstName: String?
    public let lastName: String?
    /// Share of the business the owner holds, 0 to 100.
    public let ownershipPercentage: Double?
    public let dateOfBirth: String?
    public let taxId: String?
    public let addressLine1: String?
    public let addressLine2: String?
    public let city: String?
    public let stateProvinceRegion: String?
    public let country: Country?
    public let postalCode: String?
    public let idDocCountry: Country?
    public let idDocType: IDDocType?
    public let idDocFrontFile: String?
    public let idDocBackFile: String?
    public let proofOfAddressDocType: ProofOfAddressDocType?
    public let proofOfAddressDocFile: String?

    public init(
        id: String? = nil,
        instanceId: String? = nil,
        role: OwnerRole? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        ownershipPercentage: Double? = nil,
        dateOfBirth: String? = nil,
        taxId: String? = nil,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        city: String? = nil,
        stateProvinceRegion: String? = nil,
        country: Country? = nil,
        postalCode: String? = nil,
        idDocCountry: Country? = nil,
        idDocType: IDDocType? = nil,
        idDocFrontFile: String? = nil,
        idDocBackFile: String? = nil,
        proofOfAddressDocType: ProofOfAddressDocType? = nil,
        proofOfAddressDocFile: String? = nil
    ) {
        self.id = id
        self.instanceId = instanceId
        self.role = role
        self.firstName = firstName
        self.lastName = lastName
        self.ownershipPercentage = ownershipPercentage
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
    }

    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case role
        case firstName = "first_name"
        case lastName = "last_name"
        case ownershipPercentage = "ownership_percentage"
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
    }
}

/// An instance (your BlindPay account) and its onboarding progress.
public struct Instance: Codable, Sendable, Equatable {
    public let id: String
    public let name: String
    /// development instances simulate settlement with test tokens (USDB) and move no real money; production instances move real funds
    public let type: InstanceType
    /// completed once the instance can move money; anything else means onboarding is still open in the dashboard
    public let onboardingStep: OnboardingStep

    public init(
        id: String,
        name: String,
        type: InstanceType,
        onboardingStep: OnboardingStep
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.onboardingStep = onboardingStep
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case onboardingStep = "onboarding_step"
    }
}

/// The instance's onboarding business details.
public struct BusinessDetails: Codable, Sendable, Equatable {
    public let legalName: String?
    public let taxId: String?
    public let formationDate: String?
    public let tradingNames: [String]?
    public let addressLine1: String?
    public let addressLine2: String?
    public let city: String?
    public let stateProvinceRegion: String?
    public let postalCode: String?
    public let country: Country?
    public let entityType: String?
    public let stateOfIncorporation: String?

    public init(
        legalName: String? = nil,
        taxId: String? = nil,
        formationDate: String? = nil,
        tradingNames: [String]? = nil,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        city: String? = nil,
        stateProvinceRegion: String? = nil,
        postalCode: String? = nil,
        country: Country? = nil,
        entityType: String? = nil,
        stateOfIncorporation: String? = nil
    ) {
        self.legalName = legalName
        self.taxId = taxId
        self.formationDate = formationDate
        self.tradingNames = tradingNames
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.stateProvinceRegion = stateProvinceRegion
        self.postalCode = postalCode
        self.country = country
        self.entityType = entityType
        self.stateOfIncorporation = stateOfIncorporation
    }

    enum CodingKeys: String, CodingKey {
        case legalName = "legal_name"
        case taxId = "tax_id"
        case formationDate = "formation_date"
        case tradingNames = "trading_names"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case city
        case stateProvinceRegion = "state_province_region"
        case postalCode = "postal_code"
        case country
        case entityType = "entity_type"
        case stateOfIncorporation = "state_of_incorporation"
    }
}

/// The instance's onboarding business profile.
public struct BusinessProfile: Codable, Sendable, Equatable {
    public let scenario: OnboardingScenario?
    public let scenarioDescription: String?
    public let hasKycScreening: Bool?
    public let isRegulated: Bool?
    public let businessIndustry: String?
    public let website: String?
    public let topVolumeByCountry: [Country]?
    public let estimatedVolumePerMonth: EstimatedMonthlyVolume?

    public init(
        scenario: OnboardingScenario? = nil,
        scenarioDescription: String? = nil,
        hasKycScreening: Bool? = nil,
        isRegulated: Bool? = nil,
        businessIndustry: String? = nil,
        website: String? = nil,
        topVolumeByCountry: [Country]? = nil,
        estimatedVolumePerMonth: EstimatedMonthlyVolume? = nil
    ) {
        self.scenario = scenario
        self.scenarioDescription = scenarioDescription
        self.hasKycScreening = hasKycScreening
        self.isRegulated = isRegulated
        self.businessIndustry = businessIndustry
        self.website = website
        self.topVolumeByCountry = topVolumeByCountry
        self.estimatedVolumePerMonth = estimatedVolumePerMonth
    }

    enum CodingKeys: String, CodingKey {
        case scenario
        case scenarioDescription = "scenario_description"
        case hasKycScreening = "has_kyc_screening"
        case isRegulated = "is_regulated"
        case businessIndustry = "business_industry"
        case website
        case topVolumeByCountry = "top_volume_by_country"
        case estimatedVolumePerMonth = "estimated_volume_per_month"
    }
}

/// The instance's onboarding ownership documents.
public struct OwnershipDocuments: Codable, Sendable, Equatable {
    public let incorporationDocFile: String?
    public let proofOfOwnershipDocFile: String?
    public let proofOfAddressDocType: ProofOfAddressDocType?
    public let proofOfAddressDocFile: String?
    public let owners: [OnboardingOwner]?

    public init(
        incorporationDocFile: String? = nil,
        proofOfOwnershipDocFile: String? = nil,
        proofOfAddressDocType: ProofOfAddressDocType? = nil,
        proofOfAddressDocFile: String? = nil,
        owners: [OnboardingOwner]? = nil
    ) {
        self.incorporationDocFile = incorporationDocFile
        self.proofOfOwnershipDocFile = proofOfOwnershipDocFile
        self.proofOfAddressDocType = proofOfAddressDocType
        self.proofOfAddressDocFile = proofOfAddressDocFile
        self.owners = owners
    }

    enum CodingKeys: String, CodingKey {
        case incorporationDocFile = "incorporation_doc_file"
        case proofOfOwnershipDocFile = "proof_of_ownership_doc_file"
        case proofOfAddressDocType = "proof_of_address_doc_type"
        case proofOfAddressDocFile = "proof_of_address_doc_file"
        case owners
    }
}

