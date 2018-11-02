//
//  ViewController.swift
//  PGE ToDo
//
//  Created by Harold Peterson on 11/1/18.
//  Copyright © 2018 Harold Peterson, Jr. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
        
    //["Go to Inn", "Find adventure seekers", "Find job", "Replenish supplies", "Complete job", "Get Paid", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n"]
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Go to Inn"
        newItem.done = false
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find adventure seekers"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Find job"
        itemArray.append(newItem3)
        

        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
    }

    //MARK - TableView Datasource Methods
    
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
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()

    }
    
    //MARK - Add New Item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the Add Item button on our UIAlert

            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

            print(alertTextField.text!)
            print("Now")
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

