//
//  ViewController.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoadOperationDelegate {
    
    let tableView = UITableView()
    var images: [ImageViewModel] = []
    var flickrImages = [ImageModel]() {
        didSet {
            loadImages()
        }
    }
    let reuseId = "UITableViewCellreuseId"
    let interactor: InteractorInput
    
    lazy var operation = LoadOperation(interactor: interactor, searchingString: nil)
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
    
    private func setupUI() {
        let textField = UITextField()
        let textFieldHeight: CGFloat = 50
        textField.frame = CGRect(x: 20, y: 50, width: view.frame.width-50, height: textFieldHeight)
        textField.backgroundColor = .white
        textField.placeholder = "🔍Поиск фото"
        textField.delegate = self
        textField.addTarget(self, action: #selector(didChangedText), for: .editingChanged)
        view.addSubview(textField)
        
        
        tableView.frame = CGRect(x: 0,
                                 y: textField.frame.maxY,
                                 width: view.frame.width,
                                 height: view.frame.height - textFieldHeight)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    @objc private func didChangedText(_ sender: UITextField) {
        operationQueue.cancelAllOperations()
        operationQueue.isSuspended = true
        loadData(by: sender.text!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.operationQueue.isSuspended = false
        }
        
    }
    
    private func loadData(by searchingString: String) {
        operation = LoadOperation(interactor: self.interactor, searchingString: searchingString)
        operation.delegate = self
        operationQueue.addOperation(operation)
    }
    
    private func loadImages() {
        let group = DispatchGroup()
        for image in flickrImages {
            group.enter()
            interactor.loadImage(at: image.path) { [weak self] image in
                guard let image = image else {
                    group.leave()
                    return
                }
                
                let model = ImageViewModel(description: image.description, image: image)
                self?.images.append(model)
                group.leave()
                
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        guard images.count != 0 else {
            return cell
        }
        let model = images[indexPath.row]
        cell.imageView?.image = model.image
        cell.textLabel?.text = model.description
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == images.count - 1 {
            loadImages()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
