//
//  DoctorSearchRowViewModel.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/7/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct DoctorSearchRowViewModel {
    @State var doctor: Doctor
    var avatar: Avatar? { get { doctor.avatar } set { doctor.avatar = newValue }}
    var doctorFirstName: String { get { doctor.firstName }}
    var doctorLastName: String { get { "\(doctor.lastName)" }}
    var doctorAvatarView: AvatarView { get { AvatarView(avatar: doctor.avatar!) }}
    var docType: DoctorType { get { doctor is PhysicianModel ? .physician : .dentist }}
    var doctorOffice: ImageAssetName { get { doctor.officePhoto }}
    var doctorAddressFull: String { get { """
\(doctor.address.number) \(doctor.address.street)
\(doctor.address.city), \(doctor.address.state) \(doctor.address.zip)
""" }}
    var addressNumberStreet: String { get { "\(doctor.address.number) \(doctor.address.street)" }}
    var addressCityState: String { get { "\(doctor.address.city), \(doctor.address.state)" }}
    var addressZip: String { get { "\(doctor.address.zip)" }}
}
