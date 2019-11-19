//
//  TableViewDelegate.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 19/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row // если дошли до последней ячейки, загружаем новую страницу
        if lastRow == images.count - 1, images.count > 17 {
            spinnerBackgroundView.isHidden = false
            spinner.startAnimating()
            loadNextPage()
        }
    }
    
    /// Загружает следующую страницу с api
    private func loadNextPage() {
        LoadOperation.page += 1 // увеличиваем счетчик страниц
        operation = LoadOperation(interactor: self.interactor, searchingString: searchingString)
        operation.delegate = self
        operationQueue.addOperation(operation)
    }
    
}
