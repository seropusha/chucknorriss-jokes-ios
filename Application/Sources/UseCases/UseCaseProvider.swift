//
//  UseCaseProvider.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public protocol HasJokeUseCase {
    var joke: JokeUseCase { get }
}

public typealias UseCases = HasJokeUseCase

public protocol UseCasesProvider: UseCases {}
