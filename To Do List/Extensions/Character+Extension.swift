//
//  Character+Extension.swift
//  To Do List
//
//  Created by Denis Bystruev on 19/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

extension Character {
    var isUppercased: Bool {
        return "\(self)" == "\(self)".uppercased()
    }
}
