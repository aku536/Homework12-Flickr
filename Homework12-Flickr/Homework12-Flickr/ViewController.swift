//
//  ViewController.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoadOperationDelegate {
    
    private let tableView = UITableView()
    let spinner = UIActivityIndicatorView(style: .gray)
    let spinnerBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    var images: [ImageViewModel] = [] // массив изображений
    var flickrData = [ImageModel]() { // массив с url, когда обновляется - загружаем картинки
        didSet {
            loadImages()
        }
    }
    var searchingString = ""
    let reuseId = "UITableViewCellreuseId"
    let interactor: InteractorInput
    
    // Выполняет загрузку данных с api
    lazy var operation = LoadOperation(interactor: interactor, searchingString: searchingString)
    var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.download.queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    init(interactor: InteractorInput) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("Метод не реализован")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Настройка UI
    private func setupUI() {
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
    
    
    /// Срабатывает при вводе текста. Добавляет операцию загрузки в очередь через 0,5 сек. Все другие операции отменяются
    ///
    /// - Parameter sender: UITextField
    @objc private func didChangedText(_ sender: UITextField) {
        guard sender.text != nil else {
            return
        }
        searchingString = sender.text!
        operationQueue.cancelAllOperations()
        operationQueue.isSuspended = true
        loadData(by: searchingString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.spinnerBackgroundView.isHidden = false
            self.spinner.startAnimating()
            self.operationQueue.isSuspended = false
        }
    }
    
    /// Создает операцию загрузки данных и добавляет её в очередь
    ///
    /// - Parameter searchingString: ключевое слово для поиска
    private func loadData(by searchingString: String) {
        LoadOperation.page = 1 // Загружаем первую страницу с API
        operation = LoadOperation(interactor: self.interactor, searchingString: searchingString)
        operation.delegate = self
        flickrData.removeAll()
        images.removeAll()
        operationQueue.addOperation(operation)
    }
    
    
    /// Загружает изображения и обновляет таблицу
    private func loadImages() {
        let group = DispatchGroup()
        for flickrImage in flickrData {
            group.enter()
            interactor.loadImage(at: flickrImage.path) { [weak self] image in
                guard let image = image else {
                    group.leave()
                    return
                }
                
                let model = ImageViewModel(description: flickrImage.description, image: image)
                self?.images.append(model)
                group.leave()
                
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.spinnerBackgroundView.isHidden = true
            self.spinner.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
}
