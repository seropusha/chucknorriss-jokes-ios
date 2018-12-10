//
//  Joke.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public typealias Category = String

public struct Joke {
    public let id: String
    public let category: [Category]
    public let icon: ImageSource?
    public let jokeURL: URL
    public let jokeText: String
}

// MARK: - Decodable
extension Joke: Decodable {
    private enum CodingKeys: String, CodingKey {
        case category, icon = "icon_url", id, jokeURL = "url", jokeText = "value"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decodeIfPresent([Category].self, forKey: .category) ?? []
        icon = try? container.decode(String.self, forKey: .icon, mapping: ImageSourceMapper())
        id = try container.decode(String.self, forKey: .id)
        jokeURL = try container.decode(String.self, forKey: .jokeURL, mapping: URLMapper())
        jokeText = try container.decode(String.self, forKey: .jokeText)
    }
}
