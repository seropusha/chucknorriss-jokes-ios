//
//  JokeService.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import ReactiveSwift

open class JokeService: JokeUseCase {
    
    let database: Database
    let network: NetworkProvider<API.JokeProvider>

    init(context: Context) {
        database = context.database
        network = context.network.makeProdider()
    }
    
    //MAKR: - JokeUseCase
    
    public func getRandomJoke(category: Category?) -> SignalProducer<Joke, ApplicationError> {
        return network.request(.randomFromCategory(category))
            .decode(Joke.self)
            .flatMap(.latest) { [database] joke in
                return database.write({ realm in
                    let dbModel = joke.asDB()
                    realm.add(dbModel, update: true)
                    return joke
                })
            }
    }
    
    public func getCategories() -> SignalProducer<[Category], ApplicationError> {
        return network.request(.getCategories)
            .decode([Category].self)
            .flatMap(.latest) {  [database] categories in
                return database.write() { realm in
                    let dbModels = categories.map({ $0.asDB() })
                    realm.add(dbModels, update: true)
                    return categories
                }
            }
    }
    
    public func searchJoke(_ query: String) -> SignalProducer<JokeSearch, ApplicationError> {
        return network.request(.search(query))
            .debounce(0.3, on: QueueScheduler.main)
            .decode(JokeSearch.self)
            .flatMap(.latest){ [database] searchModel in
                return database.write() { realm in
                    let dbModel = searchModel.asDB()
                    realm.add(dbModel, update: true)
                    return searchModel
                }
        }
    }

}
