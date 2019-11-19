//
//  TableViewDataSource.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 19/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

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
