//
//  Presenter.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 20/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

/// Логика презентера
protocol FlickrPresentationLogic {
    func presentImage(response: Flickr.ImageModel.Response)
    func presentImageFromMemory(response: Flickr.ImageModelFromMemory.Response)
}

class Presenter: FlickrPresentationLogic {
    weak var viewController: FlickrDisplayLogic?
    
    /// Отображает полученные картинки
    func presentImage(response: Flickr.ImageModel.Response) {
        let viewModel = Flickr.ImageModel.ViewModel(images: response.images)
        viewController?.displayImages(viewModel: viewModel)
    }
    
    /// Отображает картинки, полученные из памяти (а также номер последней загруженной страницы и запрос)
    func presentImageFromMemory(response: Flickr.ImageModelFromMemory.Response) {
        let viewModel = Flickr.ImageModelFromMemory.ViewModel(images: response.images, searchingString: response.searchingString, page: response.page)
        viewController?.displayImagesFromMemory(viewModel: viewModel)
    }
    
}
