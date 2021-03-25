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
