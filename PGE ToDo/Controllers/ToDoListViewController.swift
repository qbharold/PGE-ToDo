//
//  ViewController.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/1/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    //Variables
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            readItems()
        }
    }

    // Constants
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // readItems()

    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator - value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        print("\n=== Deleting data... ===")
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)

        print("=== Data deleted ===")
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.createItem()
    }
    
    //MARK: - CRUD - Model Manipulation Methods

    // CREATE DATA
    func createItem () {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
                
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "\n=== Create new item ==="
            textField = alertTextField
            
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    // READ DATA
    func readItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("\n=== Error fetching data from context \(error) ===")
        }
        
        tableView.reloadData()
    }
    
    // UPDATE DATA
    func updateItems() {
        
    }

    // DELETE DATA
    func deleteItems() {
        
//        print("\n=== Deleting data... ===")
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
//        print("=== Data deleted ===")
//        saveItems()
//
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // SAVE DATA
    func saveItems() {
        print("\n=== Running function saveItems ===")
        do {
            try context.save()
        } catch {
            print("\n=== Error saving context \(error) ===")
        }
        print("\n=== Reload data ===")
        self.tableView.reloadData()
    }
    

}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        readItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            readItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }
    
}



