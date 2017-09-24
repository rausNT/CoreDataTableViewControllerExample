//
//  ListaLivrosController.swift
//

import UIKit
import CoreData

class ListaLivrosController: CoreDataTableViewController
{
    var fetchedResultsController: NSFetchedResultsController<Livro>? {
        didSet {
            try? refreshData(for: fetchedResultsController)
        }
    }
    
    // MARK: - CoreDataTableViewController FetchedResultsController setup
    
    override func updateRequest()
    {
        let request = NSFetchRequest<Livro>(entityName: "Livro")
        request.sortDescriptors = [ NSSortDescriptor(key: "titulo", ascending: true) ]
        
        fetchedResultsController = getFetchedResultsController(for: request)
    }
    
    // MARK: - UITableView Cell Render
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let livro = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = livro.titulo
            cell.detailTextLabel?.text = livro.editora
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetalheLivroController {
            destination.managedObjectContext = container?.viewContext
            if segue.identifier == "inserirLivro" {
                destination.livro = nil
            } else
            if let indexPath = tableView.indexPathForSelectedRow,
                let livro = fetchedResultsController?.object(at: indexPath) {
                destination.livro = livro
            }
        }
    }

}
