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
    
    private var symbolCondition = ""
    
    
    var body: some View {
        
        if locationManager.locationManager?.authorizationStatus == .authorizedWhenInUse {
            VStack {
                
//                GraphView(weatherKitManager: weatherKitManager, hourWeatherList: weatherKitManager.todayWeather)
//                
//                PlottingView(hourlyWeatherData: weatherKitManager.todayWeather)
                
                HStack{
                    Image(systemName: "\(weatherKitManager.currentWeather?.symbolName ?? "No Assets").fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 63, height: 61)
                        .foregroundStyle(.orange)
                    
                    VStack(alignment: .leading){
                        Text("\(weatherKitManager.currentWeather?.condition.description ?? "Nothing")")
                            .font(.title)
                            .bold()
                        Text("in \(locationManager.cityName)")
                    }
                    
                }
                
                
                
                
                
                GraphView(weatherKitManager: weatherKitManager, hourWeatherList: weatherKitManager.todayWeather)
                
                
                OptimalTime(timeList: weatherKitManager.safeWeather)
                
//                PlottingView(hourlyWeatherData: weatherKitManager.hourWeather)
                
//                Text("\(locationManager.cityName)")
                
//                Text("Latitude: \(locationManager.latitude), Longitude: \(locationManager.longitude)")
//                if let currentWeather = weatherKitManager.currentWeather {
//                    Text("Current Time: \(currentWeather.date.formatted())")
//                    Text("Current Weather: \(currentWeather.condition)")
//                }else {
//                    Text("Loading...")
//                }
//                ScrollView{
//                    ForEach(weatherKitManager.hourWeather.map { HourWeatherWrapper(hourWeather: $0) }, id: \.id) { hourWeatherWrapper in
//                        // Customize the view for each hourly weather data
//                        Text("\(hourWeatherWrapper.hourWeather.date.formatted()): \(hourWeatherWrapper.hourWeather.temperature.value), \(hourWeatherWrapper.hourWeather.precipitationChance), \(hourWeatherWrapper.hourWeather.condition)")
//                    }
//                    Text("\(weatherKitManager.hourWeather.count)")
//                }
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
