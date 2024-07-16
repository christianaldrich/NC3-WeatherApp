//
//  GraphView.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import SwiftUI
import Foundation
import Charts
import WeatherKit

func is24HourFormat() -> Bool {
    let locale = Locale.current
    let dateFormatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)
    if dateFormatter?.contains("a") == true {
        return false
    } else {
        return true
    }
}


struct GraphView: View {
    
    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        if is24HourFormat(){
            //24-hour
            formatter.dateFormat = "HH"
            
        }else{
            //12-hour
            formatter.dateFormat = "ha"
        }
        
        return formatter
    }()
    
    @EnvironmentObject var weatherKitManager: WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    
    let hourModelList : [GraphModel]
    var date : Date
    
    var body: some View {
        
        let groupedWeather = weatherKitManager.groupWeatherData(hourModelList)
        
        VStack(alignment: .leading){
                ZStack{
                    ScrollView(.horizontal){
                        HStack(spacing:18){
                            
                            ForEach(groupedWeather) { group in
                                    if group.type == .safe{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color.blue.opacity(1))
                                                .frame(height: 104)
                                            weatherItemsView(group.items)
                                                .padding()
                                            
                                        }

                                    }else{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 0)
                                                .foregroundStyle(Color.white.opacity(0.5))
                                                .frame(height: 104)
                                                                            
                                            weatherItemsView(group.items)
                                            
                                        }
                                    }
                                
                            }
                        }
                    }
                    .frame(height: 114)
                    
                }
        }
        .padding()
        .background{
            Color.white
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .foregroundStyle(.black)
        
        
    }
    
    @ViewBuilder
        private func weatherItemsView(_ items: [GraphModel]) -> some View {
            HStack(spacing: 18) {
                ForEach(items, id: \.id) { hourWeatherItem in
                    VStack(spacing: 20) {
                        
                        Text(timeFormatter.string(from: hourWeatherItem.value.date))
                            .foregroundStyle(hourWeatherItem.textColor)
                        
            
                        Image(systemName: "\(hourWeatherItem.value.symbolName)\(checkWeatherSymbol(symbolName: hourWeatherItem.value.symbolName) ? hourWeatherItem.graphWeatherSymbol.weatherSymbolExtension : "")")
                                .foregroundStyle(hourWeatherItem.graphWeatherSymbol.weatherSymbolColor)
                        
                        Image(systemName: "\(hourWeatherItem.graphDescription.descriptionSymbol).circle\(hourWeatherItem.graphDescription.descriptionSymbolExtension)")
                            .foregroundStyle(hourWeatherItem.graphDescription.descriptionSymbolColor)
                    }
                    .padding(5)
                }
            }
        }
}
