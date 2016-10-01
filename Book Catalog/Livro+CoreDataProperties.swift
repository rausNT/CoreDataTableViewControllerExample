//
//  Livro+CoreDataProperties.swift
//  Book Catalog
//
//  Created by Rafael Jeffman on 01/10/16.
//  Copyright © 2016 Rafael Jeffman. All rights reserved.
//

import Foundation
import CoreData


extension Livro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Livro> {
        return NSFetchRequest<Livro>(entityName: "Livro");
    }

    @NSManaged public var titulo: String?
    @NSManaged public var editora: String?
    @NSManaged public var ano: Int16

}
