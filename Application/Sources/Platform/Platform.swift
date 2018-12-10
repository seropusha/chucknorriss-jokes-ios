//
//  Platform.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import UIKit

struct Context {
    let configuration: ApplicationEnvironment
    let network: Network
    let database: Database
}

final public class Platform: UseCasesProvider {
    
    // MARK: - UseCases
    
    public lazy var joke: JokeUseCase = JokeService(context: context)
    
    // MARK: - Services
    
    private let context: Context
    
    // MARK: - Lifecycle
    
    public init(configuration: ApplicationEnvironment) {
        context = Context(
            configuration: configuration,
            network: Network(configuration: configuration),
            database: Database()
        )
    }
}
