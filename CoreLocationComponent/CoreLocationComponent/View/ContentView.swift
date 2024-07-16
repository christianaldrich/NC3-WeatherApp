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
    @ObservedObject var viewModel: HomeViewModel
    @State var descr: DescriptionModel = DescriptionModel(conclusionDescription: "Undefined", timeDescription: "Undefined")
    
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
                            HStack(alignment: .top) {
                                    Image(systemName: "\(weatherKitManager.currentWeather?.symbolName ?? "No Assets")\(checkWeatherSymbol(symbolName: weatherKitManager.currentWeather?.symbolName ?? "") ? ".fill" : "")")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 63, height: 61)
                                            .foregroundStyle(symbolColor)
                                    VStack(alignment: .leading){
                                        Text("\(weatherKitManager.currentWeather?.condition.description ?? "Nothing")")
                                            .font(.title)
                                            .bold()
                                        Text("\(locationManager.cityName)")
                                    }
                                }
                                .foregroundStyle(.black)

                            Desc(descriptionModel: $descr)
                                .foregroundStyle(.black)
                                .onAppear{
                                    print("appear update: \(weatherKitManager.safeWeather) : \(descr)")
                                    viewModel.updateDescription(timeList: weatherKitManager.safeWeather)
                                    descr = viewModel.description
                                }
                                .onChange(of: weatherKitManager.safeWeather, perform: { _ in
                                    viewModel.updateDescription(timeList: weatherKitManager.safeWeather)
                                    descr = viewModel.description
                                    print("updating to:  \(weatherKitManager.safeWeather) : \(descr)")
                                })
                        }
                    }
                    
                    Spacer()
                    
                    GraphView(hourModelList: viewModel.prepareGraph(weathers: weatherKitManager.allWeather, safeWeather: weatherKitManager.safeWeather), date: Date())
                    
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
                        print("ON Apppear \(viewModel.description.conclusionDescription)")
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

func checkWeatherSymbol(symbolName: String) -> Bool {
    if symbolName == "wind" || symbolName == "snowflake" || symbolName == "tornado" || symbolName == "hurricane" {
        return false
    } else {
        return true
    }
}

//#Preview {
//    ContentView()
//}
