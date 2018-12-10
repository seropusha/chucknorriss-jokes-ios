//
//  DBJokeSearch.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
final class DBJokeSearch: Object {
    dynamic var query: String = ""
    var jokes = List<DBJoke>()
    dynamic var total: Int = 0
    
    override class func primaryKey() -> String? { return #keyPath(query) }
}

extension DBJokeSearch {
    func asDomain() -> JokeSearch {
        return .init(total: total,
                     jokes: jokes.map({ $0.asDomain() }),
                     query: query)
    }
}

extension JokeSearch {
    func asDB() -> DBJokeSearch {
        let model = DBJokeSearch()
        model.query = query
        model.total = total
        model.jokes.append(objectsIn: jokes.map({ $0.asDB() }))
        return model
    }
}
