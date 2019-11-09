//
//  AppColorConstants.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

enum AssetsCatelogColor: String {
    case aetniaBlue, aetniaGrey, navBarColor, navBarLightMode, navBarDarkMode, caduceus
}

extension Color {
    
    //static let aetniaBlue = Color(UIColor.rgb(red: 74, green: 144, blue: 226))
    static let aetniaGrey = Color.appColor(.aetniaGrey)
    static let aetniaBlue = Color.appColor(.aetniaBlue)
    static let navBarDarkMode = Color(UIColor.rgb(red: 101, green: 160, blue: 229))
    static let navBarLightMode = Color(UIColor.rgb(red: 92, green: 151, blue: 220))
    static let aetniaLightBlue = Color(UIColor.aetniaLightBlue)
    
    static func appColor(_ adaptiveColorSet: AssetsCatelogColor) -> Color {
        return Color(adaptiveColorSet.rawValue)
    }
    

}

extension UIColor {
    static let aetniaGrey = UIColor.appColor(.aetniaGrey)
    static let aetniaBlue = UIColor.rgb(red: 74, green: 144, blue: 226)
    static let aetniaLightBlue = UIColor.rgb(red: 226, green: 249, blue: 255)
    
    static func appColor(_ adaptiveColorSet: AssetsCatelogColor) -> UIColor {
        return UIColor(named: adaptiveColorSet.rawValue)!
    }
}
