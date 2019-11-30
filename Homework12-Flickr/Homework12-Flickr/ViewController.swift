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
    func displayImagesFromMemory(viewModel: Flickr.ImageModelFromMemory.ViewModel)
}

class ViewController: UIViewController, FlickrDisplayLogic {
    var router: FlickrRoutingLogic?
    var interactor: FlickrBusinessLogic?
    
    private let tableView = UITableView()
    let spinner = UIActivityIndicatorView(style: .gray)
    let spinnerBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let reuseId = "UITableViewCellreuseId"

    var searchingString = "" // слово для поиска
    var page = 1 // страница, загружаемая с api
    var images = [ImageViewModel]() // массив изображений для отображения
    
    // очередь для поиска с задержкой
    let operationQueue: OperationQueue = {
        let opQueue = OperationQueue()
        opQueue.isSuspended = true
        opQueue.maxConcurrentOperationCount = 1
        opQueue.name = "com.OperationQueue"
        return opQueue
    }()
    
    // настариваем UI, загружаем данные из памяти
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        let request = Flickr.ImageModelFromMemory.Request()
        interactor?.loadFromMemory(request: request)
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
        view.backgroundColor = .white
        
        let textField = UITextField()
        let textFieldHeight: CGFloat = 50
        textField.frame = CGRect(x: 20, y: 90, width: view.frame.width-50, height: textFieldHeight)
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
    
    // MARK: - методы протокола FlickrDisplayLogic
    
    /// Отображаем изображения, переданные из презентера
    ///
    /// - Parameter viewModel: содержит массив изображений
    func displayImages(viewModel: Flickr.ImageModel.ViewModel) {
        images = viewModel.images
        spinnerBackgroundView.isHidden = true
        spinner.stopAnimating()
        tableView.reloadData()
    }
    
    /// Отображаем изображения из памяти, номер последней подгруженной страницы и последней поисковый запрос
    ///
    /// - Parameter viewModel: содержит массив изображений, номер последней страницы и последний поисковый запрос
    func displayImagesFromMemory(viewModel: Flickr.ImageModelFromMemory.ViewModel) {
        searchingString = viewModel.searchingString
        page = viewModel.page
        images = viewModel.images
        spinnerBackgroundView.isHidden = true
        spinner.stopAnimating()
        tableView.reloadData()
    }
    
    // MARK: - Приватные методы
    
    /// Когда вводится текст, отменяем все операции и добавляем загрузку по ключевому слову через секунду
    ///
    /// - Parameter sender: UITextField
    @objc private func didChangedText(_ sender: UITextField) {
        operationQueue.isSuspended = true
        operationQueue.cancelAllOperations()
        if (sender.text == nil) || (sender.text == "") {
            images.removeAll()
            tableView.reloadData()
            return
        }
        searchingString = sender.text!
        let operation = LoadImagesOperation(interactor: interactor!, searchingString: searchingString)
        operationQueue.addOperation(operation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.spinnerBackgroundView.isHidden = false
            self.spinner.startAnimating()
            self.operationQueue.isSuspended = false
        }
    }
    

    
}
