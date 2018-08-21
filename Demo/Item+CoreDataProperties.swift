//
//  Item+CoreDataProperties.swift
//  Demo
//
//  Created by Globallogic on 22/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var done: Bool
    @NSManaged public var name: String?
    @NSManaged public var toDoAt: NSDate?
    @NSManaged public var committed: Author?

}
