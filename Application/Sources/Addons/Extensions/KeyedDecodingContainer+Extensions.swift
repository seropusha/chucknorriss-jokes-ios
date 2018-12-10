//
//  sad.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    public func decode<R, T>(_ type: R.Type, forKey codingKey: Key, mapping: (R) throws -> T) throws -> T where R: Decodable {
        let decoded = try decode(R.self, forKey: codingKey)
        return try mapping(decoded)
    }
    
    public func decode<R, T, M: Mapper>(_ type: R.Type, forKey codingKey: Key, mapping: M) throws -> T
        where M.Input == R, M.Output == T, R: Decodable {
            let decoded = try decode(R.self, forKey: codingKey)
            return try mapping.map(decoded)
    }
}
