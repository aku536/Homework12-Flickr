//
//  LoadOperation.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 18/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

protocol LoadOperationDelegate {
    var images: [ImageViewModel] { get set }
    var flickrImages: [ImageModel] { get set }
}

class LoadOperation: Operation {
    let interactor: InteractorInput
    var searchingString: String?
    var delegate: LoadOperationDelegate?
    static var page = 1
    
    init(interactor: InteractorInput, searchingString: String?) {
        self.searchingString = searchingString
        self.interactor = interactor
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Метод не реализован")
    }
    
    override func main() {
        if self.isCancelled {
            return
        }

        loadData(at: LoadOperation.page)
        
        if self.isCancelled {
            return
        }
        
    }
    
    private func loadData(at page: Int = 1) {
        guard (searchingString != nil), var delegate = self.delegate else {
            return
        }
        interactor.loadImageList(by: searchingString!, at: page) { (models) in
            delegate.flickrImages = models
        }
    }
    
    private func loadImages() {
        guard var delegate = self.delegate else {
            return
        }
        for image in delegate.flickrImages {
            if self.isCancelled {
                return
            }
            let imagePath = image.path
            self.interactor.loadImage(at: imagePath) { [weak self] image in
                guard let self = self else {
                    return
                }
                if self.isCancelled {
                    return
                }
                if let image = image {
                    let model = ImageViewModel(description: image.description, image: image)
                    delegate.images.append(model)
                }
            }
        }
    }
    
}
