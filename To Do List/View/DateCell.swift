//
//  DateCell.swift
//  To Do List
//
//  Created by Denis Bystruev on 12/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        label.text = formatter.string(from: date)
    }
}
