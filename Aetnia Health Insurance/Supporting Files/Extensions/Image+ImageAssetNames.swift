//
//  Image+ImageAssetNames.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/3/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI

extension Image {
    init(_ imageAssetName: ImageAssetName) {
        self.init(imageAssetName.rawValue)
    }
}
