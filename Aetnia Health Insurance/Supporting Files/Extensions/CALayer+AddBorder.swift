//
//  CALayer+AddBorder.swift
//  *********
//
//  Created by Anthony Rosario on 4/17/19.
//  Copyright © 2019 Anthony Rosario. All rights reserved.
//

import UIKit


extension UIView {
    
    func createBorderForReuse(edge side: UIRectEdge, color: UIColor, thickness: CGFloat, padding: UIEdgeInsets?) -> CALayer {
        let color = color.cgColor
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .left: border.frame = CGRect(x: bounds.minX, y: bounds.minY, width: thickness, height: frame.height); break
        case .right: border.frame = CGRect(x: bounds.maxX, y: bounds.minY, width: thickness, height: frame.height); break
        case .top: border.frame = CGRect(x: bounds.minX, y: bounds.minY + thickness + (padding?.top ?? 0), width: frame.width, height: thickness); break
        case .bottom: border.frame = CGRect(x: bounds.minX, y: bounds.maxY, width: frame.width, height: thickness); break
        default:
            break
        }
        
        return border
    }

    func addBorder(edge side: UIRectEdge, color: UIColor, thickness: CGFloat, padding: UIEdgeInsets?) {
        let color = color.cgColor
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .left: border.frame = CGRect(x: bounds.minX, y: bounds.minY, width: thickness, height: frame.height); break
        case .right: border.frame = CGRect(x: bounds.maxX, y: bounds.minY, width: thickness, height: frame.height); break
        case .top: border.frame = CGRect(x: bounds.minX, y: bounds.minY + thickness + (padding?.top ?? 0), width: frame.width, height: thickness); break
        case .bottom: border.frame = CGRect(x: bounds.minX, y: bounds.maxY, width: frame.width, height: thickness); break
        default:
            break
        }
        
        layer.addSublayer(border)
    }
}
