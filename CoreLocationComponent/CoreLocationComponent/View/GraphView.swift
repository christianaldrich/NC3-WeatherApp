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

struct GraphView: View {
    
    @ObservedObject var weatherKitManager = WeatherManager()
    @StateObject var locationManager = LocationManager()
    
    let hourWeatherList : [HourWeather]
    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("Hourly Forecast")
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(hourWeatherList, id: \.date){ hourWeatherItem in
                        VStack(spacing: 20){
                            Text(hourWeatherItem.date.formatted(date: .omitted, time: .shortened))
                            Image(systemName: "\(hourWeatherItem.symbolName).fill")
                                .foregroundStyle(.yellow)
                            
                            //gnti sesuai indeks
                            
                            Text(hourWeatherItem.temperature.formatted())
                                .fontWeight(.medium)
                        }
                        
                    }
                }
            }
        }
        .padding()
        .background{
            Color.blue
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .foregroundStyle(.white)
        
        
    }
}

//#Preview {
//    GraphView(hourweatherList: weatherKitManager)
//}
