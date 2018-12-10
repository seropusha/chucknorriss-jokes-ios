//
//  DBCategory.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
final class DBCategory: Object {
    dynamic var name: String = ""
    
    override class func primaryKey() -> String? { return #keyPath(name) }
}

extension DBCategory {
    func asDomain() -> String {
        return name
    }
}

extension Category {
    func asDB() -> DBCategory {
        let model = DBCategory()
        model.name = self
        return model
    }
}
