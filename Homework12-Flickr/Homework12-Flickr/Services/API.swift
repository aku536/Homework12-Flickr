//
//  API.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class API {
    
    private static let apiKey = "dab4052df3cc23ed39745a8cca163e0a"
    private static let baseURL = "https://www.flickr.com/services/rest"
    
    static func searchPath(text: String, extras: String, page: Int = 1) -> URL {
        guard var components = URLComponents(string: baseURL) else {
            return URL(string: baseURL)!
        }
        
        
        let methodItem = URLQueryItem(name: "method", value: "flickr.photos.search")
        let apiKeyItem = URLQueryItem(name: "api_key", value: apiKey)
        let textItem = URLQueryItem(name: "text", value: text)
        let extrasItem = URLQueryItem(name: "extras", value: extras)
        let perPageItem = URLQueryItem(name: "per_page", value: "25")
        let pageItem = URLQueryItem(name: "page", value: String(page))
        let formatItem = URLQueryItem(name: "format", value: "json")
        let nojsoncallbackItem = URLQueryItem(name: "nojsoncallback", value: "1")
        
        components.queryItems = [methodItem, apiKeyItem, textItem, extrasItem, perPageItem, pageItem, formatItem, nojsoncallbackItem]
        
        return components.url!
    }
    
}
