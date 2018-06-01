//
//  ADIndex.swift
//  AzureData
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

@objc(ADIndex)
public class ADIndex: NSObject, ADCodable {
    private enum CodingKeys: String, CodingKey {
        case kind
        case dataType
        case precision
    }

    private typealias SwiftType = DocumentCollection.IndexingPolicy.IncludedPath.Index

    @objc
    public let kind: ADIndexKind

    @objc
    public let dataType: ADIndexDataType

    @objc
    public let precision: Int16

    internal init(kind: ADIndexKind, dataType: ADIndexDataType, precision: Int16) {
        self.kind = kind
        self.dataType = dataType
        self.precision = precision
    }

    public static func hash(withDataType dataType: ADIndexDataType, andPrecision precision: Int16) -> ADIndex {
        return ADIndex(kind: .hash, dataType: dataType, precision: precision)
    }

    public static func range(withDataType dataType: ADIndexDataType, andPrecision precision: Int16) -> ADIndex {
        return ADIndex(kind: .range, dataType: dataType, precision: precision)
    }

    public static func spatial(withDataType dataType: ADIndexDataType) -> ADIndex {
        return ADIndex(kind: .spatial, dataType: dataType, precision: Int16.nil)
    }

    public required init?(from dictionary: NSDictionary) {
        guard let kind = dictionary[CodingKeys.kind] as? String else { return nil }
        guard let dataType = dictionary[CodingKeys.dataType] as? String else { return nil }

        self.kind = SwiftType.IndexKind(rawValue: kind)!.bridgedToObjectiveC
        self.dataType = SwiftType.DataType(rawValue: dataType)!.bridgedToObjectiveC
        self.precision = dictionary[CodingKeys.precision] as! Int16
    }

    public func encode() -> NSDictionary {
        let dictionary = NSMutableDictionary()

        dictionary[CodingKeys.kind] = SwiftType.IndexKind(bridgedFromObjectiveC: kind).rawValue
        dictionary[CodingKeys.dataType] = SwiftType.DataType(bridgedFromObjectiveC: dataType).rawValue

        if precision != Int16.nil {
            dictionary[CodingKeys.precision] = precision
        }

        return dictionary
    }
}

extension DocumentCollection.IndexingPolicy.IncludedPath.Index: ObjectiveCBridgeable {
    typealias ObjectiveCType = ADIndex
    typealias SwiftType = DocumentCollection.IndexingPolicy.IncludedPath.Index

    func bridgeToObjectiveC() -> ADIndex {
        let kind = self.kind!.bridgedToObjectiveC
        let dataType = self.dataType!.bridgedToObjectiveC

        return ADIndex(kind: kind, dataType: dataType, precision: precision ?? Int16.nil)
    }

    init?(bridgedFromObjectiveC: ADIndex) {
        let kind = SwiftType.IndexKind(bridgedFromObjectiveC: bridgedFromObjectiveC.kind)
        let dataType = SwiftType.DataType(bridgedFromObjectiveC: bridgedFromObjectiveC.dataType)
        let precision = bridgedFromObjectiveC.precision

        self.init(kind: kind, dataType: dataType, precision: precision)
    }
}
