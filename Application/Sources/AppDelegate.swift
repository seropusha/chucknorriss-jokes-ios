//
//  AppDelegate.swift
//  Application
//
//  Created by Sergey Navka on 12/4/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    private let configuration = ApplicationEnvironment.current
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    private lazy var platform = Platform(configuration: configuration)
    private lazy var appCoordinator = AppCoordinator(window: window!, useCases: self.platform)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.show()
        return true
    }
}

