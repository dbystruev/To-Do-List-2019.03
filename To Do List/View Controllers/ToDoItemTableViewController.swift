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

// MARK: - ... UITableViewDataSource
extension ToDoItemTableViewController/*: UITableViewDataSource*/ {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let value = todo.values[section]
        let cell = configureCellFor(indexPath: indexPath, with: value)
        
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
        let value = todo.values[section]
        let numberOfRows = value is Date ? 2 : 1
        return numberOfRows
    }
}

// MARK: - ... UITableViewDelegate {
extension ToDoItemTableViewController/*: UITableViewDelegate*/ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard isItDateCell(at: indexPath) else { return }
        guard let cell = tableView.cellForRow(at: indexPath.nextRow) else { return }
        
        cell.isHidden.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard isItDatePickerCell(at: indexPath) else { return 44 }
        guard let cell = tableView.cellForRow(at: indexPath) else { return 44 }
        
        return cell.isHidden ? 0 : 200
    }
}

// MARK: - ... Custom Methods
extension ToDoItemTableViewController {
    func isIt<T>(_ type: T, at indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is T
    }
    
    func isItDateCell(at indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is DateCell
    }
    
    func isItDatePickerCell(at indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is DatePickerCell
    }
    
    func configureCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell {
        if let stringValue = value as? String {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = stringValue
            return cell
            
        } else if let boolValue = value as? Bool {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.switch.isOn = boolValue
            return cell
            
        } else if let dateValue = value as? Date {
            
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setDate(dateValue)
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
                
                cell.datePicker.addTarget(self, action: #selector(valueChanged(at:)), for: .valueChanged)
                cell.datePicker.date = Date()
                cell.datePicker.indexPath = indexPath
                cell.datePicker.minimumDate = Date()

                cell.isHidden = true
                return cell
            }
            
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = ""
            return cell
            
        }
    }
    
    @objc func valueChanged(at datePicker: DatePicker) {
        let dateCellIndexPath = datePicker.indexPath.prevRow
        guard let cell = tableView.cellForRow(at: dateCellIndexPath) as? DateCell else { return }
        cell.setDate(datePicker.date)
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
