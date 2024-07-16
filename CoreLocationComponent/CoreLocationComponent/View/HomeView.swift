//
//  ContentView.swift
//  TestWeatherApp
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import SwiftUI
import WeatherKit

struct HomeView: View {
    
    @EnvironmentObject var weatherKitManager: WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var viewModel: HomeViewModel
    @State var descr: DescriptionModel = DescriptionModel(conclusionDescription: "Undefined", timeDescription: "Undefined")
    
    
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
                            HStack(alignment: .top) {
                                    Image(systemName: "\(weatherKitManager.currentWeather?.symbolName ?? "No Assets")\(viewModel.checkWeatherSymbol(symbolName: weatherKitManager.currentWeather?.symbolName ?? "") ? ".fill" : "")")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 63, height: 61)
                                            .foregroundStyle(weatherKitManager.checkWeather(weather: weatherKitManager.currentWeather!) ? .orange : .gray)
                                    VStack(alignment: .leading){
                                        Text("\(weatherKitManager.currentWeather?.condition.description ?? "Nothing")")
                                            .font(.title)
                                            .bold()
                                        Text("\(locationManager.cityName)")
                                    }
                                }
                                .foregroundStyle(.black)

                            DescriptionView(descriptionModel: $descr)
                                .foregroundStyle(.black)
                                .onAppear {
                                    viewModel.updateDescription(timeList: weatherKitManager.safeWeather)
                                    descr = viewModel.description
                                }
                                .onChange(of: weatherKitManager.safeWeather) {
                                    viewModel.updateDescription(timeList: weatherKitManager.safeWeather)
                                    descr = viewModel.description
                                }
                        }
                    }
                    
                    Spacer()
                    
                    GraphView(viewModel: viewModel,
                              groupedWeather: viewModel.groupWeatherData(viewModel.prepareGraph(weathers: weatherKitManager.allWeather, safeWeather: weatherKitManager.safeWeather), safeWeather: weatherKitManager.safeWeather))
                    
                }
                .padding()
                .task {
                    weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                }
                .onChange(of: locationManager.currentLocation) { newLocation in
                                guard let newLocation = newLocation else { return }
                                Task {
                                    weatherKitManager.getWeather(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
                                }
                            }
                .onAppear{
                    Task{
                        weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    Task{
                        weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    }
                }
            } else {
                Text("Perimission not granted")
            }
        }
        .ignoresSafeArea()
    }
}