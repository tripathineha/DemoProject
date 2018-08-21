//
//  Author+CoreDataProperties.swift
//  Demo
//
//  Created by Globallogic on 22/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var commits: Item?

}
