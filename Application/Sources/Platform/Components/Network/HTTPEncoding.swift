//
//  HTTPEncoding.swift
//  Application
//
//  Created by Sergey Navka on 12/5/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public protocol EncoderProtocol {
    associatedtype ParameterType
    associatedtype EncodedType
    var contentType: String { get }
    func encode(parameters: ParameterType) throws -> EncodedType
}

struct DataEncoder: EncoderProtocol {
    typealias ParameterType = [String : Any]
    typealias EncodedType = Data
    public var contentType: String { return "application/json" }
    
    public func encode(parameters: ParameterType) throws -> EncodedType {
        guard JSONSerialization.isValidJSONObject(parameters)
            else { throw ApplicationError.invalidJSON }
        let data = try JSONSerialization.data(withJSONObject: parameters)
        return data
    }
}

struct URLEncoder: EncoderProtocol {
    typealias ParameterType = [String : String]
    typealias EncodedType = String
    public var contentType: String { return "application/x-www-form-urlencoded" }
    
    public func encode(parameters: ParameterType) throws -> EncodedType {
        var components = URLComponents()
        components.queryItems = parameters.reduce(into: [URLQueryItem]()) {
            $0.append(URLQueryItem(name: $1.key, value: $1.value))
        }
        return components.string ?? ""
    }
}
