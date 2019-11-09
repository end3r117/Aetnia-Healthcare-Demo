//
//  CalendarHeader.swift
//  
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import UIKit
import JTAppleCalendar

class AppointmentsCalendarHeader: JTAppleCollectionReusableView {
    
    var monthLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    
    var leftArrowButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("   <  ", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .aetniaBlue
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleLabel?.textColor = .aetniaBlue
        
        return btn
    }()
    
    var rightArrowButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("  >   ", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .aetniaBlue
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleLabel?.textColor = .aetniaBlue
        
        return btn
    }()
    
    var isCurrentMonth = false {
        didSet {
            DispatchQueue.main.async {
                if self.isCurrentMonth {
                    self.leftArrowButton.setTitleColor(UIColor(white: 1, alpha: 0.3), for: .normal)
                }else {
                    self.leftArrowButton.setTitleColor(.white, for: .normal)
                }
            }
        }
    }

    @objc func arrowTapped(_ sender: UIButton) {
        if sender == leftArrowButton {
            NotificationCenter.default.post(name: .calendarLeftOrRight, object: nil, userInfo: ["Direction":AppointmentsViewController.LeftOrRight.left])
        }else if sender == rightArrowButton {
            NotificationCenter.default.post(name: .calendarLeftOrRight, object: nil, userInfo: ["Direction":AppointmentsViewController.LeftOrRight.right])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

        addSubview(monthLabel)
        
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.systemFont(ofSize: monthLabel.font.pointSize, weight: .semibold)
        monthLabel.textColor = .aetniaBlue
        
        monthLabel.fillSuperview()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        monthLabel.text = dateFormatter.string(from: Date())
        
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
                
        NSLayoutConstraint.activate(constraintsAR)
        
        leftArrowButton.addTarget(self, action: #selector(arrowTapped(_:)), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(arrowTapped(_:)), for: .touchUpInside)
    }
    
    lazy var constraintsAR: [NSLayoutConstraint] = [
        leftArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        leftArrowButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
        leftArrowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        leftArrowButton.widthAnchor.constraint(equalToConstant: 40),
        
        rightArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        rightArrowButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
        rightArrowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        rightArrowButton.widthAnchor.constraint(equalToConstant: 40),
    ]
    
    deinit {
        print("VendorPageCalendarHeader de-init")
    }
}
