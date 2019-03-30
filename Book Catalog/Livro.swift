//
//  Livro+CoreDataClass.swift
//  Book Catalog
//
//  Created by Rafael Jeffman on 01/10/16.
//  Copyright © 2016 Rafael Jeffman. All rights reserved.
//

import Foundation
import CoreData


public class Livro: NSManagedObject {

    class func createWith(titulo: String, editora: String?, ano: Int16?, in context: NSManagedObjectContext) -> Livro? {
        let request = NSFetchRequest<Livro>(entityName: "Livro")
        let query = "titulo == %@"
        let params = [ titulo ]
        
        request.predicate = NSPredicate(format: query, argumentArray: params)
        
        // tenta recuperar o livro
        if let livro = (try? context.fetch(request))?.first {
            return livro
        }
        // senao cria o livro
        if let livro = NSEntityDescription.insertNewObject(forEntityName: "Livro", into: context) as? Livro {
            livro.titulo = titulo
            livro.editora = editora
            livro.ano = ano ?? 0
            return livro
        }
        // em caso de erro...
        return nil
    }
}
