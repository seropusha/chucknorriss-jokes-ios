//
//  Network+Reactive.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import ReactiveSwift
import Result

extension ApplicationError {
    init(error: Error) {
        switch error {
        case let domainError as ApplicationError:
            self = domainError
        default:
            self = .underlying(error)
        }
    }
}

extension SignalProducerProtocol {
    func mapToDomainError() -> SignalProducer<Value, ApplicationError> {
        return producer.mapError(ApplicationError.init(error:))
    }
}

extension SignalProducerProtocol where Error == ApplicationError {
    func attemptMap<U>(_ transform: @escaping (Value) throws -> U) -> SignalProducer<U, Error> {
        return producer.attemptMap {
            do {
                return .success(try transform($0))
            } catch let domainError as ApplicationError {
                return .failure(domainError)
            } catch let error {
                return .failure(.underlying(error))
            }
        }
    }
    
    func attempt(_ action: @escaping (Value) throws -> Void) -> SignalProducer<Value, Error> {
        return producer.attempt { value -> Result<(), Error> in
            do {
                try action(value)
                return .success(())
            } catch let domainError as ApplicationError {
                return .failure(domainError)
            } catch let error {
                return .failure(.underlying(error))
            }
        }
    }
}
