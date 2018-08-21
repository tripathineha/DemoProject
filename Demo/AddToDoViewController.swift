//
//  AddToDoViewController.swift
//  Demo
//
//  Created by Globallogic on 18/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddToDoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var record: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let record = record,
            let name = record.value(forKey: EntityItem.name.rawValue) as? String {
            textField.text = name
            let date = record.value(forKey: EntityItem.toDoAt.rawValue) as? Date
            datePicker.setDate(date! , animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddToDoViewController {
    // MARK: Actions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        let name = textField.text
        var tempRecord : NSManagedObject?
        if let name = name, name.isEmpty == false {
            
            let attributeValue : [String : Any] = [EntityItem.name.rawValue : name,
                                  EntityItem.toDoAt.rawValue : datePicker.date]
            
            if let record = record {
                DataHandler.sharedInstance.updateToDo(object: record, attributeValue:attributeValue)
                tempRecord = updateObject(record : record , name: name)
            } else {
                DataHandler.sharedInstance.saveToDo(attributeValue:attributeValue)
                tempRecord = saveObject(name: name)
            }
            if let tempRecord = tempRecord {
                saveContext(record: tempRecord)
                NotificationDelegate.sharedInstance.sendNotification(record: tempRecord)
            }
            
        } else {
            // Show Alert View
            showAlertWithTitle(title: Alert.title.localized, message: Alert.item_name_not_given.localized, cancelButtonTitle: "ok".localized())
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismissVC()
    }
    
    // MARK: Helper Methods
    private func showAlertWithTitle(title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil))
        
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateObject(record: NSManagedObject,name : String) -> NSManagedObject{
        record.setValue(name, forKey: EntityItem.name.rawValue)
        record.setValue(datePicker.date, forKey: EntityItem.toDoAt.rawValue)
        return record
    }
    
    private func dismissVC(){
        if record == nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveObject(name : String) -> NSManagedObject{
        // Create Entity
        let entity = NSEntityDescription.entity(forEntityName: Entity.item.rawValue, in: DataHandler.sharedInstance.managedObjectContext)
        
        // Initialize Record
        let tempRecord = NSManagedObject(entity: entity!, insertInto: DataHandler.sharedInstance.managedObjectContext)
        
        // Populate Record
        tempRecord.setValue(name, forKey: EntityItem.name.rawValue)
        tempRecord.setValue(NSDate(), forKey: EntityItem.createdAt.rawValue)
        tempRecord.setValue(datePicker.date, forKey: EntityItem.toDoAt.rawValue)
        return tempRecord
    }
    
    private func saveContext(record : NSManagedObject){
        do {
            // Save Record
            try record.managedObjectContext?.save()
            
            // Dismiss View Controller
            dismissVC()
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
            // Show Alert View
            showAlertWithTitle(title: Alert.title.localized, message: Alert.item_not_saved.localized, cancelButtonTitle: "ok".localized())
        }
    }
}
