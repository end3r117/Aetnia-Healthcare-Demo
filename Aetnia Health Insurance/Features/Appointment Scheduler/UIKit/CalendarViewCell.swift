//
//  CalendarViewCell.swift
//  BBProject
//
//  Created by Anthony Rosario on 4/28/19.
//  Copyright © 2019 Anthony Rosario. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewCell: JTAppleCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView! {
        didSet {
            selectedView.layer.cornerRadius = max(selectedView.frame.width / 2, 2)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.clear.cgColor
    }

}
