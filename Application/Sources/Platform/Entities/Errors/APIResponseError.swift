//
//  APIResponseError.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public struct APIResponseError: Decodable, LocalizedError {
    public let code: Int
    public let message: String
    public let errors: [APIError]
    
    public var errorDescription: String? {
        return message
    }
    
    public init(code: Int,
                message: String,
                errors: [APIError]) {
        self.code = code
        self.message = message
        self.errors = errors
    }
}

public struct APIError: Decodable, LocalizedError {
    enum CodingKeys: String, CodingKey {
        case message
        case key
    }
    
    public let key: String?
    public let message: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.key = try container.decodeIfPresent(String.self, forKey: .key)
    }
    
    public init(key: String, message: String) {
        self.key = key
        self.message = message
    }
}
