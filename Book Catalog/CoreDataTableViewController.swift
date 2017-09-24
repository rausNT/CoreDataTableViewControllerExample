//
//  CoreDataTableViewController.swift
//

import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    func updateRequest() { /* This method should be overriden */ }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRequest()
    }

    var container: NSPersistentContainer? {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func refreshData<T>(for fetchedResultsController:NSFetchedResultsController<T>?) throws {
        do {
            if let resultsController = fetchedResultsController {
                resultsController.delegate = self
                try resultsController.performFetch()
                tableView.reloadData()
            }
        } catch {
           throw error
        }
    }
    
    func getFetchedResultsController<T>(for request:NSFetchRequest<T>) -> NSFetchedResultsController<T>?
    {
        if let context = container?.viewContext {
            let frc = NSFetchedResultsController(fetchRequest: request,
                                                 managedObjectContext: context,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
            return frc
        }
        return nil
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
