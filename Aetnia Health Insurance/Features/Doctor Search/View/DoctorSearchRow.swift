//
//  DoctorSearchRow.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct DoctorSearchRow: View {
    @State var viewModel: DoctorSearchRowViewModel
    @EnvironmentObject var navConfig: NavConfig
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                viewModel.doctorAvatarView
                VStack(alignment: .leading) {
                    Text("\(viewModel.doctorFirstName) \(viewModel.doctorLastName), \(viewModel.docType.rawValue)")
                        .fontWeight(.medium)
                    Text(viewModel.doctorAddressFull)
                        .fontWeight(.light)
                }
                Spacer()
            }
        }
    }
}
