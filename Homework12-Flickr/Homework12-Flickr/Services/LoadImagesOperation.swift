//
//  LoadImagesOperation.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 30/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation

// Команда
class LoadImagesOperation: Operation {
    
    private var interactor: FlickrBusinessLogic
    private var searchingString: String
    
    init(interactor: FlickrBusinessLogic, searchingString: String) {
        self.interactor = interactor
        self.searchingString = searchingString
    }
    
    override func main() {
        guard !self.isCancelled else {
            return
        }
        loadImages(by: searchingString)
    }
    
    /// Создаем запрос к интерактору поиск по ключевому слову и отображение первой странице
    ///
    /// - Parameter searchingString: слово для поиска
    private func loadImages(by searchingString: String) {
        let request = Flickr.ImageModel.Request(searchingString: searchingString, page: 1)
        interactor.dowloadImagesData(request: request)
    }
    
}
