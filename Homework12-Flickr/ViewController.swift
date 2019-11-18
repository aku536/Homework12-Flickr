//
//  ViewController.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 16/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    var images: [ImageViewModel] = []
    var flickrImages = [ImageModel]()
    let reuseId = "UITableViewCellreuseId"
    let interactor: InteractorInput
    
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
        loadData(by: sender.text!)
    }
    
    private func loadData(by string: String) {
        interactor.loadImageList(by: string) { (models) in
            
            self.images.removeAll()
            self.flickrImages.removeAll()
            self.flickrImages = models.suffix(100)
            
            
            for fImage in self.flickrImages {
                let imagePath = fImage.path
                self.interactor.loadImage(at: imagePath) { [weak self] image in
                    if let image = image {
                        let model = ImageViewModel(description: fImage.description, image: image)
                        self?.images.append(model)
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
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

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
