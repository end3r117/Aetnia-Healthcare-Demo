//
//  NavigationHelper.swift
//  Aetnia Health Insurance
//
//  Created by Anthony Rosario on 11/19/19.
//  Copyright © 2019 Faultliner Applications, LLC. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

class NavigationHelper: NSObject, ObservableObject {
    let locationManager = CLLocationManager()
    @State var currentLocation: CLLocation?
    @Published var mapView: MKMapView = MKMapView()
    @Published var matchingItem: MKMapItem?
    @Published var matchingAddresses = Set<Address>()
    @Published var firstMatchingAddress: Address = .defaultAddress {
        didSet {
            print(firstMatchingAddress.street)
        }
    }
    @Published var firstAddressName: String = "" {
        didSet {
            print(firstAddressName)
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    convenience init(mapView: Binding<MKMapView>) {
        self.init()
        self.mapView = mapView.wrappedValue
    }
    
    func findPharmacy(_ completion: @escaping (Address, String) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "pharmacy"
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItem = response.mapItems.first
            
            guard let matchingItem = self.matchingItem else { return }
            DispatchQueue.main.async {
                self.matchingAddresses.removeAll()
                self.matchingAddresses.insert(self.parseAddress(selectedItem: matchingItem.placemark))
                
                let note = MKPointAnnotation()
                note.coordinate = matchingItem.placemark.coordinate
                note.title = matchingItem.placemark.name
                let addy = self.parseAddress(selectedItem: matchingItem.placemark)
                self.firstMatchingAddress = addy
                let name = note.title!
                self.firstAddressName = name
                completion(addy, name)
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(note)
                
                let location = matchingItem.placemark
                
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
                self.mapView.setRegion(region, animated: false)
                
                
            }
        }
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> Address {
        Address(title: "\(selectedItem.name ?? "")",street: "\(selectedItem.subThoroughfare ?? "") \(selectedItem.thoroughfare ?? "")", apt: "", city: selectedItem.locality ?? "", state: selectedItem.administrativeArea ?? "California", zip: selectedItem.postalCode ?? "", country: "")
    }
    
    private func popUp() {
        let alertController = UIAlertController(quicklyUsing: .OK, alertTitle: "Access Denied", alertMessage: "If you'd like to get driving directions, you must authorize Aetnia to use your location in the Settings app.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (alertAction) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.nav.topViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension NavigationHelper: CLLocationManagerDelegate {
    func getLocationFromCityName(_ name: String, completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied { popUp() }
        
        if status == .authorizedWhenInUse { locationManager.requestLocation() }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
                        DispatchQueue.main.async {
                            self.findPharmacy { addy, name in
                                DispatchQueue.main.async {
                                    self.firstMatchingAddress = addy
                                    self.firstAddressName = name
                                }
                                
                            }
                        }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
