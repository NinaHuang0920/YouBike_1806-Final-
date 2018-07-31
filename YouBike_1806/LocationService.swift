//
//  LocationService.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/27.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
//    func tracingLocationDidChangeAuthorization(status: CLAuthorizationStatus)
//    func showOpenAuM(bool: Bool)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.startUpdatingLocation()
        return manager
    }()
    
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    private override init() {
        super.init()

//        self.locationManager = CLLocationManager()
//        guard let locationManager = self.locationManager else {
//            return
//        }
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
//            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
//        } else if CLLocationManager.authorizationStatus() == .denied {
//            guard let delegate = self.delegate else {
//                return
//            }
//            delegate.showOpenAuM(bool: true)
//        }

//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
//        locationManager.delegate = self
    }
    
    func requestWhenInUseAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingHeading() {
        self.locationManager.startUpdatingHeading()
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        guard let location = locations.first else {
            return
        }
        self.currentLocation = location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error)
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//        updateLocationDidChangeAuthorization(status: status)
//
//    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
//    private func showOpen(bool:Bool) {
//        guard let delegate = self.delegate else {
//            return
//        }
//        delegate.showOpenAuM(bool: bool)
//    }
    
//    private func updateLocationDidChangeAuthorization(status: CLAuthorizationStatus) {
//        guard let delegate = self.delegate else {
//            return
//        }
//        delegate.tracingLocationDidChangeAuthorization(status: status)
//    }
    
}
