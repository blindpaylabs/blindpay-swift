//
//  Instance.swift
//  blindpay-swift
//
//  Created by Eric Viana on 31/10/25.
//

import Foundation

/// Represents a role that can be assigned to an instance member
public enum InstanceMemberRole: String, Codable, Sendable {
    case owner = "owner"
    case admin = "admin"
    case finance = "finance"
    case checker = "checker"
    case operations = "operations"
    case developer = "developer"
    case viewer = "viewer"
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
    public let middleName: String
    
    /// Last name of the member
    public let lastName: String
    
    /// URL to the member's profile image
    public let imageUrl: String
    
    /// Timestamp when the member was created
    public let createdAt: String
    
    /// Role assigned to the member
    public let role: InstanceMemberRole
    
    public init(
        id: String,
        email: String,
        firstName: String,
        middleName: String,
        lastName: String,
        imageUrl: String,
        createdAt: String,
        role: InstanceMemberRole
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.role = role
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
    }
}

/// Response type for instance members query
public typealias InstanceMembersResponse = [InstanceMember]

