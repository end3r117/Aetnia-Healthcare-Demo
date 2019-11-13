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
        DispatchQueue.main.async {
        
            self.setMapLocation(on: mapView) { coordinate in
            DispatchQueue.main.async {
            context.coordinator.capital = Capital(cityName: self.cityName, coordinate: coordinate, info: self.description)
            }
        }
        mapView.delegate = context.coordinator
        
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    private func setMapLocation(on mapView: MKMapView, _ completion: ((CLLocationCoordinate2D) -> Void)? = nil) {
        let locationManager = GeolocationHelper()
        //        let eiffelTower = "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France"
        DispatchQueue.main.async {
            locationManager.getLocationFromCityName(self.cityName) { location in
            DispatchQueue.main.async {
                guard let location = location else { return }
                
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
                mapView.setRegion(region, animated: false)
                
                let capital = Capital(cityName: self.cityName, coordinate: center, info: self.description)
                mapView.addAnnotation(capital)
            }
        }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, avatar: self.avatar)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var mapView: MapView
        var avatar: Avatar?
        var capital: Capital? = nil
        
        init(_ mapView: MapView, avatar: Avatar?) {
            self.mapView = mapView
            self.avatar = avatar
        }

        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let capital = view.annotation as? Capital else { return }
            let (lat, lng) = (capital.coordinate.latitude, capital.coordinate.longitude)
            
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)))
            source.name = "Source"

            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)))
            destination.name = self.mapView.description
            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            

        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is Capital else { return nil }
            
            let reuseIdentifier = "Capital"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
                        
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            btn.setImage(UIImage(systemName: "location"), for: .normal)
                //
           
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
