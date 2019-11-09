//
//  AppointmentRow.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/9/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct AppointmentRow: View {
    var viewModel: AppointmentRowViewModel
    @State var height: CGFloat = 0
    init(model: AppointmentRowViewModel) {
        self.viewModel = model
    }
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.service).bold()
                    Text(viewModel.date)
                    Text(viewModel.time)
                }
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                VStack {
                    SwiftUITextView(address: "\(viewModel.doctor)\n\(viewModel.addressNumberStreet)\n\(viewModel.addressCityState) \(viewModel.addressZip)", height: self.$height)
                        .padding(.top, 0)
                        .frame(height: self.$height.wrappedValue)
                }
            }
        }
    }
}
