//
//  BookTableViewCell.swift
//  BookFinder
//
//  Created by Atikur Rahman on 6/19/16.
//  Copyright © 2016 Atikur Rahman. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // any time its value is set, it cancels the previous NSURLSessionTask
    var taskToCancelIfCellIsReused: NSURLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
    
}
