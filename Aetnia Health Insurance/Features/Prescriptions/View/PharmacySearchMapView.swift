//
//  PharmacySearchMapView.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/19/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct PharmacySearchMapView: UIViewRepresentable {
    typealias UIViewType =  MKMapView
    
    @ObservedObject var navigationHelper: NavigationHelper = NavigationHelper()
    var description: String?
    @State var addresses = Set<Address>()
    @State var mapView = MKMapView()
    
    func getAddressAndAddressName(completion: @escaping (Address, String) -> Void) {
        navigationHelper.findPharmacy { (address, name) in
            DispatchQueue.main.async {
               completion(address, name)
            }
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<PharmacySearchMapView>) -> MKMapView {
        self.mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<PharmacySearchMapView>) {
        
    }
    
    

        
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var mapView: PharmacySearchMapView
        
        init(_ mapView: PharmacySearchMapView) {
            self.mapView = mapView
            super.init()
            //self.mapView.navigationHelper = NavigationHelper(mapView: self.mapView.$mapView)
            self.mapView.navigationHelper.mapView = self.mapView.mapView
            self.mapView.navigationHelper.findPharmacy { _,_ in }
            DispatchQueue.main.async {
                self.mapView.addresses = self.mapView.navigationHelper.matchingAddresses
               
            }
            
        }

        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            let reuseIdentifier = "Pharmacy"
            
            //let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
                        
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            btn.setImage(UIImage(systemName: "location"), for: .normal)
           
            btn.tintColor = .aetniaBlue
            annotationView.rightCalloutAccessoryView = btn
            
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let destination = self.mapView.navigationHelper.matchingItem {
                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                destination.openInMaps(launchOptions: launchOptions)
            }
            
            
            
        }
        
    }
       
}

