//
//  AppCoordinator.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

extension AppCoordinator {
    enum Flow {
        case randomJoke //(RandomJokeCoordinator)
        case searchJokes //(someCoordinator)
    }
}

final class AppCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    private let useCases: UseCasesProvider
    
    var flow: Flow! {
        didSet {
            guard oldValue != flow else { return }
            update(from: oldValue, to: flow)
        }
    }
    
    // MARK: - Lifecycle
    
    init(window: UIWindow = UIWindow(frame: UIScreen.main.bounds), useCases: UseCasesProvider) {
        self.window = window
        self.useCases = useCases
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        // TOOD: logic
    }
    
    private func update(from oldFlow: Flow?, to newFlow: Flow) {
        UIApplication.shared.resignFirstResponder()
        
        switch oldFlow {
        case let .some(.randomJoke): break//coordinator.stop()
        case let .some(.searchJokes): break//coordinator.stop()
        default: break
        }
        
        switch newFlow {
        case .randomJoke:
                break
        case let .searchJokes: break
        }
    }
    
    // MARK: - Actions
    
    func show() {
        window.makeKeyAndVisible()
    }
    
    func showRandomJoke() {
        flow = .randomJoke
    }
    
    func showUserSetup() {
        flow = .searchJokes
    }
}
