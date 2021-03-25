@[TOC](逐步实现解析库)
## 主流 JSON 解析库
1. [SwiftyJSON ](https://github.com/SwiftyJSON/SwiftyJSON)
2. [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper)
3. [HandyJSON](https://github.com/alibaba/HandyJSON)
4. [JSONEncoder](https://github.com/apple/swift/blob/main/stdlib/public/Darwin/Foundation/JSONEncoder.swift)
5. [MJExtension](https://github.com/CoderMJLee/MJExtension)
6. [YYModel](https://github.com/ibireme/YYModel)
....
## Codable
Codable  Swift 4 带来的新特性，是苹果官方提供的一套用于 JSON 解析的协议。
Codable 其实是一个组合协议，由 Decodable 和 Encodable 两个协议组成：
```swift
Codable` is a type alias for the `Encodable` and `Decodable` protocols.
```
相对于其他三方解析库，Codable最大的优势：**只需要在类型声明中加上 Codable 协议就可以了，不需要写任何实际实现的代码。**
## 简单应用
### Model 类定义
如果使用 **Codable** 进行数据解析，仅需要使定义的数据模型遵守 Codable 协议即可。
*定义的属性数据类型必须页遵守 Codable 协议。*
```swift
class People: Codable {
    let name: String
    let age: Int
    let address: String
}
```
### 自定义键名
在定义的 modle 类中声明一个枚举，遵守 CodingKey 协议即可。
```swift
class People: Codable {
    let name: String
    let age: Int
    let address: String

    enum CodingKeys: String, CodingKey {
        case name = "user_name"
        case age = "user_age"
        case address
    }
}
```
### 解析方式使用
定义了一个简单的 JSON 解析类，很简单，一看就懂。
```swift
//
//  JSON.swift
//
//  Created by CuiXg on 2021/03/25.
//  Copyright © 2021 CuiXg. All rights reserved.
//

import UIKit

public struct JSONError: Error {
    public var code: Int
    public var message: String
    public var localizedDescription: String {
        return message
    }

    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

public class JSON {


    /// Model 转 Data
    /// - Parameter object: 需要转换模型
    /// - Throws: 异常
    /// - Returns: 转换后 Data
    class func toData<T>(_ object: T) throws -> Data where T: Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(object)
    }

    /// 数组 转 Data
    /// - Parameter array: 需要转换数组
    /// - Throws: 异常
    /// - Returns: 转换后 Data
    class func toData<T>(_ array: Array<T>) throws -> Data where T: Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(array)
    }

    /// Model 转 JSONString
    /// - Parameter object: 需要转换数据模型
    /// - Throws: 异常
    /// - Returns: 转换后 JSON 字符串
    public class func toJSONString<T>(_ object: T) throws -> String where T: Encodable {

        let jsonData = try toData(object)
        if let JSONString = String(data: jsonData, encoding: .utf8) {
            return JSONString
        }else {
            throw JSONError(code: 1, message: "Data 转 JSONString 失败")
        }
    }

    /// 数组 转 JSONString
    /// - Parameter array: 需要转换数组
    /// - Throws: 异常
    /// - Returns: 转换后 JSON 字符串
    public class func toJSONString<T>(_ array: Array<T>) throws -> String where T: Encodable {
        let jsonData = try toData(array)
        if let JSONString = String(data: jsonData, encoding: .utf8) {
            return JSONString
        }else {
            throw JSONError(code: 1, message: "Data 转 JSONString 失败")
        }
    }

    /// JSONString 转 Model
    /// - Parameters:
    ///   - JSONString: 需要解析 JSON 字符串
    ///   - type: 数据模型类型
    /// - Throws: 异常
    /// - Returns: 转换后数据模型
    public class func parseObject<T>(_ JSONString: String, type: T.Type) throws -> T where T: Decodable {
        guard let jsonData = JSONString.data(using: .utf8) else {
            throw JSONError(code: 2, message: "JSONString 转 Data 失败")
        }
        return try JSONDecoder().decode(type, from: jsonData)
    }

    /// JSONString 转 数组
    /// - Parameters:
    ///   - JSONString: 需要解析 JSON 字符串
    ///   - type: 数组类型
    /// - Throws: 异常
    /// - Returns: 转换后数组
    public class func parseArray<T>(_ JSONString: String, type: Array<T>.Type) throws -> Array<T> where T: Decodable {
        guard let jsonData = JSONString.data(using: .utf8) else {
            throw JSONError(code: 2, message: "JSONString 转 Data 失败")
        }
        return try JSONDecoder().decode(type, from: jsonData)
    }
}

extension KeyedDecodingContainer {
    #if DEBUG
    #else
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        return nil
    }
    #endif
}
```
## 特殊处理
### 字段设置默认值或者缺少字段处理
[使用 Property Wrapper 为 Codable 解码设定默认值](https://onevcat.com/2020/11/codable-default/#%E6%95%B4%E7%90%86-default-%E7%B1%BB%E5%9E%8B)
[如何优雅的使用Swift Codable协议](https://www.jianshu.com/p/d20607966efe)
参考以上两篇博客，实现了一个简单的设置默认值。
```swift
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
```

简单使用;
```swift
class People: Codable {
    @StringAsEmpty var name: String // 默认值为 "" 不存在字段自动赋值为 ""
    @IntAsZero var age: Int // 默认值为 0
    @Default<Bool.False> var isMan: Bool // 为空时 默认值 false
    let address: String
}
```
[本文源码](https://download.csdn.net/download/CuiXg/16096796)


