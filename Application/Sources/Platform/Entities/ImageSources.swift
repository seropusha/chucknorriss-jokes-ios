//
//  ImageSources.swift
//  Application
//
//  Created by Sergey Navka on 12/10/18.
//  Copyright © 2018 Navka Sergey. All rights reserved.
//

import UIKit

public enum ImageSource {
    case url(URL)
    case image(UIImage)
    
    public var url: URL? {
        switch self {
        case let .url(url): return url
        default: return nil
        }
    }
    
    public var image: UIImage? {
        switch self {
        case let .image(image): return image
        default: return nil
        }
    }
    
    // MARK: - Lifecycle
    
    public init?(data: Data?) {
        guard let data = data, let imageSource = UIImage(data: data).flatMap(ImageSource.image) else { return nil }
        self = imageSource
    }
}
