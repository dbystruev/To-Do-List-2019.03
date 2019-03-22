//
//  ToDoTableViewController.swift
//  To Do List
//
//  Created by Denis Bystruev on 05/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - ... Properties
class ToDoTableViewController: UITableViewController {
    var todos = [ToDo]()
}

// MARK: - ... UIViewController Methods
extension ToDoTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToDo.loadFromCloudKit { todos in
            if let todos = todos {
                self.todos = todos
            } else {
                self.todos = []
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - ... Navigation
extension ToDoTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ToDoItemSegue" else { return }
        guard let index = tableView.indexPathForSelectedRow?.row else { return }
        
        let todo = todos[index]
        
        let destination = segue.destination as! ToDoItemTableViewController
        destination.todo = todo
        destination.navigationItem.title = "Edit"
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveSegue" else { return }
        
        let source = segue.source as! ToDoItemTableViewController
        let todo = source.todo
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let indexPath = IndexPath(row: todos.count, section: 0)
            todos.append(todo)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        print(#function, todo)
    }
}

// MARK: - ... TableViewDataSource
extension ToDoTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")!
        let row = indexPath.row
        let todo = todos[row]
        configure(cell: cell, with: todo)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
}

// MARK: - ... Custom Methods
extension ToDoTableViewController {
    func configure(cell: UITableViewCell, with todo: ToDo) {
        cell.textLabel?.text = todo.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateText = formatter.string(from: todo.dueDate)
        
        cell.detailTextLabel?.text = dateText
        
//        cell.imageView?.image = todo.image
    }
}
