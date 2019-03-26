//
//  ToDoItemTableViewController.swift
//  To Do List
//
//  Created by Denis Bystruev on 05/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Photos
import UIKit

// MARK: - ... Properties
class ToDoItemTableViewController: UITableViewController {
    var imagePickerCell: ImageCell?
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
        
        if isDateCell(at: indexPath) {
            guard let cell = tableView.cellForRow(at: indexPath.nextRow) else { return }
            
            cell.isHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        } else if isImageCell(at: indexPath) {
            guard let cell = tableView.cellForRow(at: indexPath) as? ImageCell else { return }
            camera(cell: cell)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard isDatePickerCell(at: indexPath) || isImageCell(at: indexPath) else { return 44 }
        guard let cell = tableView.cellForRow(at: indexPath) else { return 44 }
        
        return cell.isHidden ? 0 : 200
    }
}

// MARK: - ... UIImagePickerControllerDelegate
extension ToDoItemTableViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imagePickerCell = imagePickerCell else { return }
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imagePickerCell.largeImageView.image = image
        self.imagePickerCell = nil
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ... UINavigationControllerDelegate
extension ToDoItemTableViewController: UINavigationControllerDelegate {}

// MARK: - ... Custom Methods
extension ToDoItemTableViewController {
    func isIt<T>(_ type: T, at indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is T
    }
    
    func isDateCell(at indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is DateCell
    }
    
    func isDatePickerCell(at indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is DatePickerCell
    }
    
    func isImageCell(at indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is ImageCell
    }
    
    func camera(cell: ImageCell) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    print(#function, "User did not allow to access the photos")
                    return
                }
                self.camera(cell: cell)
            }
            return
        case .restricted:
            print(#function, "User does not have access to photos")
            return
        case .denied:
            print(#function, "User has denied access to photos")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(
            title: "Choose image source",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        imagePickerCell = cell
        present(alertController, animated: true)
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
            
        } else if let imageValue = value as? UIImage? {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.largeImageView.image = imageValue
            return cell
            
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
            
            if value is String || value is String? {
                
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
                
                print(#function, "Can't find cell type at line \(#line)")
                
            }
        }
    }
}
