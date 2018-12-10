//
//  TargetType.swift
//  Application
//
//  Created by Sergey Navka on 12/5/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public enum HTTPMethod {
    case get
    case post
}

public enum EncodingDataType {
    case url
    case body
}

public enum Task {
    case requestPlain
    case requestEncodable(Encodable, encoder: JSONEncoder)
    case requestParameters(parameters: [String: Any], encodingType: EncodingDataType)
}

public protocol TargetType {
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var needsAuthorization: Bool { get }
    var requestTimeout: TimeInterval { get }
}

extension TargetType {
    var method: HTTPMethod { return .get }
    var task: Task { return .requestPlain }
    var needsAuthorization: Bool { return false }
    var requestTimeout: TimeInterval { return 30.0 }
}
