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
    var model: DoctorSearchViewModel = DoctorSearchViewModel()
    @EnvironmentObject var navConfig: NavConfig
    @State var showDetail: Bool = false
    @State var query: String = ""
    @State var showClear: Bool = false
    @State var showFilter: Bool = false
    @State var includeDoctors = true
    @State var includeDentists = true
    @State var count: Int = 1
    
    var body: some View {
        ZStack {
            //GeometryReader { geo in
            Rectangle()
                .fill()
                .foregroundColor(Color(UIColor.systemGroupedBackground))
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill()
                            .foregroundColor(Color(.tertiarySystemBackground))
                            .overlay(
                                ZStack(alignment: .leading) {
                                    TextField("Search", text: self.$query, onEditingChanged: {start in
                                        if start {
                                            self.showClear = true
                                        }else {
                                            self.showClear = false
                                        }
                                    }, onCommit: {
                                        self.showClear = false
                                    }).padding().padding(.leading, 8)
                                        .modifier(ClearButton(text: self.$query, visible: self.$showClear))
                                    Image(systemName: "magnifyingglass").foregroundColor(Color(.label)).opacity(0.6).padding(4)
                                }.animation(nil)
                        )
                            .frame(width: UIScreen.main.bounds.width * 0.70, height: 30)
                    }
                    FilterButton(showFilter: self.$showFilter)
                }.padding(8)
                if self.showFilter {
                    HStack {
                        Spacer()
                        BEMCheckBoxView(on: self.$includeDoctors)
                            .padding(2)
                            .frame(width: 24, height: 24)
                        Text("Doctors")
                        Spacer()
                        BEMCheckBoxView(on: self.$includeDentists)
                            .padding(2)
                            .frame(width: 24, height: 24)
                        Text("Dentists")
                        Spacer()
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: 40)
                }
                List {
                    Section(header: Text("Results")) {
                        if self.model.filtered(query: self.$query, includeDoctors: self.$includeDoctors, includeDentists: self.$includeDentists).count == 0 {
                            Text("No doctors match your search criteria.")
                        }else {
                            ForEach(self.model.filtered(query: self.$query, includeDoctors: self.$includeDoctors, includeDentists: self.$includeDentists), id: \.self){ model in
                                VStack {
                                    NavigationLink(destination: DoctorInfoView(dataModel: DoctorSearchRowViewModel(doctor: model), avatar: model.avatar)
                                        .modifier(AetniaNavConfig(navTitle: "Aetnia"))
                                    ) { //.modifier(ShowsScrollViewInsets(false))) {
                                        DoctorSearchRow(viewModel: DoctorSearchRowViewModel(doctor: model))
                                    }
                                }
                            }
                        }
                    }
                }.listStyle(GroupedListStyle()).dismissKeyboardOnDragGesture()
            }
        }
    }
}


struct FilterButton: View {
    //var geo: GeometryProxy
    @Binding var showFilter: Bool
    
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.showFilter.toggle()
            }
        }, label: {
            RoundedRectangle(cornerRadius: 8)
                .fill()
                .frame(maxHeight:  30)
                .foregroundColor(Color(.aetniaBlue))
                .overlay(Text(self.showFilter ? "Hide Filters" : "Show Filters").foregroundColor(Color(.systemBackground)).animation(nil))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.30)
        })
    }
    
}
