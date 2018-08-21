//
//  NotificationDelegate.swift
//  Demo
//
//  Created by Globallogic on 19/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData

private let shared = NotificationDelegate()

class NotificationDelegate : NSObject, UNUserNotificationCenterDelegate{
   
    class var sharedInstance : NotificationDelegate {
        return shared
    }
    
    func sendNotification(record : NSManagedObject){
        let content = UNMutableNotificationContent()
        content.title = Notification.title.localized
        let body = record.value(forKey: EntityItem.name.rawValue) as? String ?? ""
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let repeatAction = UNNotificationAction(identifier:Notification.actionRepeat.rawValue,
                                                title:Notification.actionRepeat.localized,options:[])
        
        let changeAction = UNTextInputNotificationAction(identifier: Notification.actionChange.rawValue,
                                                         title: Notification.actionChange.localized, options: [])
        
        let category = UNNotificationCategory(identifier: Notification.categoryIdentifier.rawValue,
                                              actions: [repeatAction, changeAction],
                                              intentIdentifiers: [], options: [])
        
        content.categoryIdentifier = Notification.categoryIdentifier.rawValue
        
        UNUserNotificationCenter.current().setNotificationCategories(
            [category])
        
        let date = record.value(forKey: EntityItem.toDoAt.rawValue) as? Date ?? Date()
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: Notification.identifier.rawValue, content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case Notification.actionRepeat.rawValue:
            break
        case Notification.actionChange.rawValue:
            let textResponse = response
                as? UNTextInputNotificationResponse
            let messageSubtitle = textResponse?.userText
            print(messageSubtitle)
        default:
            break
        }
        completionHandler()
    }
}
