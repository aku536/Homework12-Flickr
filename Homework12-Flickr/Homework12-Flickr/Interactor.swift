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
    func dowloadImagesData(request: Flickr.ImageModel.Request)
    func loadFromMemory(request: Flickr.ImageModelFromMemory.Request)
}

class Interactor: FlickrBusinessLogic {

    var presenter: FlickrPresentationLogic?
    var networkWorker: NetworkWorker?
    var coreDataWorker: CoreDataWorker?
    var images = [ImageViewModel]() // массив с изображениями и их описанием
    var flickrData = [ImageModel]() { // массив с url
        didSet {
            downloadImages() // как только обновился массив данных, загружаем изображения
        }
    }
    
    /// Загружаем данные с api, сохраняем в память номер загружаемой страницы и запрос
    func dowloadImagesData(request: Flickr.ImageModel.Request) {
        save(searchingString: request.searchingString, page: request.page)
        downloadImageList(by: request.searchingString, at: request.page) { [weak self] models in
            if request.page == 1 { // если загружаем первую страницу, удаляем все предыдущие изображения
                self?.images.removeAll()
                self?.coreDataWorker?.clearImageData()
            }
            self?.flickrData = models
        }
    }
    
    /// Загружаем изображения, последний поисковый запрос и страницу из пямяти
    func loadFromMemory(request: Flickr.ImageModelFromMemory.Request) {
        guard let imagesFromMemory = coreDataWorker?.loadFromMemory() else {
            return
        }
        for imageData in imagesFromMemory {
            let description = imageData.value(forKey: "imageDescription") as? String ?? ""
            guard let imageData = imageData.value(forKey: "imageData") as? Data,
                    let image = UIImage(data: imageData) else {
                return
            }
            let imageModel = ImageViewModel(description: description, image: image)
            images.append(imageModel)
        }
        
        guard let request = coreDataWorker?.loadLastRequest() else {
            return
        }
        
        let response = Flickr.ImageModelFromMemory.Response(images: images, searchingString: request.0, page: request.1)
        presenter?.presentImageFromMemory(response: response)
    }
    
    //  MARK: - Private methods
    
    /// Сохраняет изображение и его описание в CoreData
    ///
    /// - Parameters:
    ///   - imageData: изображение в бинарном виде
    ///   - imageDescription: описание изображение
    private func save(imageData: Data, imageDescription: String) {
        CoreDataWorker.shared.persistentContainer.performBackgroundTask { (context) in
            let objectToSave = MOImageData(context: context)
            objectToSave.imageData = imageData
            objectToSave.imageDescription = imageDescription
            try! context.save()
        }
    }
    
    /// Сохраняет последний поисковый запрос и последнюю прогруженную страницу
    ///
    /// - Parameters:
    ///   - searchingString: последний поисковый запрос
    ///   - page: последняя прогруженная страница
    private func save(searchingString: String, page: Int) {
        coreDataWorker?.clearLastRequest()
        coreDataWorker?.persistentContainer.performBackgroundTask { (context) in
            let stringToSave = MORequest(context: context)
            stringToSave.searchingString = searchingString
            stringToSave.page = Int16(page)
            try! context.save()
        }
    }
    
    /// Загружает изображения из сети, сохраняет в память и говорит презентеру отобразить их
    private func downloadImages() {
        let group = DispatchGroup()
        for model in self.flickrData {
            group.enter()
            self.downloadImage(at: model.path) { image in
                guard let image = image else {
                    group.leave()
                    return
                }
                let viewModel = ImageViewModel(description: model.description, image: image)
                guard let imageData = viewModel.image.jpegData(compressionQuality: 1) else {
                    return
                }
                DispatchQueue.global(qos: .background).async {
                    self.save(imageData: imageData, imageDescription: model.description)
                }
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
    private func downloadImageList(by searchString: String, at page: Int = 1,completion: @escaping([ImageModel]) -> Void) {
        
        let url = API.searchPath(text: searchString, extras: "url_m", page: page)
        networkWorker?.getData(at: url, parameters: nil) { data in
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
    
    /// Загружаем изображения из сети по полученным ссылкам
    private func downloadImage(at path: String, completion: @escaping (UIImage?) -> Void) {
        networkWorker?.getData(at: path, parameters: nil) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
}
