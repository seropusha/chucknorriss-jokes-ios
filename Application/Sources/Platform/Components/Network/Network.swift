//
//  Network.swift
//  Application
//
//  Created by Sergey Navka on 12/4/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import ReactiveSwift

open class Network {
    
    let baseURL: URL
    
    public init(configuration: ApplicationEnvironment) {
        self.baseURL = configuration.baseURL
    }
    
    public func makeProdider<T: TargetType>() -> NetworkProvider<T> {
        return .init(baseURL)
    }
}

extension SignalProducerConvertible where Value == RawResponse, Error == ApplicationError {
    func decode<T: Decodable>(_ type: T.Type) -> SignalProducer<T, Error> {
        return producer.attemptMap { try $0.map(T.self) }
    }
}

extension RawResponse {
    func map<T: Decodable>(_ type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        do {
            return try decoder.decode(type, from: self)
        } catch let error {
            throw ApplicationError.decode(error)
        }
    }
}
