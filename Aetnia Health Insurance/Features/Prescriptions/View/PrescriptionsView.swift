//
//  PrescriptionsView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/19/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import MapKit

struct PrescriptionsView: View {
    var prescriptionItems: [PendingPrescriptionItem]
    
    var body: some View {
        ForEach(prescriptionItems) { item in
            item
        }
    }
    
}

