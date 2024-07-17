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
            Color.init("Background")
            
            if locationManager.locationManager?.authorizationStatus == .authorizedWhenInUse {
                VStack{
                    
//                    Spacer()
                    
                    VStack(spacing:54){
                        if weatherKitManager.todayWeather == [] || locationManager.cityName == "Somewhere" {
                            ProgressView()
                        } else {
                            HStack(alignment: .top) {
                                    Image(systemName: "\(weatherKitManager.currentWeather?.symbolName ?? "No Assets")\(viewModel.checkWeatherSymbol(symbolName: weatherKitManager.currentWeather?.symbolName ?? "") ? ".fill" : "")")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 53, height: 51)
                                            .foregroundStyle(weatherKitManager.checkWeather(weather: weatherKitManager.currentWeather!) ? .orange : .gray)
                                    VStack(alignment: .leading){
                                        Text("\(weatherKitManager.currentWeather?.condition.description ?? "Nothing")")
                                            .font(.title)
                                            .bold()
                                            .foregroundStyle(Color("descText"))
                                        Text("\(locationManager.cityName)")
                                            .foregroundStyle(Color("descText"))
                                    }
                                }
                                .foregroundStyle(.black)
                            
                            
                            VStack{
                                LottieView(animationName: LottieViewModel().showLottie(weathers: weatherKitManager.allWeather, safeWeather: weatherKitManager.safeWeather))
                                    .frame(width: 279,height: 234)

                                DescriptionView(descriptionModel: $descr)
                                    .foregroundStyle(Color("descText"))
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
                    }
                    
//                    Spacer()
                    
                    GraphView(viewModel: viewModel,
                              groupedWeather: viewModel.groupWeatherData(viewModel.prepareGraph(weathers: weatherKitManager.allWeather, safeWeather: weatherKitManager.safeWeather), safeWeather: weatherKitManager.safeWeather), descriptionModel: $descr)
                    .offset(y:70)
//                    Spacer()
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
