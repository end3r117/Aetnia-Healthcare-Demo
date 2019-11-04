//
//  HomeView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var homeViewModel: HomeViewModel
    
    var body: some View {
        Text(homeViewModel.userFirstName)
    }
}
