//
//  ToDo.swift
//  To Do List
//
//  Created by Denis Bystruev on 05/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import CloudKit
import UIKit

@objcMembers class ToDo: NSObject {
    
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    var image: UIImage?
    
    init(
        title: String = String(),
        isComplete: Bool = Bool(),
        dueDate: Date = Date(),
        notes: String? = String(),
        image: UIImage? = UIImage()
    ) {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.image = image
    }
    
    var capitilizedKeys: [String] {
        return keys.map {  $0.capitilizedWithSpaces }
    }
    
    var keys: [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    var values: [Any?] {
        return Mirror(reflecting: self).children.map { $0.value }
    }
    
    static func loadData() -> [ToDo]? {
        return loadSampleData()
    }
    
    static func loadSampleData() -> [ToDo] {
        return [
            ToDo(title: "Купить хлеб", isComplete: false, dueDate: Date(), notes: "Только в «Перекрёстке»"),
            ToDo(title: "Поздравить с 8 марта", isComplete: false, dueDate: Date(), notes: nil),
            ToDo(title: "Сдать проект", isComplete: false, dueDate: Date(), notes: nil),
        ]
    }
}

extension ToDo/*: CustomStringConvertible*/ {
    override var description: String {
        var result = ""
        
        for key in self.keys {
            let value = self.value(forKey: key) ?? "nil"
            
            result += "\n\tkey: \(key), value: \(String(describing: value))"
        }
        
        return result
    }
}

// MARK: - ... CloudKit
extension ToDo {
    convenience init?(record: CKRecord) {
        self.init()
        
        for (index, key) in self.keys.enumerated() {
            
            let value = self.values[index]
            let newValue = record.object(forKey: key)
            print(#function, "key =", key)
            
            if value is String || value is String? {
                guard let newValue = newValue as? String else { return nil }
                self.setValue(newValue, forKey: key)
            } else if value is Bool {
                guard let newValue = newValue as? Int else { return nil }
                self.setValue(newValue != 0, forKey: key)
            } else if value is Date {
                guard let newValue = newValue as? Date else { return nil }
                self.setValue(newValue, forKey: key)
            } else if value is UIImage? {
                guard let imageAsset = newValue as? CKAsset else { return nil }
                guard let imageData = try? Data(contentsOf: imageAsset.fileURL) else { return nil }
                guard let image = UIImage(data: imageData) else { return nil }
                self.setValue(image, forKey: key)
            } else {
                print(#function, "Unknown field type on line \(#line)")
                return nil
            }
        }
    }
    
    static func loadFromCloudKit(completion: @escaping ([ToDo]?) -> Void) {
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ToDo", predicate: predicate)
    
        publicDatabase.perform(query, inZoneWith: nil) { results, _ in
            guard let results = results else {
                completion(nil)
                return
            }
            
            let todos = results.compactMap { ToDo(record: $0) }
            print(#function, "todos.count =", todos.count)
            completion(todos)
        }
    }
}

//extension ToDo: NSCopying {
//    func copy(with zone: NSZone? = nil) -> Any {
//        let todo = ToDo()
//
//        let propertyNames = Mirror(reflecting: todo).children.compactMap { $0.label }
//
//        propertyNames.forEach {
//            let value = self.value(forKey: $0)
//            todo.setValue(value, forKey: $0)
//        }
//
//        return todo
//    }
//}
