//
//  CategoryViewController.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/3/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //MARK: - Category Variables
    var categoryArray = [Category]()

    
    //MARK: - Category Constants
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - CRUD - Data Manipulation Methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("\n=== Error saving Category context \(error) ===")
        }
        self.tableView.reloadData()
    }

    func createCategory() {

        var categoryTextField = UITextField()
        let alert = UIAlertController(title: "Add New To Do Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = categoryTextField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "\n=== Create new category ==="
            categoryTextField = alertTextField
            
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }

    func readCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("\n=== Error fetching Category data from context \(error) ===")
        }
        
        tableView.reloadData()

    }

    func updateCategory() {
        
    }

    func deleteCategory() {

    }

}
