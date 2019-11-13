//
//  ScrollView(MOD)ShowsScrollViewIndicators.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/15/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct ShowsScrollViewInsets: ViewModifier {
    
    init(_ choice: Bool) {
        UITableView.appearance().showsVerticalScrollIndicator = choice
        UIScrollView.appearance().showsVerticalScrollIndicator = choice
    }
    
    public func body(content: Content) -> some View {
            content
    }
}


