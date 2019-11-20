//
//  Models.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 20/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

enum Flickr {
    // MARK: Use cases
    
    enum ImageModel {
        struct Request {
            var searchingString: String
            var page: Int
        }
        struct Response {
            var images: [ImageViewModel]
        }
        struct ViewModel {
            var images: [ImageViewModel]
        }
    }
}

struct ImageModel {
    let path: String
    let description: String
}

struct ImageViewModel {
    let description: String
    let image: UIImage
}
