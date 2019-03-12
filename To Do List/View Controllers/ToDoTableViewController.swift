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
        todos = ToDo.load() ?? []
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
    }
}
