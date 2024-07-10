//
//  ContentView.swift
//  TestWeatherApp
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherKitManager = WeatherManager()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        
        if locationManager.locationManager?.authorizationStatus == .authorizedWhenInUse {
            VStack {
                Text("Latitude: \(locationManager.latitude), Longitude: \(locationManager.longitude)")
                ScrollView{
                    ForEach(weatherKitManager.hourWeather.map { HourWeatherWrapper(hourWeather: $0) }, id: \.id) { hourWeatherWrapper in
                        // Customize the view for each hourly weather data
                        Text("\(hourWeatherWrapper.hourWeather.date): \(hourWeatherWrapper.hourWeather.temperature.value), \(hourWeatherWrapper.hourWeather.precipitationChance)")
                    }
                    Text("\(weatherKitManager.hourWeather.count)")
                }
            }
            .padding()
            .task {
                await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
            }
            .onChange(of: locationManager.currentLocation) { newLocation in
                            guard let newLocation = newLocation else { return }
                            Task {
                                await weatherKitManager.getWeather(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
                            }
                        }
        } else {
            //dont have permission
            Text("Error")
        }
    }
}

#Preview {
    ContentView()
}
