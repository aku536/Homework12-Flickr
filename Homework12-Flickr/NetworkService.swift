//
//  NetworkService.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

protocol NetworkServiceInput {
    func getData(at path: String, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void)
    func getData(at url: URL, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void)
}

class NetworkService: NetworkServiceInput {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getData(at path: String, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: path) else {
            completion(nil)
            return
        }
        let dataTask = session.dataTask(with: url) { data, _, _ in
            completion(data)
        }
        dataTask.resume()
    }
    
    func getData(at url: URL, parameters: [AnyHashable: Any]?, completion: @escaping (Data?) -> Void) {
        let dataTask = session.dataTask(with: url) { data, _, _ in
            completion(data)
        }
        dataTask.resume()
    }
    
}
