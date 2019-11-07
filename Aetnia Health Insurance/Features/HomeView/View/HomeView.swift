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
        GeometryReader { geo in
            ScrollView {
                //Group {
                    VStack {
                        ZStack {
                        Button(action: {
                            
                        }, label: {
                                HStack(alignment: .top) {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 100, height: 100)
                                    VStack(alignment: .leading) {
                                        Text("\(self.homeViewModel.userFirstName) \(self.self.homeViewModel.userLastName)")
                                            .font(.system(size: 26, weight: .medium))
                                            .padding(.bottom, 4)
                                            .padding(.top, 2)
                                        Group {
                                            Text("MemberID: ").font(.system(size: 16, weight: .regular)) +
                                                Text("\(self.homeViewModel.userMemberID)").font(.system(size: 16, weight: .light))
                                        }.padding(.top, 4)
                                        Group {
                                            Text("GroupID: ").font(.system(size: 16, weight: .regular)) +
                                                Text("\(self.homeViewModel.userGroupID)").font(.system(size: 16, weight: .light))
                                        }.padding(.top, 4)
                                    }
                                    Spacer()
                                }
                        })
                            HStack {
                                self.homeViewModel.userAvatarView
                                Spacer()
                            }
                        }
                            .accentColor(Color(.label))
                            .buttonStyle(PlainButtonStyle())
                        HStack{
                            Text("Coverage Status:").font(.system(size: 20, weight: .medium))
                            Spacer()
                            Text("You're covered!").font(.system(size: 22, weight: .bold)).foregroundColor(.green)
                        }.padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding()
                //}
                //.background(Color.aetniaLightBlue)
            }.frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
