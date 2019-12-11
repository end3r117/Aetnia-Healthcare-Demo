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
    @State var mapItem: MKMapItem? = nil
    
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
                                    .frame(minWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height / 6)
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
                            AvatarView(avatar: AvatarMaker.resizeAvatar(self.$avatar, diameter: (self.navConfig.orientation == .portrait ? 140 : 100)))
                                .padding(.top, 12)
                                .animation(nil)
                                .layoutPriority(1)
                            
                        }
                    }
                    ScrollView {
                        VStack {
                            Text("\(self.dataModel.doctorFirstName) \(self.dataModel.doctorLastName), \(self.dataModel.docType.rawValue)").bold()
                            Text("\(self.dataModel.addressNumberStreet)")
                            Text("\(self.dataModel.addressCityState) \(self.dataModel.addressZip)")
                                .layoutPriority(1)
                        }
                        VStack {
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
                                ContactButton(text: "Message", size: geo.size, textColor: Color(.systemBackground), backgroundColor: .navBarDarkMode, icon: Image(.message).renderingMode(.template), disabled: false)
                                    
                                    .padding(.top, 4)
                            }
                            DoctorInfoMapView(cityName: self.dataModel.addressCityState, description: "Dr. \(self.dataModel.doctorLastName)", avatar: self.dataModel.avatar, mapItem: self.$mapItem)
                                .frame(minWidth: UIScreen.main.bounds.width * 0.7, minHeight: (self.navConfig.orientation == .portrait ? 200 : 100), maxHeight: UIScreen.main.bounds.height * 0.45)
                                .padding()
                            Button(action: {
                                if let destination = self.mapItem {
                                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                    destination.openInMaps(launchOptions: launchOptions)
                                }
                            }, label: {
                                HStack {
                                    Text("Get Directions")
                                    Image(systemName: "location")
                                }.foregroundColor(Color(.label))
                            })
                        }.frame(width: UIScreen.main.bounds.width)
                        
                        Spacer()
                    }.frame(width: UIScreen.main.bounds.width)
                    
                }
                    .navigationBarItems(leading:
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color(.systemBackground))
                            Text("Results")
                                .foregroundColor(Color(.systemBackground))
                        })
                    )
                .blur(radius: self.showEnlarged ? 4 : 0)
            }
            if self.showEnlarged {
                withAnimation {
                    ZoomableImageView(image: self.$enlargedImage, visible: self.$showEnlarged)
                }
            }
        }
    }
}


