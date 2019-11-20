//
//  ViewController.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

/// Логика viewController
protocol FlickrDisplayLogic: class {
    func displayImages(viewModel: Flickr.ImageModel.ViewModel)
}

class ViewController: UIViewController, FlickrDisplayLogic {
    
    private let tableView = UITableView()
    let spinner = UIActivityIndicatorView(style: .gray)
    let spinnerBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let reuseId = "UITableViewCellreuseId"
    var searchingString = "" // слово для поиска
    var page = 1 // страница, загружаемая с api
    
    var interactor: FlickrBusinessLogic?
    
    var images = [ImageViewModel]()
    
    let operationQueue: OperationQueue = {
       let opQueue = OperationQueue()
        opQueue.isSuspended = true
        opQueue.maxConcurrentOperationCount = 1
        opQueue.name = "com.OperationQueue"
        return opQueue
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.backgroundColor = .white
        
        let textField = UITextField()
        let textFieldHeight: CGFloat = 50
        textField.frame = CGRect(x: 20, y: 50, width: view.frame.width-50, height: textFieldHeight)
        textField.backgroundColor = .white
        textField.placeholder = "🔍Поиск фото"
        textField.addTarget(self, action: #selector(didChangedText), for: .editingChanged)
        view.addSubview(textField)
        
        
        tableView.frame = CGRect(x: 0,
                                 y: textField.frame.maxY,
                                 width: view.frame.width,
                                 height: view.frame.height - textFieldHeight)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        spinnerBackgroundView.center = view.center
        spinnerBackgroundView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        spinnerBackgroundView.isHidden = true
        view.addSubview(spinnerBackgroundView)
        
        spinner.center = view.center
        view.addSubview(spinner)
    }
    
    
    /// Когда вводится текст, отменяем все операции и добавляем загрузку по ключевому слову через секунду
    ///
    /// - Parameter sender: UITextField
    @objc private func didChangedText(_ sender: UITextField) {
        operationQueue.isSuspended = true
        operationQueue.cancelAllOperations()
        guard (sender.text != nil) else {
            return
        }
        searchingString = sender.text!
        operationQueue.addOperation {
            self.loadImages(by: self.searchingString)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.spinnerBackgroundView.isHidden = false
            self.spinner.startAnimating()
            self.operationQueue.isSuspended = false
        }
    }

    /// Создаем запрос к интерактору поиск по ключевому слову и отображение первой странице
    ///
    /// - Parameter searchingString: слово для поиска
    private func loadImages(by searchingString: String) {
        let request = Flickr.ImageModel.Request(searchingString: searchingString, page: 1)
        interactor?.loadImagesData(request: request)
    }
    
    func displayImages(viewModel: Flickr.ImageModel.ViewModel) {
        images = viewModel.images
        spinnerBackgroundView.isHidden = true
        spinner.stopAnimating()
        tableView.reloadData()
    }
    
}
