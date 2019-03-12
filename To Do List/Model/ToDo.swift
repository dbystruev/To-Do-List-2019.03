//
//  ToDo.swift
//  To Do List
//
//  Created by Denis Bystruev on 05/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

@objcMembers class ToDo: NSObject {
    
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    init(
        title: String = String(),
        isComplete: Bool = Bool(),
        dueDate: Date = Date(),
        notes: String? = nil
    ) {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    var capitilizedKeys: [String] {
        let nonCapitalized = Mirror(reflecting: self).children.compactMap { $0.label }
        
        var words = [String]()
        
        nonCapitalized.forEach { word in
            var splitWord = ""
            
            for character in word {
                if String(character) == String(character).localizedUppercase {
                    splitWord += " "
                }
                splitWord += "\(character)"
            }
            
            words += [splitWord.localizedCapitalized]
        }
        
        return words
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
