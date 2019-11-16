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
    }
    required init?(coder: NSCoder) {
        fatalError("Метод не реализован")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.dataSource = self
        loadImage()
        loadData()
    }
    
    private func loadImage() {
        let imagePath = "https://s16.stc.all.kpcdn.net/share/i/12/11048313/inx960x640.jpg"
        interactor.loadImage(at: imagePath) { [weak self] image in
            if let image = image {
                let model = ImageViewModel(description: "Тестовая картинка", image: image)
                self?.images = [model]
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func loadData() {
        interactor.loadImageList(by: "cat") { (models) in
            //self.images = models
            
            for index in 0...10 {
                self.flickrImages.append(models[index])
            }
            
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
        let model = images[indexPath.row]
        cell.imageView?.image = model.image
        cell.textLabel?.text = model.description
        return cell
    }
}

