//
//  PendingPrescriptionItem.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/30/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import MapKit

struct PendingPrescriptionItem: View, Identifiable {
    @State var showingMapDetail = false
    var id = UUID()
    var prescription: Prescription
    @State var pharmacySearchMapView = PharmacySearchMapView()
    var prescriptionName: String {
        get {
            "\(prescription.medicineName) \(prescription.dose)"
        }
    }
    
    @State var pharmacyName: String = ""
    @State var pharmacyAddress: Address = Address.defaultAddress
    @State var height: CGFloat = 40
    
    init(prescription: Prescription) {
        self.prescription = prescription
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Awaiting Pick-up"), content: {
                    Button(action: {
                        if self.pharmacyAddress == .defaultAddress && self.pharmacyName == "" {
                        withAnimation {
                            DispatchQueue.main.async {
                                self.pharmacySearchMapView.getAddressAndAddressName { address, name in
                                    DispatchQueue.main.async {
                                        self.pharmacyName = name
                                        self.pharmacyAddress = address
                                    }
                                }
                                self.showingMapDetail.toggle()
                            }
                        }
                        }else {
                            DispatchQueue.main.async {
                                self.showingMapDetail.toggle()
                            }
                        }
                    }, label: {
                        HStack {
                            Text(prescriptionName)
                            Spacer()
                            Image(systemName: showingMapDetail ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                        }.padding()
                            .font(.headline)
                    })
                    if showingMapDetail {
                        VStack {
                            pharmacySearchMapView
                                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)))
                                .frame(height: UIScreen.main.bounds.height / 3)
                            Text(pharmacyName)
                                .bold()
                            VStack {
                            Button(action: {
                                if let destination = self.pharmacySearchMapView.navigationHelper.matchingItem {
                                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                    destination.openInMaps(launchOptions: launchOptions)
                                }
                            }, label: {
                                Text("\(pharmacyAddress.street)\n\(pharmacyAddress.city), \(pharmacyAddress.state) \(pharmacyAddress.zip)")
                                .underline()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(.label))
                                .padding(.top, 0)
                                }).buttonStyle(PlainButtonStyle())
//                            .frame(height: UIScreen.main.bounds.height / 10)
                                Spacer()
                            }
                        }.accentColor(Color(.label))
                        
                        
                    }
                })
                
            }.listStyle(GroupedListStyle())
            //Spacer()
        }.accentColor(Color(.label))
    }
}
