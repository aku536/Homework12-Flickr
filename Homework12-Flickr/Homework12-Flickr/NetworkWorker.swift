//
//  NetworkService.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

/// Загрузка данных из интернета
class NetworkWorker {
    let session: URLSession
    
    init() {
        self.session = SessionFactory().createDefaultSession()
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
