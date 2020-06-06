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
    
    func getPlace(completion: @escaping(Result<CLPlacemark, LocationError>) -> Void) {
        
        guard let currentLocation = locationManager.location else {
            completion(.failure(.couldNotRetreiveLocation))
            return
        }
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, err) in
            
            if err != nil {
                completion(.failure(.couldNotRetreivePlacemarks))
                return
            }
            
            guard let placemark = placemarks?[0] else {
                completion(.failure(.couldNotRetreivePlacemarks))
                return
            }
            
            completion(.success(placemark))
        }
    }
}

//Custom error
    enum LocationError: Error {
        case couldNotRetreiveCoordinates
        case couldNotRetreiveLocation
        case couldNotRetreivePlacemarks
        case couldNotUploadUserLocation
    }

//Custom error descriptions
extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .couldNotRetreiveLocation:
            return NSLocalizedString("Error retreiving user location.", comment: "Error retreiving user location")
        case .couldNotRetreivePlacemarks:
            return NSLocalizedString("Error retreiving location placemarks.", comment: "Error retreiving location placemarks")
        case .couldNotRetreiveCoordinates:
            return NSLocalizedString("Error retreiving user coordinates.", comment: "Error retreiving user coordinates")
        case .couldNotUploadUserLocation:
            return NSLocalizedString("Error uploading user locations.", comment: "Error uploading user location")
        }
    }
}


