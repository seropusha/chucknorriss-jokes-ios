//
//  JokeUseCase.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol JokeUseCase {
    func getRandomJoke(category: Category?) -> SignalProducer<Joke, ApplicationError>
    func getCategories() -> SignalProducer<[Category], ApplicationError>
    func searchJoke(_ query: String) -> SignalProducer<JokeSearch, ApplicationError>
}
