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
struct Default<T: DefaultValue> {
    var wrappedValue: T.Value
}

extension Default: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

protocol DefaultValue {
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

extension Int {
    enum Zero: DefaultValue {
        static let defaultValue = 0
    }
}

extension Float {
    enum Zero: DefaultValue {
        static let defaultValue = 0
    }
}

extension Double {
    enum Zero: DefaultValue {
        static let defaultValue = 0
    }
}

extension String {
    enum Empty: DefaultValue {
        static let defaultValue = ""
    }
}

extension Bool {
    enum False: DefaultValue {
        static let defaultValue = false
    }

    enum True: DefaultValue {
        static let defaultValue = true
    }
}


// String
@propertyWrapper
struct StringAsEmpty {
    var wrappedValue: String
}

extension StringAsEmpty: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(String.self)) ?? ""
    }

    func encode(to encoder: Encoder) throws {
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
struct IntAsZero {
    var wrappedValue: Int
}

extension IntAsZero: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Int.self)) ?? 0
    }

    func encode(to encoder: Encoder) throws {
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
struct FloatAsZero {
    var wrappedValue: Float
}

extension FloatAsZero: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Float.self)) ?? 0
    }

    func encode(to encoder: Encoder) throws {
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
struct DoubleAsZero {
    var wrappedValue: Double
}

extension DoubleAsZero: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Double.self)) ?? 0
    }

    func encode(to encoder: Encoder) throws {
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
struct BoolAsFalse {
    var wrappedValue: Bool
}

extension BoolAsFalse: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Bool.self)) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

struct BoolAsTrue {
    var wrappedValue: Bool
}

extension BoolAsTrue: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(Bool.self)) ?? true
    }

    func encode(to encoder: Encoder) throws {
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

