//
//  CoreDataTableViewController.swift
//  Diário de Classe
//
//  Created by Rafael Jeffman on 20/09/16.
//  Copyright © 2016 Rafael Jeffman. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate
{
    var managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject>? {
        didSet {
            do {
                if let resultsController = fetchedResultsController {
                    resultsController.delegate = self
                    try resultsController.performFetch()
                    tableView.reloadData()
                }
            } catch let error {
                print("PerformFetch failed: \(error)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let obj = fetchedResultsController?.object(at: indexPath) {
                managedObjectContext?.delete(obj as NSManagedObject)
                do {
                    try managedObjectContext?.save()
                } catch let error {
                    print("\(error)")
                }
            }
        default: break
        }
    }
    
    // MARK: - NSFetchedResultControllerDelegate methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete: tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .update: tableView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default: break // left .move
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            // Only works if sections are not affected
            //tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
