//
//  DataController.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/19/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation
import CoreData

// Setup CoreData
class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load() {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
}
