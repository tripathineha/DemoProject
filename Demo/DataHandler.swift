//
//  DataHandler.swift
//  Demo
//
//  Created by Globallogic on 22/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation
import CoreData

private let shared = DataHandler()

class DataHandler {
    
    class var sharedInstance : DataHandler  {
        return shared
    }
    
    fileprivate init(){
        
    }
    
    lazy var persistentContainer : NSPersistentContainer = {
        
        var container = NSPersistentContainer(name: "Demo")
        
        let description = container.persistentStoreDescriptions[0]
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error : \(error), \(error.userInfo)")
            }
        })
        
        return container
     }()
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        let managedContext = self.persistentContainer.newBackgroundContext()
        return managedContext
    }()
    
    func saveToDo(attributeValue : [String : Any]){
        // Create Entity
        guard let entity = NSEntityDescription.entity(forEntityName: Entity.item.rawValue, in: self.managedObjectContext) else {
            fatalError("Entity could not be loaded!")
        }
        
        // Initialize Object
        let object = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
        
        // Populate Object
        let name = attributeValue[EntityItem.name.rawValue] as? String
        let toDoAt = attributeValue[EntityItem.toDoAt.rawValue] as? Date
        let done = attributeValue[EntityItem.done.rawValue] as? Bool
        
        object.setValue(name, forKey: EntityItem.name.rawValue)
        object.setValue(NSDate(), forKey: EntityItem.createdAt.rawValue)
        object.setValue(done, forKey: EntityItem.done.rawValue)
        object.setValue(toDoAt, forKey: EntityItem.toDoAt.rawValue)
        saveContext()
    }
    
    func updateToDo(object : NSManagedObject,attributeValue : [String : Any]){
        // Update Object
        let name = attributeValue[EntityItem.name.rawValue] as? String
        let toDoAt = attributeValue[EntityItem.toDoAt.rawValue] as? Date
        let done = attributeValue[EntityItem.done.rawValue] as? Bool
        
        object.setValue(name, forKey: EntityItem.name.rawValue)
        object.setValue(toDoAt, forKey: EntityItem.toDoAt.rawValue)
        object.setValue(done, forKey: EntityItem.done.rawValue)
        saveContext()
    }
    
    func deleteToDo(object : NSManagedObject){
        managedObjectContext.delete(object)
        saveContext()
    }
    
    func saveContext(){
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
