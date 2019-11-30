//
//  Router.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 22/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

@objc protocol FlickrRoutingLogic {
    func setupImageViewController(_ image: UIImage, _ description: String)
}

class Router: FlickrRoutingLogic {
    
    weak var viewController: (UIViewController & FlickrDisplayLogic)?
    
    // настройка представления с крупной картинкой и описанием
    func setupImageViewController(_ image: UIImage, _ description: String) {
        let imageViewController = UIViewController()
        imageViewController.view.backgroundColor = .white
        
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 100,
                                                  width: imageViewController.view.frame.width,
                                                  height: imageViewController.view.frame.height*2/3))
        imageView.image = image
        imageViewController.view.addSubview(imageView)
    
        let descriptionLabel = UILabel(frame: CGRect(x: 0,
                                                     y: imageView.frame.maxY,
                                                     width: imageViewController.view.frame.width,
                                                     height: 100))
        descriptionLabel.text = description
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        imageViewController.view.addSubview(descriptionLabel)
        
        viewController?.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
}
