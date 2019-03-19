//
//  IndexPath+Extension.swift
//  To Do List
//
//  Created by Denis Bystruev on 19/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

extension IndexPath {
    var nextRow: IndexPath {
        return IndexPath(row: self.row + 1, section: self.section)
    }
    
    var prevRow: IndexPath {
        return IndexPath(row: self.row - 1, section: self.section)
    }
    
    var nextSection: IndexPath {
        return IndexPath(row: self.row, section: self.section + 1)
    }
    
    var prevSection: IndexPath {
        return IndexPath(row: self.row, section: self.section - 1)
    }
}
