//
//  Constant.swift
//  Demo
//
//  Created by Globallogic on 22/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

enum Entity : String {
    case item = "Item"
    case author = "Author"
}

enum EntityItem : String {
    case name = "name"
    case createdAt = "createdAt"
    case done = "done"
    case toDoAt = "toDoAt"
}

enum EntityAuthor : String {
    case aname = "aname"
    case amail = "amail"
}

enum Alert : String {
    case title = "alert"
    case item_not_saved = "item_not_saved"
    case item_name_not_given = "item_name_not_given"
    
    var localized : String {
        return self.rawValue.localized()
    }
}

enum Notification : String{
    case title = "alarm"
    case actionRepeat = "repeat"
    case actionChange = "change"
    case categoryIdentifier = "actionCategory"
    case identifier = "toDoAlarm"
    
    var localized : String {
        return self.rawValue.localized()
    }
}




