//
//  Default.swift
//
//  Created by CuiXg on 2021/3/25.
//  Copyright © 2021 CuiXg. All rights reserved.
//


/**
 *  为属性设置默认值,可与 Codable 联合使用
 *
 */

import UIKit

@propertyWrapper
public struct Default<T: DefaultValue> {
    public var wrappedValue: T.Value

    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension Default: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

public protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value{ get }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
}

extension KeyedEncodingContainer {
    mutating func encode<T>(_ value: Default<T>, forKey key: KeyedEncodingContainer<K>.Key) throws where T : DefaultValue{
       try encodeIfPresent(value.wrappedValue, forKey: key)
   }
}

public extension Int {
    enum Zero: DefaultValue {
        public static let defaultValue = 0
    }
}

public extension Float {
    enum Zero: DefaultValue {
        public static let defaultValue = 0
    }
}

public extension Double {
    enum Zero: DefaultValue {
        public static let defaultValue = 0
    }
}

public extension String {
    enum Empty: DefaultValue {
        public static let defaultValue = ""
    }
}

public extension Bool {
    enum False: DefaultValue {
        public static let defaultValue = false
    }

    enum True: DefaultValue {
        public static let defaultValue = true
    }
}


// String
@propertyWrapper
public struct StringAsEmpty {
    public var wrappedValue: String

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
}

extension StringAsEmpty: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(String.self)) ?? ""
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: StringAsEmpty.Type, forKey key: Key) throws -> StringAsEmpty {
        try decodeIfPresent(type, forKey: key) ?? StringAsEmpty(wrappedValue: "")
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: StringAsEmpty, forKey key: KeyedEncodingContainer<K>.Key) throws {
       try encodeIfPresent(value.wrappedValue, forKey: key)
   }
}

// Int
@propertyWrapper
public struct IntAsZero {
    public var wrappedValue: Int

    public init(wrappedValue: Int) {
        self.wrappedValue = wrappedValue
    }
}

extension IntAsZero: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Int.self)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: IntAsZero.Type, forKey key: Key) throws -> IntAsZero {
        try decodeIfPresent(type, forKey: key) ?? IntAsZero(wrappedValue: 0)
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: IntAsZero, forKey key: KeyedEncodingContainer<K>.Key) throws {
       try encodeIfPresent(value.wrappedValue, forKey: key)
   }
}

// Float
@propertyWrapper
public struct FloatAsZero {
    public var wrappedValue: Float

    public init(wrappedValue: Float) {
        self.wrappedValue = wrappedValue
    }
}

extension FloatAsZero: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Float.self)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: FloatAsZero.Type, forKey key: Key) throws -> FloatAsZero {
        try decodeIfPresent(type, forKey: key) ?? FloatAsZero(wrappedValue: 0)
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: FloatAsZero, forKey key: KeyedEncodingContainer<K>.Key) throws {
       try encodeIfPresent(value.wrappedValue, forKey: key)
   }
}

// Double
@propertyWrapper
public struct DoubleAsZero {
    public var wrappedValue: Double

    public init(wrappedValue: Double) {
        self.wrappedValue = wrappedValue
    }
}

extension DoubleAsZero: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Double.self)) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: DoubleAsZero.Type, forKey key: Key) throws -> DoubleAsZero {
        try decodeIfPresent(type, forKey: key) ?? DoubleAsZero(wrappedValue: 0)
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: DoubleAsZero, forKey key: KeyedEncodingContainer<K>.Key) throws {
       try encodeIfPresent(value.wrappedValue, forKey: key)
   }
}


// Bool
@propertyWrapper
public struct BoolAsFalse {
    public var wrappedValue: Bool

    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension BoolAsFalse: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Bool.self)) ?? false
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

@propertyWrapper
public struct BoolAsTrue {
    public var wrappedValue: Bool
    
    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
}

extension BoolAsTrue: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Bool.self)) ?? true
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: BoolAsFalse.Type, forKey key: Key) throws -> BoolAsFalse {
        try decodeIfPresent(type, forKey: key) ?? BoolAsFalse(wrappedValue: false)
    }

    func decode(_ type: BoolAsTrue.Type, forKey key: Key) throws -> BoolAsTrue {
        try decodeIfPresent(type, forKey: key) ?? BoolAsTrue(wrappedValue: true)
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: BoolAsFalse, forKey key: KeyedEncodingContainer<K>.Key) throws {
       try encodeIfPresent(value.wrappedValue, forKey: key)
   }

    mutating func encode(_ value: BoolAsTrue, forKey key: KeyedEncodingContainer<K>.Key) throws {
       try encodeIfPresent(value.wrappedValue, forKey: key)
   }
}

