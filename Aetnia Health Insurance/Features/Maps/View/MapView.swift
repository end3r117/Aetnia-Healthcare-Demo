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
    var description: String?
    var avatar: Avatar?
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        setMapLocation(on: mapView)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    private func setMapLocation(on mapView: MKMapView) {
        let locationManager = GeolocationHelper()
//        let eiffelTower = "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France"
        locationManager.getLocationFromCityName(cityName) { location in
            guard let location = location else { return }
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
            mapView.setRegion(region, animated: false)
            
            let capital = Capital(cityName: self.cityName, coordinate: center, info: self.description)
            
            mapView.addAnnotation(capital)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, avatar: self.avatar)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var mapView: MapView
        var avatar: Avatar?
        
        init(_ mapView: MapView, avatar: Avatar?) {
            self.mapView = mapView
            self.avatar = avatar
        }
        
//        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//            guard let capital = view.annotation as? Capital else { return }
//
//
//        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is Capital else { return nil }
            
            let reuseIdentifier = "Capital"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            //if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            btn.tintColor = .aetniaBlue
            annotationView?.rightCalloutAccessoryView = btn
            
            if self.avatar != nil {
                let avatarView = AvatarView(avatar: AvatarMaker.resizeAvatar(self.avatar!, diameter: 50))
                annotationView?.image = avatarView.getUIImage()
            }
            
            
            return annotationView
        }
    }
       
}
