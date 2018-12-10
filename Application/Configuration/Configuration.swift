//
//  Configuration.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

enum Configuration {
    case debug
    case release
    
    #if DEBUG
    static let current = debug
    #else
    static let current = release
    #endif
}
