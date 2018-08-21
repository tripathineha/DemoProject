//
//  ViewController.swift
//  Demo
//
//  Created by Globallogic on 18/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController{

    private let ReuseIdentifierToDoCell = "ToDoCell"
    private let SegueIdentifiers = ["SegueAddToDoViewController","SegueUpdateToDoViewController"]
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSManagedObject> = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: Entity.item.rawValue)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: EntityItem.createdAt.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataHandler.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Prepare for Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == SegueIdentifiers[1],
            let viewController = segue.destination as? AddToDoViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            
            // Fetch Record
            let record = fetchedResultsController.object(at: indexPath)
            
            // Configure View Controller
            viewController.record = record
        }
    }
}

extension ViewController : UITableViewDelegate{
    // MARK: Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController {
    func configureCell(cell: ToDoCell, atIndexPath indexPath: IndexPath) {
        // Fetch Record
        let record = fetchedResultsController.object(at: indexPath)
        
        // Update Cell
        if let name = record.value(forKey: EntityItem.name.rawValue) as? String {
            cell.nameLabel.text = name
        }
        
        if let done = record.value(forKey: EntityItem.done.rawValue) as? Bool {
            cell.doneButton.isSelected = done
        }
        cell.didTapButtonHandler = {
            if let done = record.value(forKey: EntityItem.done.rawValue) as? Bool {
                record.setValue(!done, forKey: EntityItem.done.rawValue)
            }
        }
        
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifierToDoCell, for: indexPath) as! ToDoCell
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // Fetch Record
            let record = fetchedResultsController.object(at: indexPath)
            
            // Delete Record
            DataHandler.sharedInstance.deleteToDo(object: record)
        }
    }
}
extension ViewController : NSFetchedResultsControllerDelegate{
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ToDoCell
                configureCell(cell: cell, atIndexPath: indexPath)
            }
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}

