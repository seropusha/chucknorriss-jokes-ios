//
//  ImageSourceMapper.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import Foundation

public final class ImageSourceMapper: Mapper {
    
    private let baseURL: URL?
    
    public init(baseURL: URL? = nil) {
        self.baseURL = baseURL
    }
    
    public func map(_ input: String) throws -> ImageSource {
        guard let imageSource = URL(string: input, relativeTo: baseURL).flatMap(ImageSource.url) else {
            throw ApplicationError.customMessage("Couldn't resolve image at path `\(input)`")
        }
        return imageSource
    }
}
