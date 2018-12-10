//
//  Environment.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public protocol Environment {
    var debug: Bool { get }
    var baseURL: URL { get }
}

public enum ApplicationEnvironment {
        case develop
        case production
        
        #if PRODUCTION
        static let current: ApplicationEnvironment = production
        #elseif DEVELOPMENT
        static let current: ApplicationEnvironment = develop
        #endif
}

extension ApplicationEnvironment: Environment {
    public var debug: Bool { return Configuration.current == .debug }
    public var baseURL: URL { return URL(string: "https://api.chucknorris.io/")! }
}

