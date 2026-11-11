//
//  Payable.swift
//  blindpay-swift
//

import Foundation

// MARK: - Enums

/// Status of a payable.
public struct PayableStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let draft = PayableStatus(rawValue: "draft")
    public static let processing = PayableStatus(rawValue: "processing")
    public static let completed = PayableStatus(rawValue: "completed")
    public static let canceled = PayableStatus(rawValue: "canceled")
}

/// Why a payable returned to draft (set on that `payable.update` event).
public struct PayableAttemptStatus: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let failed = PayableAttemptStatus(rawValue: "failed")
    public static let refunded = PayableAttemptStatus(rawValue: "refunded")
}

/// Rail of a payable's beneficiary bank account.
public struct PayableBankAccountType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let ach = PayableBankAccountType(rawValue: "ach")
    public static let wire = PayableBankAccountType(rawValue: "wire")
}

// MARK: - Models

/// The payer (`from`) or beneficiary (`to`) of a payable.
public struct PayableParty: Codable, Sendable, Equatable {
    public let legalName: String?
    public let addressLine1: String?
    public let addressLine2: String?
    public let city: String?
    public let stateProvinceRegion: String?
    public let postalCode: String?
    /// ISO 3166-1 alpha-2 country code
    public let country: String?
    public let taxId: String?

    public init(
        legalName: String? = nil,
        addressLine1: String? = nil,
        addressLine2: String? = nil,
        city: String? = nil,
        stateProvinceRegion: String? = nil,
        postalCode: String? = nil,
        country: String? = nil,
        taxId: String? = nil
    ) {
        self.legalName = legalName
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.stateProvinceRegion = stateProvinceRegion
        self.postalCode = postalCode
        self.country = country
        self.taxId = taxId
    }

    enum CodingKeys: String, CodingKey {
        case legalName = "legal_name"
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case city
        case stateProvinceRegion = "state_province_region"
        case postalCode = "postal_code"
        case country
        case taxId = "tax_id"
    }
}

/// One invoice line of a payable. `price` is in cents.
public struct PayableLineItem: Codable, Sendable, Equatable {
    public let name: String
    public let quantity: Int
    /// Unit price in cents of the payable currency. 150000 represents 1,500.00.
    public let price: Int?

    public init(
        name: String,
        quantity: Int,
        price: Int? = nil
    ) {
        self.name = name
        self.quantity = quantity
        self.price = price
    }

    enum CodingKeys: String, CodingKey {
        case name
        case quantity
        case price
    }
}

/// The beneficiary bank account of a payable.
public struct PayableBankAccount: Codable, Sendable, Equatable {
    public let type: PayableBankAccountType
    public let beneficiaryName: String?
    public let routingNumber: String?
    public let accountNumber: String?
    public let accountType: String?

    public init(
        type: PayableBankAccountType,
        beneficiaryName: String? = nil,
        routingNumber: String? = nil,
        accountNumber: String? = nil,
        accountType: String? = nil
    ) {
        self.type = type
        self.beneficiaryName = beneficiaryName
        self.routingNumber = routingNumber
        self.accountNumber = accountNumber
        self.accountType = accountType
    }

    enum CodingKeys: String, CodingKey {
        case type
        case beneficiaryName = "beneficiary_name"
        case routingNumber = "routing_number"
        case accountNumber = "account_number"
        case accountType = "account_type"
    }
}

/// A payable: a bill (boleto, PIX code or invoice) a customer pays out to a beneficiary.
public struct Payable: Codable, Sendable, Equatable {
    public let id: String
    public let instanceId: String
    public let customerId: String
    public let from: PayableParty?
    public let to: PayableParty?
    /// ISO 4217 currency code of the payable.
    public let currency: Currency
    /// Invoice line items. The payable total is the line item sum plus taxes minus discount.
    public let lineItems: [PayableLineItem]?
    public let note: String?
    /// Discount in cents of the payable currency.
    public let discount: Int?
    /// Taxes in cents of the payable currency.
    public let taxes: Int?
    /// Boleto or arrecadação code (linha digitável or barcode).
    public let boletoBarcode: String?
    /// PIX copia e cola (EMV) payload.
    public let pixQrcode: String?
    /// The boleto or invoice document, as a file URL returned by POST /upload with bucket `documents`. Not accepted for PIX payables. Read it through POST /presign.
    public let documentFile: String?
    public let dueDate: String?
    /// When to pay this payable automatically. Not executed yet: stored for the upcoming scheduling feature.
    public let scheduledAt: String?
    /// draft until a payout executes this payable, processing while one is in flight, completed when paid, canceled when a draft is deleted. A failed or refunded attempt returns it to draft; follow the payout for the attempt detail.
    public let status: PayableStatus
    public let createdAt: String?
    public let updatedAt: String?
    /// Derived total in cents: line item sum plus taxes minus discount. For boleto/PIX the rail amount is re-resolved from the code at quote time and can differ (fines, interest).
    public let amount: Int?
    /// The payout executing this payable, once one exists. Null while the payable is a draft.
    public let payoutId: String?
    public let bankAccount: PayableBankAccount?
    /// Why the payable returned to draft: the attempt in payout_id failed before funding or was refunded after it. Set only on that payable.update event; follow the payout for the detail.
    public let lastAttemptStatus: PayableAttemptStatus?
    public let firstName: String?
    public let lastName: String?
    public let legalName: String?

    public init(
        id: String,
        instanceId: String,
        customerId: String,
        from: PayableParty? = nil,
        to: PayableParty? = nil,
        currency: Currency,
        lineItems: [PayableLineItem]? = nil,
        note: String? = nil,
        discount: Int? = nil,
        taxes: Int? = nil,
        boletoBarcode: String? = nil,
        pixQrcode: String? = nil,
        documentFile: String? = nil,
        dueDate: String? = nil,
        scheduledAt: String? = nil,
        status: PayableStatus,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        amount: Int? = nil,
        payoutId: String? = nil,
        bankAccount: PayableBankAccount? = nil,
        lastAttemptStatus: PayableAttemptStatus? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        legalName: String? = nil
    ) {
        self.id = id
        self.instanceId = instanceId
        self.customerId = customerId
        self.from = from
        self.to = to
        self.currency = currency
        self.lineItems = lineItems
        self.note = note
        self.discount = discount
        self.taxes = taxes
        self.boletoBarcode = boletoBarcode
        self.pixQrcode = pixQrcode
        self.documentFile = documentFile
        self.dueDate = dueDate
        self.scheduledAt = scheduledAt
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.amount = amount
        self.payoutId = payoutId
        self.bankAccount = bankAccount
        self.lastAttemptStatus = lastAttemptStatus
        self.firstName = firstName
        self.lastName = lastName
        self.legalName = legalName
    }

    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case customerId = "customer_id"
        case from
        case to
        case currency
        case lineItems = "line_items"
        case note
        case discount
        case taxes
        case boletoBarcode = "boleto_barcode"
        case pixQrcode = "pix_qrcode"
        case documentFile = "document_file"
        case dueDate = "due_date"
        case scheduledAt = "scheduled_at"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case amount
        case payoutId = "payout_id"
        case bankAccount = "bank_account"
        case lastAttemptStatus = "last_attempt_status"
        case firstName = "first_name"
        case lastName = "last_name"
        case legalName = "legal_name"
    }
}


/// The kind of bill a payable pays.
public struct PayableType: OpenEnum {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let boleto = PayableType(rawValue: "boleto")
    public static let pixCode = PayableType(rawValue: "pix_code")
    public static let invoice = PayableType(rawValue: "invoice")
}

/// One page of payables (see ``ListResult``).
public typealias ListPayablesResponse = ListResult<Payable>

// MARK: - Inputs

/// Input for creating a payable. Amounts (`discount`, `taxes`, line item `price`) are in cents.
public struct CreatePayableInput: Codable, Sendable {
    public let customerId: String
    public let from: PayableParty?
    public let to: PayableParty?
    /// ISO 4217 currency code of the payable.
    public let currency: Currency
    /// Invoice line items. The payable total is the line item sum plus taxes minus discount.
    public let lineItems: [PayableLineItem]?
    public let note: String?
    /// Discount in cents of the payable currency.
    public let discount: Int?
    /// Taxes in cents of the payable currency.
    public let taxes: Int?
    /// Boleto or arrecadação code (linha digitável or barcode).
    public let boletoBarcode: String?
    /// PIX copia e cola (EMV) payload.
    public let pixQrcode: String?
    /// The boleto or invoice document, as a file URL returned by POST /upload with bucket `documents`. Not accepted for PIX payables. Read it through POST /presign.
    public let documentFile: String?
    public let dueDate: String?
    /// When to pay this payable automatically. Not executed yet: stored for the upcoming scheduling feature.
    public let scheduledAt: String?
    public let bankAccount: CreateBankAccountInput?

    public init(
        customerId: String,
        from: PayableParty? = nil,
        to: PayableParty? = nil,
        currency: Currency,
        lineItems: [PayableLineItem]? = nil,
        note: String? = nil,
        discount: Int? = nil,
        taxes: Int? = nil,
        boletoBarcode: String? = nil,
        pixQrcode: String? = nil,
        documentFile: String? = nil,
        dueDate: String? = nil,
        scheduledAt: String? = nil,
        bankAccount: CreateBankAccountInput? = nil
    ) {
        self.customerId = customerId
        self.from = from
        self.to = to
        self.currency = currency
        self.lineItems = lineItems
        self.note = note
        self.discount = discount
        self.taxes = taxes
        self.boletoBarcode = boletoBarcode
        self.pixQrcode = pixQrcode
        self.documentFile = documentFile
        self.dueDate = dueDate
        self.scheduledAt = scheduledAt
        self.bankAccount = bankAccount
    }

    enum CodingKeys: String, CodingKey {
        case customerId = "customer_id"
        case from
        case to
        case currency
        case lineItems = "line_items"
        case note
        case discount
        case taxes
        case boletoBarcode = "boleto_barcode"
        case pixQrcode = "pix_qrcode"
        case documentFile = "document_file"
        case dueDate = "due_date"
        case scheduledAt = "scheduled_at"
        case bankAccount = "bank_account"
    }
}


/// Filters and cursors for listing payables. Every value is optional; unset ones are not sent.
public struct ListPayablesInput: CursorPaginatedInput {
    /// Page size (10, 50, 100, 200, 500 or 1000).
    public var limit: Int?

    /// Return items after this id (the previous page's `pagination.nextPage`).
    public var startingAfter: String?

    /// Return items before this id.
    public var endingBefore: String?

    /// Only this status.
    public var status: PayableStatus?

    /// Only this customer.
    public var customerId: String?

    /// Customer name contains this text.
    public var customerName: String?

    /// Only this kind of bill.
    public var type: PayableType?

    /// Beneficiary name contains this text.
    public var beneficiaryName: String?

    public init(
        limit: Int? = nil,
        startingAfter: String? = nil,
        endingBefore: String? = nil,
        status: PayableStatus? = nil,
        customerId: String? = nil,
        customerName: String? = nil,
        type: PayableType? = nil,
        beneficiaryName: String? = nil
    ) {
        self.limit = limit
        self.startingAfter = startingAfter
        self.endingBefore = endingBefore
        self.status = status
        self.customerId = customerId
        self.customerName = customerName
        self.type = type
        self.beneficiaryName = beneficiaryName
    }

    func toQueryParameters() -> QueryParameters {
        var params = QueryParameters()
        params["limit"] = limit.map(String.init)
        params["starting_after"] = startingAfter
        params["ending_before"] = endingBefore
        params["status"] = status?.rawValue
        params["customer_id"] = customerId
        params["customer_name"] = customerName
        params["type"] = type?.rawValue
        params["beneficiary_name"] = beneficiaryName
        return params
    }
}
