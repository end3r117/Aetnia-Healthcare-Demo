//
//  HomeView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Combine
import SwiftUI

struct HomeView: View {
    @State var model: UserInfoViewModel
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var navConfig: NavConfig
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var showDoctor: Bool = false
    @State var showDentist: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
                .foregroundColor(Color(UIColor.systemGroupedBackground))
            VStack {
                Spacer()
                    .frame(maxHeight: UIScreen.main.bounds.height / 8)
            }
            VStack {
                NavigationLink(destination:
                    UserInfoView(model: self.$model)
                    
                ) {
                    ZStack {
                        HStack(alignment: .top) {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 100, height: 100)
                            VStack(alignment: .leading) {
                                Text("\(self.model.userFirstName) \(self.model.userLastName)")
                                    .font(.system(size: 26, weight: .medium))
                                    .padding(.bottom, 4)
                                    .padding(.top, 2)
                                Group {
                                    Text("MemberID: ").font(.system(size: 16, weight: .regular)) +
                                        Text("\(self.model.userMemberID)").font(.system(size: 16, weight: .light))
                                }.padding(.top, 4)
                                Group {
                                    Text("GroupID: ").font(.system(size: 16, weight: .regular)) +
                                        Text("\(self.model.userGroupID)").font(.system(size: 16, weight: .light))
                                }.padding(.top, 4)
                            }
                            Spacer()
                        }
                        HStack {
                            self.model.getUserAvatarView(100)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }.padding()
                        .background(Color(.systemBackground))
                        .accentColor(Color(.label))
                }
                List {
                    Section {
                        HStack{
                            Text("Status").font(.system(size: 20, weight: .medium))
                            Spacer()
                            Text("You're covered!").font(.system(size: 22, weight: .bold)).foregroundColor(.green)
                        }
                    }
                    Section(header: Text("Coverage Info")) {
                        HStack{
                            Text("Medical Plan Type")
                            Spacer()
                            Text(self.model.userMedicalType.rawValue)
                        }
                        HStack {
                            Text("Dental Plan Type")
                            Spacer()
                            Text(self.model.userDentalType.rawValue)
                        }
                    }
                    Section(header: Text("Primary Care Physician")) {
                        NavigationLink(destination:
                                DoctorInfoView(dataModel: self.model.doctorSearchRow.viewModel, avatar: self.model.doctorSearchRow.viewModel.avatar!)
                            .navigationBarTitle("Dr. \(self.model.doctorSearchRow.viewModel.doctorLastName)")
                            .navigationBarItems(leading:
                                Button(action: {
                                    self.showDoctor = false
                                }, label: {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(Color(.systemBackground))
                                    Text("Home")
                                })
                            )
                            
                        , isActive: self.$showDoctor) {
                            self.model.doctorSearchRow
                        }
                    }
                    Section(header: Text("Preferred Dentist")) {
                        NavigationLink(destination:
                                DoctorInfoView(dataModel: self.model.dentistSearchRow.viewModel, avatar: self.model.dentistSearchRow.viewModel.avatar!)
                                .navigationBarTitle("Dr. \(self.model.dentistSearchRow.viewModel.doctorLastName)")
                                .navigationBarItems(leading:
                                Button(action: {
                                    self.showDentist = false
                                }, label: {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(Color(.systemBackground))
                                    Text("Home")
                                })
                            )
                            
                        , isActive: self.$showDentist) {
                            self.model.dentistSearchRow
                        }
                    }
                    Section(header: Text("Upcoming Appointments")) {
                        if !self.userAuth.loggedInUser.appointments.isEmpty {
                            ForEach(self.userAuth.loggedInUser.appointments, id: \.self) { appt in
                                AppointmentRow(model: AppointmentRowViewModel(appointment: appt))
                            }.onDelete{ offsets in
                                self.deleteAppointments(at: offsets)

                            }
                        }else {
                            Text("None")
                        }
                        
                    }
                    Section(header: Text("Prescriptions Waiting")) {
                        HStack{
                            Text("1")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }.listStyle(GroupedListStyle())
            }.background(AetniaBackground())
            
        }
    }
    
    func deleteAppointments(at offsets: IndexSet) {
        DispatchQueue.main.async {
            print(self.userAuth.loggedInUser.appointments.count)
        self.userAuth.loggedInUser.appointments.remove(atOffsets: offsets)
            print(self.userAuth.loggedInUser.appointments.count)
        }
    }
}
