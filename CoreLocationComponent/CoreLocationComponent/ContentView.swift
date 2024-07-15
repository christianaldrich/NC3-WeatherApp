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
                
                if weatherKitManager.todayWeather == [] || locationManager.cityName == "Somewhere" {
                    ProgressView()
                } else {
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
                         
                    GraphView(weatherKitManager: weatherKitManager, hourWeatherList: weatherKitManager.allWeather)
                    

                    OptimalTime(timeList: weatherKitManager.safeWeather)
                    
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
                                print("Safe Weather (onChange): \(weatherKitManager.safeWeather)")  // Tambahkan di sini

                            }
                        }
            .onAppear{
                Task{
                    await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    print("Safe Weather (onAppear): \(weatherKitManager.safeWeather)")  // Tambahkan di sini

                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task{
                    await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    print("Safe Weather (onReceive): \(weatherKitManager.safeWeather)")

                }
            }
        } else {
            Text("Perimission not granted")
        }
    }
}

#Preview {
    ContentView()
}
