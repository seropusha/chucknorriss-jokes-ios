//
//  Database.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import RealmSwift
import ReactiveSwift
import Result

extension Database {
    static func setup() -> SignalProducer<Void, ApplicationError> {
        return SignalProducer { observer, _ in
            Realm.Configuration.defaultConfiguration = .init(schemaVersion: 1, migrationBlock: Database.migrate)
            do {
                _ = try Realm()
                observer.send(value: ())
                observer.sendCompleted()
            } catch let error {
                observer.send(error: .database(.cantSetup(error)))
            }
        }
    }
    
    private static func migrate(_ migration: Migration, _ oldSchemaVersion: UInt64) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if oldSchemaVersion < 1 {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    }
}

final class Database {
    
    // MARK: - Properties
    
    private let thread: BackgroundWorker
    
    var scheduler: DateScheduler { return thread }
    
    // MARK: - Lifecycle
    
    public init(thread: BackgroundWorker = BackgroundWorker(name: "\(Database.self)")) {
        self.thread = thread
    }
    
    // MARK: - Actions
    
    func perform<Output>(on queue: DispatchQueue? = nil,
                         _ action: @escaping (Realm) throws -> Output) -> SignalProducer<Output, ApplicationError> {
        return SignalProducer { [queue, thread] observer, _ in
            let action = {
                do {
                    let realm = try Realm()
                    observer.send(value: try action(realm))
                    observer.sendCompleted()
                } catch let error {
                    observer.send(error: .database(.runtime(error)))
                }
            }
            if let queue = queue {
                queue.async(execute: action)
            } else {
                thread.perform(action: action)
            }
        }
    }
    
    func write<Output>(on queue: DispatchQueue? = nil,
                       _ action: @escaping (Realm) throws -> Output) -> SignalProducer<Output, ApplicationError> {
        return perform(on: queue) {
            $0.beginWrite()
            let output = try action($0)
            try $0.commitWrite()
            return output
        }
    }
    
    func create<T: Object>(update: Bool = true, _ builder: @escaping (inout T) throws -> Void) -> SignalProducer<T, ApplicationError> {
        return perform { realm in
            var object = T()
            try builder(&object)
            try realm.write {
                realm.add(object, update: update)
            }
            return object
        }
    }
}

extension Database {
    func clear() -> SignalProducer<Void, ApplicationError> {
        return write{ realm in
            realm.deleteAll()
            }
            .map{_ in}
    }
}
