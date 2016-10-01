//
//  ListaLivrosController.swift
//  Book Catalog
//
//  Created by Rafael Jeffman on 01/10/16.
//  Copyright © 2016 Rafael Jeffman. All rights reserved.
//

import UIKit
import CoreData

class ListaLivrosController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestFetchedResultsController()
    }
    
    // MARK: - CoreDataTableViewController FetchedResultsController setup
    
    private func requestFetchedResultsController() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Livro")
        request.sortDescriptors = [ NSSortDescriptor(key: "titulo", ascending: true) ]
        
        if let context = managedObjectContext {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    // MARK: - UITableView data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let livro = fetchedResultsController?.object(at: indexPath) as? Livro {
            cell.textLabel?.text = livro.titulo
            cell.detailTextLabel?.text = livro.editora
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetalheLivroController {
            destination.managedObjectContext = managedObjectContext
            if segue.identifier == "inserirLivro" {
                destination.livro = nil
            } else
            if let indexPath = tableView.indexPathForSelectedRow,
                let livro = fetchedResultsController?.object(at: indexPath) as? Livro
            {
                destination.livro = livro
            }
        }
    }

}
