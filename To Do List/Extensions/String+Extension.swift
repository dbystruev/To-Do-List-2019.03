//
//  String+Extension.swift
//  To Do List
//
//  Created by Denis Bystruev on 19/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

extension String {
    var capitilizedWithSpaces: String {
        let withSpaces = self.reduce("") { result, character in
            character.isUppercased ? "\(result) \(character)" : "\(result)\(character)"
        }
        
        return withSpaces.capitalized
    }
}
