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
    var flickrData: [ImageModel] { get set }
}

class LoadOperation: Operation {
    private let interactor: InteractorInput
    private var searchingString: String?
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
            delegate.flickrData = models
        }
    }
    
}
