//
//  CategoryViewController.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/3/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //MARK: - Category Constants
    let realm = try! Realm()
    
    //MARK: - Category Variables
    var categories: Results<Category>?
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        readCategory()
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        //let category = categories
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories yet. Click + to add a category."
        
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
        self.tableView.reloadData()

    }

    func createCategory() {

        var categoryTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = categoryTextField.text!
            
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
        
    }

    func deleteCategory() {

    }

}
