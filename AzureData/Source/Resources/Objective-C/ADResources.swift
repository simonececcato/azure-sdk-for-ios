//
//  ADResources.swift
//  AzureData
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AzureCore

@objc(ADResources)
public class ADResources: NSObject {
    @objc
    public let resourceId: String

    @objc
    public let count: Int

    @objc
    public let items: [AnyObject]

    @objc
    public init(resourceId: String, count: Int, items: [AnyObject]) {
        self.resourceId = resourceId
        self.count = count
        self.items = items
    }
}

extension Resources: ObjectiveCBridgeable where Resources.Item: ObjectiveCBridgeable {
    typealias ObjectiveCType = ADResources

    func bridgeToObjectiveC() -> ADResources {
        return ADResources(
            resourceId: self.resourceId,
            count: self.count,
            items: self.items.map { $0.bridgeToObjectiveC() }
        )
    }
}
