//
//  LocationManager.swift
//  ItemFinder
//
//  Created by Mattias Törnqvist on 2020-06-04.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    
//    MARK: - API
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            Void()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
}

extension LocationManager {
    
    func getPlace(for location: CLLocation, completion: @escaping(CLPlacemark?) -> Void) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            guard error == nil else {
                print("DEBUG Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("DEBUG Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
        
    }
}
