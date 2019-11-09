//
//  TimeSlotCollectionViewCell.swift
//  
//
//  Created by Anthony Rosario on 11/1/19.
//  Copyright © 2019 Anthony Rosario. All rights reserved.
//

import UIKit

class TimeSlotCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TimeSlotCollectionViewCell"
    var timeLabel = UILabel()
    override var isSelected: Bool {
        willSet {
            handleSelection(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func handleSelection(_ selection: Bool) {
        switch selection {
        case true:
            timeLabel.backgroundColor = .aetniaBlue
            timeLabel.textColor = .white
        case false:
            timeLabel.backgroundColor = .white
            timeLabel.textColor = .aetniaBlue
        }
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        contentView.layer.cornerRadius = 4
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.masksToBounds = true
        
        contentView.setupShadow(opacity: 1, radius: 1, offset: CGSize(width: 0, height: 1), color: .aetniaGrey)
        
        
        contentView.addSubview(timeLabel)
        timeLabel.fillSuperview()
        timeLabel.backgroundColor = .white
        timeLabel.textAlignment = .center
        timeLabel.textColor = .aetniaBlue
        timeLabel.font = timeLabel.font.withSize(16)
        
        
    }
}
