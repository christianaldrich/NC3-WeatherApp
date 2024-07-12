//
//  LocationManager.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import Foundation
import CoreLocation



class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate{
    
    var locationManager : CLLocationManager?
    
    @Published var longitude:Double = 0.0
    @Published var latitude:Double = 0.0
    @Published var currentLocation:  CLLocation?
    @Published var cityName: String = "Somewhere"
    
    override init() {
        super.init()
        checkIfLocationServiceIsEnabled()
    }
    
    func checkIfLocationServiceIsEnabled(){
        if CLLocationManager.locationServicesEnabled() {
                    locationManager = CLLocationManager()
                    locationManager?.delegate = self
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager?.requestWhenInUseAuthorization()
                    locationManager?.startUpdatingLocation()
                } else {
                    print("Show an alert letting them know this is off and to go turn it on.")
                }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("Lat : \(latitude)")
            print("Long : \(longitude)")
            
            DispatchQueue.main.async{
                self.currentLocation = location
            }
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                        if error == nil {
                            if let firstLocation = placemarks?[0],
                                let cityName = firstLocation.locality { // get the city name
                                self?.locationManager!.stopUpdatingLocation()
                                
                                DispatchQueue.main.async{
                                    self!.cityName = cityName
                                }
                                
                            }
                        }
                    }
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    
    
}
