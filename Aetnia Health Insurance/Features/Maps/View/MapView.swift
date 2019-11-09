//
//  MapView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/10/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    typealias UIViewType =  MKMapView
    
    var cityName: String
    let locationManager = GeolocationHelper()
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        setMapLocation(on: mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    private func setMapLocation(on mapView: MKMapView) {
        
//        let eiffelTower = "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France"
        
        self.locationManager.getLocationFromCityName(cityName) { location in
            guard let location = location else { return }
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: false)
        }
    }
       
}
