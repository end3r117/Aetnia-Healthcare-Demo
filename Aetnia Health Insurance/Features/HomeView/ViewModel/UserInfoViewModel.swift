//
//  UserViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/5/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import SwiftUI

class UserInfoViewModel: ObservableObject {
    @EnvironmentObject var userAuth: UserAuth
    
    var user: User { get { userAuth.loggedInUser} set { userAuth.loggedInUser = newValue }}
    var documents: [Document]  {
        get {
            user.documents.map({$0})
        }
    }
    var avatar: Avatar { get { user.avatar } set { user.avatar = newValue }}
    var firstName: String { get { user.firstName } set { user.firstName = newValue }}
    var lastName: String { get { user.lastName }  set { user.lastName = newValue }}
    var addressStreet: String { get { user.address.street }  set { user.address.street = newValue }}
    var addressApt: String { get { user.address.apt }  set { user.address.apt = newValue }}
    var addressState: String { get { user.address.state }  set { user.address.state = newValue }}
    var addressCity: String { get { user.address.city }  set { user.address.city = newValue }}
    var addressZip: String { get { user.address.zip }  set { user.address.zip = newValue }}
    var fullAddress: String {
        get {
            return "\(user.address.street)\n\(user.address.city), \(user.address.state) \(user.address.zip)\n\(user.address.country)"
        }
    }
    var phoneNumberCountryCode: Int { get {user.phoneNumber.countryCode } set { user.phoneNumber.countryCode = newValue }}
    var phoneNumberAreaCode: Int { get {user.phoneNumber.areaCode } set { user.phoneNumber.areaCode = newValue }}
    var phoneNumberAreaNumber: Int { get {user.phoneNumber.number } set { user.phoneNumber.number = newValue }}
    
    var fullPhoneNumber: String {
        get {
            return "+\(user.phoneNumber.countryCode) (\(user.phoneNumber.areaCode))\(user.phoneNumber.number.digits.prefix(3))-\(user.phoneNumber.number.digits[3...user.phoneNumber.number.digits.endIndex])"
        }
    }
    var medicalInsuranceType: InsuranceType { get { user.coverageInfo.PCPInsuranceType } set {user.coverageInfo.PCPInsuranceType = newValue }}
    var dentistInsuranceType: InsuranceType { get { user.coverageInfo.dentistInsuranceType } set { user.coverageInfo.dentistInsuranceType = newValue }}
    var primaryCarePhysician: Doctor { get { user.coverageInfo.primaryCarePhysician } set { user.coverageInfo.primaryCarePhysician = newValue }}
    var primaryDentist: Doctor { get { user.coverageInfo.primaryDentist } set { user.coverageInfo.primaryDentist =  newValue }}
    var memberID: String { get { user.coverageInfo.memberID }}
    var groupID: String { get { user.coverageInfo.groupNumber }}
    private var originalAvatar: Avatar!
    
    var userAvatarView: AvatarView { get { AvatarView(avatar: user.avatar) } set { user.avatar = newValue.avatar }}
    func refreshAvatar(_ radius: CGFloat = 200) -> AvatarView {
        return AvatarView(gender: self.avatar.gender, diameter: radius)
    }
    func getUserAvatarView(_ radius: CGFloat) -> AvatarView { AvatarView(avatar: AvatarMaker.resizeAvatar(user.avatar, diameter: radius)) }
    
    var doctorSearchRow: DoctorSearchRow {
        get {
            DoctorSearchRow(viewModel: DoctorSearchRowViewModel(doctor: primaryCarePhysician))
        }
    }
    var dentistSearchRow: DoctorSearchRow {
        get {
            DoctorSearchRow(viewModel: DoctorSearchRowViewModel(doctor: primaryDentist))
        }
    }
    
    @Published var appointments: [Appointment]
    
    enum Change {
        case revert
        case save
    }
    
    func changeAvatar(_ change: Change, avatarView: AvatarView? = nil) {
        switch change {
        case .revert:
            avatar = user.avatar
        case .save:
            if avatarView != nil {
                self.avatar = avatarView!.avatar
                self.user.avatar = avatarView!.avatar
                self.userAuth.updateUser()
                self.userAvatarView = avatarView!
                self.originalAvatar = avatarView!.avatar
            }
            
        }
    }
    
    init(userAuth: EnvironmentObject<UserAuth>) {
        self._userAuth = userAuth
        self.appointments = userAuth.wrappedValue.loggedInUser.appointments
    }
}




