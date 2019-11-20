//
//  Interactor.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

/// Логика интерактора
protocol FlickrBusinessLogic {
    func loadImagesData(request: Flickr.ImageModel.Request)
}

class Interactor: FlickrBusinessLogic {

    var presenter: FlickrPresentationLogic?
    var worker: Worker?
    var images = [ImageViewModel]() // массив с изображениями и их описанием
    var flickrData = [ImageModel]() { // массив с url
        didSet {
            loadImages() // как только обновился массив данных, загружаем изображения
        }
    }
    
    /// Загружаем данные с api
    func loadImagesData(request: Flickr.ImageModel.Request) {
        loadImageList(by: request.searchingString, at: request.page) { [weak self] models in
            if request.page == 1 { // если загружаем первую страницу, удаляем все предыдущие изображения
                self?.images.removeAll()
            }
            self?.flickrData = models
        }
    }
    
    
    /// Загружает изображения и говорит презениру отобразить их
    private func loadImages() {
        let group = DispatchGroup()
        for model in self.flickrData {
            group.enter()
            self.loadImage(at: model.path) { image in
                guard let image = image else {
                    group.leave()
                    return
                }
                let viewModel = ImageViewModel(description: model.description, image: image)
                self.images.append(viewModel)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            let response = Flickr.ImageModel.Response(images: self.images)
            self.presenter?.presentImage(response: response)
        }
    }
    
    
    /// Загружает данные с flickr
    ///
    /// - Parameters:
    ///   - searchString: искомое слово
    ///   - page: загружаемая страница
    private func loadImageList(by searchString: String, at page: Int = 1,completion: @escaping([ImageModel]) -> Void) {
        
        let url = API.searchPath(text: searchString, extras: "url_m", page: page)
        worker?.getData(at: url, parameters: nil) { data in
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
    
    /// Загружаем изображения
    private func loadImage(at path: String, completion: @escaping (UIImage?) -> Void) {
        worker?.getData(at: path, parameters: nil) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
}
