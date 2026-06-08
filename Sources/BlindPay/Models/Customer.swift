//
//  Customer.swift
//  blindpay-swift
//
//  Receivers were renamed to customers. The wire format is unchanged,
//  so customer-prefixed names alias to the existing Receiver* types.
//

import Foundation

public typealias Customer = Receiver
public typealias CreateCustomerInput = CreateReceiverInput
public typealias CreateCustomerResponse = CreateReceiverResponse
public typealias UpdateCustomerInput = UpdateReceiverInput
public typealias UpdateCustomerResponse = UpdateReceiverResponse
public typealias DeleteCustomerResponse = DeleteReceiverResponse
public typealias ListCustomersResponse = ListReceiversResponse
public typealias CustomerLimitsResponse = ReceiverLimitsResponse
