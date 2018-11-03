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
        
        //Ternary Operator - value = condition ? valueIfTrue : valueIfFalse
        //cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //MARK: - CRUD - Data Manipulation Methods
    
    func saveCategory() {
        print("\n=== Running function saveCategory ===")
        do {
            try context.save()
        } catch {
            print("\n=== Error saving Category context \(error) ===")
        }
        print("\n=== Reload data ===")
        self.tableView.reloadData()
    }

    func createCategory() {
        print("Set VAR Category")
        var categoryTextField = UITextField()

        print("Set Category Alert Title")
        let alert = UIAlertController(title: "Add New To Do Category", message: "", preferredStyle: .alert)

        print("Set Category Alert Action")
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //What will happen when the user clicks the Add Item button on our UIAlert
            
            print("\n=== Set newCategory values ===")
            
            let newCategory = Category(context: self.context)
            newCategory.name = categoryTextField.text!
            // newCategory.done = false
            self.categoryArray.append(newCategory)
            print("\n=== Save new item ===")
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
        
//            print("\n=== Deleting data... ===")
//            context.delete(categoryArray[indexPath.row])
//            categoryArray.remove(at: indexPath.row)
//
//            print("=== Data deleted ===")
//            saveCategory()
//
//            tableView.deselectRow(at: indexPath, animated: true)

    }

}
