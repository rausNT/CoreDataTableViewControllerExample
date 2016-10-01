//
//  DetalheLivroController.swift
//  Book Catalog
//
//  Created by Rafael Jeffman on 01/10/16.
//  Copyright © 2016 Rafael Jeffman. All rights reserved.
//

import UIKit
import CoreData

class DetalheLivroController: UIViewController {

    weak var managedObjectContext: NSManagedObjectContext?
    
    weak var livro: Livro? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBOutlet weak var tituloEdit: UITextField!
    @IBOutlet weak var editoraEdit: UITextField!
    @IBOutlet weak var anoEdit: UITextField!
    
    private func updateUI() {
        tituloEdit?.text = livro?.titulo
        editoraEdit?.text = livro?.editora
        if let ano = livro?.ano {
            anoEdit?.text = String(ano)
        }
    }

    // MARK: Handle navigation by saving or not.
    
    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func saveLivro(_ sender: UIBarButtonItem) {
        // Se existe um contexto gerenciado...
        if let context = managedObjectContext {
            // ou atualiza o livro existente...
            if let book = livro {
                book.titulo = tituloEdit.text
                book.editora = editoraEdit.text
                if let anoText = anoEdit.text,
                    let ano = Int16(anoText)
                {
                    book.ano = ano
                }
            } else {
                // ou, se o usuario digitou um titulo, cria um livro...
                if let titulo = tituloEdit.text
                {
                    let editora = editoraEdit.text
                    var ano: Int16? = nil
                    if let anoText = anoEdit.text {
                        ano = Int16(anoText)
                    }
                    let _ = Livro.createWith(titulo: titulo,
                                             editora: editora,
                                             ano: ano,
                                             in: context)
                }
            }
            // ao final, salva as alteracoes do documento.
            do {
                try context.save()
            } catch let error {
                print("\(error)")
            }
        }
        // retorna a tela anterior
        _ = navigationController?.popViewController(animated: true)
    }
    
}
