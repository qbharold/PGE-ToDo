//
//  CategoryViewController.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/3/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    //MARK: - Category Constants
    let realm = try! Realm()
    
    //MARK: - Category Variables
    var categories: Results<Category>?
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        readCategory()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        createCategory()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // Nil Coalescing Operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let category = categories?[indexPath.row] {

            guard let categoryColor = UIColor(hexString: category.rowColor) else {fatalError()}
            
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].rowColor ?? "1D9BF6")
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - CRUD - Data Manipulation Methods
    func save(category: Category) {

        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("\n=== Error saving Category to Realm \(error) ===")
        }
        super.tableView.reloadData()

    }

    func createCategory() {

        var categoryTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = categoryTextField.text!
            newCategory.rowColor = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            categoryTextField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)

    }

    func readCategory() {

        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }

    func updateCategory() {
        //Deprecated
    }

     override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    print("Category was deleted.")
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}



