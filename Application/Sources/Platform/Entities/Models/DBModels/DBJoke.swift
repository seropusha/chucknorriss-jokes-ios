//
//  DBJoke.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
final class DBJoke: Object {
    dynamic var id: String = ""
    dynamic var categories = List<DBCategory>()
    dynamic var iconURLString: String?
    dynamic var jokeURLString: String = ""
    dynamic var jokeText: String = ""
    
    override class func primaryKey() -> String? { return #keyPath(id) }
}

extension DBJoke {
    func asDomain() -> Joke {        
        return .init(id: id,
                     categories: categories.map({ $0.asDomain() }),
                     icon: iconURLString.flatMap({ ImageSource.url(URL(string: $0)!) }),
                     jokeURL: URL(string: jokeURLString)!,
                     jokeText: jokeText)
    }
}

extension Joke {
    func asDB() -> DBJoke {
        let model = DBJoke()
        model.id = id
        model.categories.append(objectsIn: categories.map({ $0.asDB() }))
        model.iconURLString = icon?.url?.absoluteString
        model.jokeURLString = jokeURL.absoluteString
        model.jokeText = jokeText
        return model
    }
}


