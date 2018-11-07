//
//  ViewController.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/1/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

    //MARK: - Item Constants
    let realm = try! Realm()
    
    //MARK: - Item Variables
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            readItems()
        }
    }

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
                tableView.rowHeight = 80.0
        
    }

    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {

            cell.textLabel?.text = item.title

            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
                cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Update - Mark ToDo as Done
        if let item = toDoItems? [indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("User Action: addButtonPressed")
        self.createItem()
    }
    
    //MARK: - CRUD - Model Manipulation Methods

    // CREATE DATA
    func createItem () {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
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
    func readItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    // UPDATE DATA
    func updateItems() {
        
    }

    // DELETE DATA
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                    print("Item was deleted.")
                }
            } catch {
                print("Error deleting item, \(error)")
            }
            
        }
    }

    // SAVE DATA
    func saveItems(item: Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("\n=== Error saving Item to Realm \(error) ===")
        }
        self.tableView.reloadData()
        
    }

}

//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        self.tableView.reloadData()
        
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



