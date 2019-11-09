//
//  UserInfoView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct UserInfoView: View {
    @Binding var model: UserInfoViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var animation: Animation {
        Animation.easeInOut(duration: 2)
            .repeatCount(3)
    }
    @State var avatarView: AvatarView? = nil
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Button(action: {
                    DispatchQueue.main.async {
                        self.avatarView = self.model.refreshAvatar(300)
                    }
                }, label: {
                    self.avatarView ?? self.model.getUserAvatarView(300)
                })
                HStack {
                    Spacer()
                    Button(action: {
                        DispatchQueue.main.async {
                            self.model.changeAvatar(.revert)
                            self.avatarView = self.model.getUserAvatarView(300)
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .circular)
                                .fill()
                                .foregroundColor(Color(.aetniaGrey))
                            Text("Revert")
                                .foregroundColor(Color(.label))
                        }
                    }
                    Button(action: {
                        DispatchQueue.main.async {
                            self.model.changeAvatar(.save, avatarView: self.avatarView)
                            self.mode.wrappedValue.dismiss()
                        }
                    }){
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .circular)
                                .fill()
                                .foregroundColor(Color(.aetniaBlue))
                            Text("Save")
                                .foregroundColor(Color(.label))
                        }
                    }
                    Spacer()
                }
                Spacer()
                    .frame(height: max(geo.size.height / 2.2,  40))
            }
        .padding()
            .navigationBarItems(leading:
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(.systemBackground))
                    Text("Home")
                })
            )
        }
    }
}
