//
//  Capital.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/11/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?
    
    init(cityName: String, coordinate: CLLocationCoordinate2D, info: String?) {
        self.title = info
        self.coordinate = coordinate
        self.info = cityName
    }
}
