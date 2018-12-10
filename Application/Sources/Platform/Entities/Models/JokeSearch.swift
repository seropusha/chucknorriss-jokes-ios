//
//  JokeSearch.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public struct JokeSearch {
    let total: Int
    let jokes: [Joke]
    var query: String = ""
}

extension JokeSearch: Decodable {
    private enum CodingKeys: String, CodingKey {
        case total, jokes = "result"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        jokes = try container.decode([Joke].self, forKey: .jokes)
    }
}
