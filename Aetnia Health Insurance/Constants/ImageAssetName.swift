//
//  ImageAssetName.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import Foundation

enum ImageAssetName: String, CaseIterable, Codable {
    case loginBackground = "LoginBackground"
    case logoutButton
    case documents
    case documentsFilled = "documents_filled"
    case docSearch = "docsearch"
    case docSearchFilled = "docsearch_filled"
    case prescriptions
    case prescriptionsFilled = "prescriptions_filled"
    case notificationsBadged = "notifications_badged"
    case notificationsBadgedFilled = "notifications_badged_filled"
    case home
    case homeFilled = "home_filled"
    case caduceus
    case office1, office2, office3, office4, office5, office6
    case officeDentist1 = "office_dentist1"
    case officeDentist2 = "office_dentist2"
    case officeDentist3 = "office_dentist3"
    case dentist1, dentist2, dentist3, dentist4
    case dentistBanner1 = "dentistbanner1"
    case calendar, call, message, directions
}
