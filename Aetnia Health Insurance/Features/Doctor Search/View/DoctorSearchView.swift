//
//  DoctorSearchView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/6/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import Combine

struct DoctorSearchView: View {
    var doctorSearchViewModel: DoctorSearchViewModel
    @State var showDetail: Bool = false
    
    init(viewModel: DoctorSearchViewModel) {
        self.doctorSearchViewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
                .foregroundColor(Color(UIColor.systemGroupedBackground))
            VStack {
                Spacer()
                    .frame(maxHeight: UIScreen.main.bounds.height / 8)
            }
            List {
                Section(header: Text("Results")) {
                    if doctorSearchViewModel.dataSource.isEmpty {
                        Text("No doctors match your search criteria.")
                    }else {
                        Group{
                            ForEach(doctorSearchViewModel.dataSource.sorted(by: {$0.firstName < $1.firstName})){ model in
                                NavigationLink(destination: DoctorInfoView(dataModel: DoctorSearchRowViewModel(doctor: model), avatar: model.avatar!).navigationBarTitle("Dr. \(model.lastName)")) {
                                    DoctorSearchRow(viewModel: DoctorSearchRowViewModel(doctor: model))
                                }
                            }.drawingGroup()
                        }
                    }
                }
            }.listStyle(GroupedListStyle())
        }
    }
}
