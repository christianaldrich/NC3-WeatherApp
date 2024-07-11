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
                
                GraphView(weatherKitManager: weatherKitManager, hourWeatherList: weatherKitManager.todayWeather)
                
                PlottingView(hourlyWeatherData: weatherKitManager.todayWeather)
                
                Text("Latitude: \(locationManager.latitude), Longitude: \(locationManager.longitude)")
                if let currentWeather = weatherKitManager.currentWeather {
                    Text("Current Time: \(currentWeather.date.formatted())")
                    Text("Current Weather: \(currentWeather.condition.rawValue)")
                }else {
                    Text("Loading...")
                }
                ScrollView{
                    ForEach(weatherKitManager.todayWeather.map { HourWeatherWrapper(hourWeather: $0) }, id: \.id) { hourWeatherWrapper in
                        // Customize the view for each hourly weather data
                        Text("\(hourWeatherWrapper.hourWeather.date.formatted()): \(hourWeatherWrapper.hourWeather.temperature.value), \(hourWeatherWrapper.hourWeather.precipitationChance), \(hourWeatherWrapper.hourWeather.condition.rawValue)")
                    }
                    Text("\(weatherKitManager.todayWeather.count)")
                    Text("Safe weather:")
                    ForEach(weatherKitManager.safeWeather, id: \.id) { range in
                        Text("\(range.startTime) - \(range.endTime)")
                    }
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
