//
//  Interactor.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

protocol InteractorInput {
    func loadImageList(by searchngString: String, completion: @escaping([ImageModel]) -> Void)
    func loadImage(at path: String, completion: @escaping (UIImage?) -> Void)
}

class Interactor: InteractorInput {
    
    let networkService: NetworkServiceInput
    
    init(networkService: NetworkServiceInput) {
        self.networkService = networkService
    }
    
    func loadImageList(by searchString: String, completion: @escaping([ImageModel]) -> Void) {
        let url = API.searchPath(text: searchString, extras: "url_m")
        networkService.getData(at: url, parameters: nil) { data in
            guard let data = data else {
                completion([])
                return
            }
            let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: .init()) as? Dictionary<String, Any>
            guard let response = responseDictionary,
                let photosDictionary = response["photos"] as? Dictionary<String, Any>,
                let photosArray = photosDictionary["photo"] as? [[String: Any]] else { return }
            
            let model = photosArray.map { (object) -> ImageModel in
                let urlString = object["url_m"] as? String ?? ""
                let title = object["title"] as? String ?? ""
                return ImageModel(path: urlString, description: title)
            }
            completion(model)
        }
    }
    
    func loadImage(at path: String, completion: @escaping (UIImage?) -> Void) {
        networkService.getData(at: path, parameters: nil) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
}
