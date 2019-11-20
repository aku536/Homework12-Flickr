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
        page += 1
        let request = Flickr.ImageModel.Request(searchingString: searchingString, page: page)
        interactor?.loadImagesData(request: request)
    }

}
