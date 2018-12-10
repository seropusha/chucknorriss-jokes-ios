//
//  ApplicationError.swift
//  Application
//
//  Created by Sergey Navka on 12/5/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public enum ApplicationError: Error {
    case api(APIResponseError)
    case decode(Error)
    case invalidJSON
    case undefined
    case urlSession(Error)
    case database(DatabaseError)
    case customMessage(String)
    case underlying(Error)
}

public enum DatabaseError: Error {
    case cantSetup(Error)
    case runtime(Error)
    var localizedDescription: String {
        switch self {
        case let .cantSetup(error): return error.localizedDescription
        case let .runtime(error): return error.localizedDescription
        }
    }
}

extension ApplicationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .decode(error): return String(describing: error)
        case let .urlSession(error): return error.localizedDescription
        case .undefined: return "UNDEFINED"
        case .invalidJSON: return "Invalid JSON"
        case let .api(error): return  error.localizedDescription
        case let .database(error): return error.localizedDescription
        case let .customMessage(message): return message
        case let .underlying(error): return error.localizedDescription
        }
    }
}
