//
//  UserInfoViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

struct UserInfoViewModel {
    private var userViewModel: UserViewModel
    var appointments: [Appointment] { get { userViewModel.user.appointments }}
    var userFirstName: String { get { userViewModel.firstName } }
    var userLastName: String { get { userViewModel.lastName } }
    var userMemberID: String { get { userViewModel.memberID } }
    var userGroupID: String { get { userViewModel.groupID } }
    private var originalAvatar: Avatar!
    var avatar: Avatar { get { userViewModel.avatar} set { userViewModel.avatar = newValue } }
    var userAvatarView: AvatarView
    func refreshAvatar(_ radius: CGFloat = 200) -> AvatarView {
        return AvatarView(gender: self.avatar.gender, diameter: radius)
    }
    func getUserAvatarView(_ radius: CGFloat) -> AvatarView { AvatarView(avatar: AvatarMaker.resizeAvatar(userViewModel.avatar, diameter: radius)) }
    var userMedicalType: InsuranceType { get { userViewModel.medicalInsuranceType }}
    var userDentalType: InsuranceType { get { userViewModel.dentistInsuranceType }}
    
    var doctorSearchRow: DoctorSearchRow {
        get {
            DoctorSearchRow(viewModel: DoctorSearchRowViewModel(doctor: userViewModel.primaryCarePhysician))
        }
    }
    var dentistSearchRow: DoctorSearchRow {
        get {
            DoctorSearchRow(viewModel: DoctorSearchRowViewModel(doctor: userViewModel.primaryDentist))
        }
    }
    
    enum Change {
        case revert
        case save
    }
    
    mutating func changeAvatar(_ change: Change, avatarView: AvatarView? = nil) {
        switch change {
        case .revert:
            avatar = userViewModel.avatar
        case .save:
            if avatarView != nil {
                self.avatar = avatarView!.avatar
                self.originalAvatar = avatarView!.avatar
            }
        }
        
    }
    
    init(model: UserViewModel) {
        self.originalAvatar = model.avatar
        self.userViewModel = model
        self.userAvatarView = AvatarView(avatar: model.avatar)
        
    }
    
}
