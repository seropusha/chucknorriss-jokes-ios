//
//  NetworkProvider.swift
//  Application
//
//  Created by Sergey Navka on 12/9/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation
import ReactiveSwift

public typealias RawResponse = Data

open class NetworkProvider<T: TargetType> {
    
    let baseURL: URL
    
    public init(_ baseURL: URL) {
        self.baseURL = baseURL
    }
    
    open func request(_ target: T) -> SignalProducer<RawResponse, ApplicationError> {
        return SignalProducer() { [baseURL, parseApiError] observer, lifetime in
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration,
                                     delegate: nil,
                                     delegateQueue: nil)
            let request = URLRequest(url: baseURL.appendingPathComponent(target.path),
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: target.requestTimeout)
            let task = session.dataTask(with: request) { data, urlResponse, error in
                if let error = error {
                    observer.send(error: .urlSession(error))
                } else if let apiError = parseApiError(data, urlResponse as? HTTPURLResponse) {
                    observer.send(error: apiError)
                } else if let data = data {
                    observer.send(value: data)
                    observer.sendCompleted()
                } else {
                    observer.send(error: .undefined)
                }
            }
            task.resume()
            lifetime.observeEnded { task.cancel() }
        }
    }
    
    /**
     Parsing API error
     */
    private func parseApiError(with data: Data?, httpResponse: HTTPURLResponse?) -> ApplicationError? {
        guard let data = data,
              let httpResponse = httpResponse else { return ApplicationError.undefined }
        if 200...299 ~= httpResponse.statusCode { return nil } // success codes
        
        do {
            let apiResponeError = try JSONDecoder().decode(APIResponseError.self, from: data)
            return ApplicationError.api(apiResponeError)
        } catch let error {
            return ApplicationError.decode(error)
        }
    }
}
