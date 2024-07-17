//
//  LocationManager.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import Foundation
import CoreLocation



class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate{
    
    static var shared = LocationManager()
    
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
                }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            DispatchQueue.main.async{
                self.currentLocation = location
            }
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                        if error == nil {
                            let firstLocation = placemarks?[0]
                            let cityName = firstLocation?.locality
                            let countryName = firstLocation?.country
                            
                            if cityName != nil{
                                DispatchQueue.main.async {
                                    self!.cityName = cityName!
                                }
                            }else if countryName != nil{
                                self!.cityName = countryName!
                            }else{
                                self?.cityName = "Somewhere"
                            }
                        }
                    }
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        }
    
    
}
