//
//  ContentView.swift
//  TestWeatherApp
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var weatherKitManager: WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    
    private var symbolCondition = ""    
    private var symbolColor: Color {
        if let currentWeather = weatherKitManager.currentWeather, weatherKitManager.checkWeather(weather: currentWeather) {
                return .orange
            } else {
                return .gray
            }
        }
    
    var body: some View {
        
        ZStack{
            Color.init(red: 242/255.0, green: 242/255.0, blue: 247/255.0)
            
            if locationManager.locationManager?.authorizationStatus == .authorizedWhenInUse {
                VStack{
                    Spacer()
                    
                    VStack(spacing:32){
                        if weatherKitManager.todayWeather == [] || locationManager.cityName == "Somewhere" {
                            ProgressView()
                        } else {
                                
                                VStack(alignment: .center){
                                    
                                    if weatherKitManager.currentWeather?.symbolName == "wind"{
                                        Image(systemName: "\(weatherKitManager.currentWeather?.symbolName ?? "No Assets")")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 63, height: 61)
                                            .foregroundStyle(symbolColor)
                                    }else {
                                        Image(systemName: "\(weatherKitManager.currentWeather?.symbolName ?? "No Assets").fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 63, height: 61)
                                            .foregroundStyle(symbolColor)
                                    }
                                    
                                    Text("\(weatherKitManager.currentWeather?.condition.description ?? "Nothing")")
                                        .font(.title)
                                        .bold()
                                    Text("\(locationManager.cityName)")
                                }
                                .foregroundStyle(.black)

                            Desc(timeList: weatherKitManager.safeWeather)
                                .foregroundStyle(.black)
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    GraphView(weatherKitManager: weatherKitManager, hourWeatherList: weatherKitManager.allWeather, date: Date.now)
                    
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
                .onAppear{
                    Task{
                        await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    Task{
                        await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    }
                }
            } else {
                Text("Perimission not granted")
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
