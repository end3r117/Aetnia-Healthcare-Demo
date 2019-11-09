//
//  DoctorInfoView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/8/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import MapKit

struct DoctorInfoView: View {
    var dataModel: DoctorSearchRowViewModel
    @EnvironmentObject var navConfig: NavConfig
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var avatar: Avatar
    @State var showCalendar: Bool = false
    @State var enlargedImage: Image? = nil
    @State var showEnlarged = false
    @State var height: CGFloat = 0
    var mainImage: Image { get { Image(dataModel.doctorOffice) }}
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack {
                    ZStack {
                        if !self.showEnlarged {
                            VStack {
                                self.mainImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: 0, maxHeight: UIScreen.main.bounds.height / 5)
                                    .clipped()
                                    .onTapGesture {
                                        withAnimation {
                                            if self.enlargedImage != self.mainImage {
                                                self.enlargedImage = self.mainImage
                                            }
                                            self.showEnlarged.toggle()
                                        }
                                }
                                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                                Spacer()
                            }
                            AvatarView(avatar: AvatarMaker.resizeAvatar(self.$avatar, radius: (self.navConfig.orientation == .portrait ? 200 : 100)))
                                .padding(.top, UIScreen.main.bounds.height / 10)
                                .animation(nil)
                                .layoutPriority(1)
                        }
                    }
                    ScrollView {
                        VStack {
                            Text("\(self.dataModel.doctorFirstName) \(self.dataModel.doctorLastName), \(self.dataModel.docType.rawValue)").bold()
                            Text("\(self.dataModel.addressNumberStreet)")
                            Text("\(self.dataModel.addressCityStateZip)")
                                .layoutPriority(1)
                        }
                        VStack {
                            MapView(cityName: self.dataModel.addressCityStateZip)
                                .frame(width: UIScreen.main.bounds.width * 0.7, height: (self.navConfig.orientation == .portrait ? 200 : 100))
                                .padding()
                            Spacer()
                            VStack {
                                ContactButton(text: "Schedule Appointment", size: geo.size, textColor: Color(.systemBackground), backgroundColor: Color(.systemPurple), icon: Image(.calendar), action: {
                                    let windowRVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as? UINavigationController
                                    if windowRVC != nil {
                                        let vc = AppointmentsViewController(dataModel: self.dataModel, userAuth: self.userAuth)
                                        vc.view.backgroundColor = .systemBackground
                                        vc.navigationController?.navigationBar.tintColor = .label
                                        windowRVC?.present(vc, animated: true)
                                    }
                                })
                                Spacer()
                                ContactButton(text: "Call", size: geo.size, textColor: Color(.systemBackground), backgroundColor: Color(.systemGreen), icon: Image(.call).renderingMode(.original), disabled: true)
                                    .padding(.top, 4)
                            }
                            
                        }
                        
                        Spacer()
                    }
                }
                .blur(radius: self.showEnlarged ? 4 : 0)
                .navigationBarItems(leading:
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(.systemBackground))
                        Text("Results")
                    })
                )
            }.animation(nil)
            if self.showEnlarged {
                withAnimation {
                    ZoomableImageView(image: self.$enlargedImage, visible: self.$showEnlarged)
                }
            }
        }
    }
}


