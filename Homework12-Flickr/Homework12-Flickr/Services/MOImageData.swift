//
//  MOImageData.swift
//  Homework12-Flickr
//
//  Created by Кирилл Афонин on 21/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import Foundation
import CoreData

@objc(MOImageData)
internal class MOImageData: NSManagedObject {
    
    @NSManaged var imageData: Data
    @NSManaged var imageDescription: String
}

@objc(MORequest)
internal class MORequest: NSManagedObject {
    
    @NSManaged var searchingString: String
    @NSManaged var page: Int16
}
