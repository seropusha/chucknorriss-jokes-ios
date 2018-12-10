//
//  Jokes.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

extension API {
    enum JokeProvider: TargetType {
        case randomFromCategory(String?)
        case getCategories
        case search(String)

        var path: String {
            switch self {
            case .randomFromCategory: return "jokes/random"
            case .getCategories: return "jokes/categories"
            case .search: return "jokes/search"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .randomFromCategory: return .get
            case .getCategories: return .get
            case .search: return .get
            }
        }
        
        var task: Task {
            switch self {
            case let .randomFromCategory(category):
                guard let category = category else { return .requestPlain }
                return .requestParameters(parameters: ["category": category],
                                          encodingType: .url)
            case .getCategories: return .requestPlain
            case let .search(query):
                return .requestParameters(parameters: ["query": query],
                                          encodingType: .url)
            }
        }
    }
}
