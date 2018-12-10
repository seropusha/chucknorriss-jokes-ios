//
//  Mapper.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

public protocol Mapper {
    associatedtype Input
    associatedtype Output
    func map(_ input: Input) throws -> Output
}
