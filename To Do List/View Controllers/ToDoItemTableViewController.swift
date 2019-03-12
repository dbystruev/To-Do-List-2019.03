//
//  ToDoItemTableViewController.swift
//  To Do List
//
//  Created by Denis Bystruev on 05/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - ... Properties
class ToDoItemTableViewController: UITableViewController {
    var todo = ToDo()
}

// MARK: - ... TableViewDataSource
extension ToDoItemTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let value = todo.values[section]
        let cell = configureCell(with: value)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = todo.capitilizedKeys[section]
        return key
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return todo.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

// MARK: - ... Custom Methods
extension ToDoItemTableViewController {
    func configureCell(with value: Any?) -> UITableViewCell {
        
        if let stringValue = value as? String {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = stringValue
            return cell
            
        } else if let boolValue = value as? Bool {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.switch.isOn = boolValue
            return cell
            
        } else if let dateValue = value as? Date {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
            cell.label.text = formatter.string(from: dateValue)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = ""
            return cell
            
        }
    }
}

// MARK: - ... Navigation
extension ToDoItemTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveSegue" else { return }
        
        for (index, key) in todo.keys.enumerated() {
            
            let indexPath = IndexPath(row: 0, section: index)
            let cell = tableView.cellForRow(at: indexPath)
            let value = todo.values[index]
            
            if value is String {
                
                let textFieldCell = cell as! TextFieldCell
                let value = textFieldCell.textField.text
                
                todo.setValue(value, forKey: key)
                
            } else if value is Bool {
                
                let switchCell = cell as! SwitchCell
                let value = switchCell.switch.isOn
                
                todo.setValue(value, forKey: key)
                
            } else if value is Date {
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                
                let dateCell = cell as! DateCell
                let text = dateCell.label.text ?? ""
                let value = formatter.date(from: text)
                
                todo.setValue(value, forKey: key)
                
            } else {
                
                let textFieldCell = cell as! TextFieldCell
                let value = textFieldCell.textField.text
                
                todo.setValue(value, forKey: key)
            }
        }
    }
}
