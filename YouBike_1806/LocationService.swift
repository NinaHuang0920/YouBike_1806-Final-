//
//  LocationService.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/27.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit
import CoreLocation

protocol LocationServiceDelegate {
    func tracingDidUpdateLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: Error)
    func tracingLocationDidChangeAuthorization(status: CLAuthorizationStatus)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate!
    var status: CLAuthorizationStatus?
    
    private override init() {
        super.init()

        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else { return }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestLocation()
    }
   
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func startUpdatingHeading() {
        self.locationManager?.startUpdatingHeading()
    }
    
    func requestWhenInUseAuthorization() {
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
      return  CLLocationManager.authorizationStatus()
    }
    
    func requestLocation() {
        self.locationManager?.requestLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        manager.stopUpdatingLocation()
        guard let location = locations.first else { return }
        self.currentLocation = location
        updateLocation(currentLocation: location)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
        updateLocationDidChangeAuthorization(status: status)
    }
    
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingDidUpdateLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: Error) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    private func updateLocationDidChangeAuthorization(status: CLAuthorizationStatus) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidChangeAuthorization(status: status)
    }
    
}
