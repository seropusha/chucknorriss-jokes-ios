//
//  URLMapper.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public final class URLMapper: Mapper {
    
    public func map(_ input: String) throws -> URL {
        guard let url = URL(string: input) else {
            throw ApplicationError.customMessage("Couldn't resolve URL at path `\(input)`")
        }
        return url
    }
}
