//
//  CoreDataWorker.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 21/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation
import CoreData

// Фасад
final class CoreDataWorker {
    
    // Синглтон
    static let shared: CoreDataWorker = {
        let coreData = CoreDataWorker()
        return coreData
    }()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        let group = DispatchGroup()
        
        persistentContainer = NSPersistentContainer(name: "Model")
        group.enter()
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }
    
    /// очистка информации по последнему запросу
    func clearLastRequest() {
        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Request")))
    }
    
    /// очистка сохраненных изображений
    func clearImageData() {
        try! persistentContainer.viewContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "ImageData")))
    }
    
    
    /// Загрузка изображения в бинарном виде и описания из памяти
    func loadFromMemory() -> [MOImageData] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageData")
        var imagesFromMemory = [MOImageData]()
        do {
            imagesFromMemory = try managedContext.fetch(fetchRequest) as! [MOImageData]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return imagesFromMemory
    }
    
    /// Загрузка информации по последнему запросу
    func loadLastRequest() -> (String, Int) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Request")
        guard let lastRequest = try? managedContext.fetch(fetchRequest) as? [MORequest] else {
            return ("", 1)
        }
        let searchingString = lastRequest.first?.searchingString ?? ""
        let page = Int(lastRequest.first?.page ?? 1)
        return (searchingString, page)
    }
    
    
}
