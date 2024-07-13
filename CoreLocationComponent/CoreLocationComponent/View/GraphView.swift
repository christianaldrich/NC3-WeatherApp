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
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha" // "h a" will format the time as "1 PM", "2 AM", etc.
        formatter.pmSymbol = "pm"
        formatter.amSymbol = "am"
        return formatter
    }()
    
    @ObservedObject var weatherKitManager = WeatherManager()
    @StateObject var locationManager = LocationManager()
    
    let hourWeatherList : [HourWeather]
    
    var body: some View {
        
        VStack(alignment: .leading){
//            Text("Hourly Forecast")
            
            ScrollView(.horizontal){
                HStack(spacing:18){
                    ForEach(hourWeatherList, id: \.date){ hourWeatherItem in
                        VStack(spacing: 20){
                            Text(timeFormatter.string(from: hourWeatherItem.date))
                            Image(systemName: "\(hourWeatherItem.symbolName)")
                                .foregroundStyle(.black)
                            
                            //gnti sesuai indeks
                            
//                            Text(hourWeatherItem.temperature.formatted())
//                                .fontWeight(.medium)
                        }
                        
                    }
                }
            }
        }
        .padding()
        .background{
            Color.white
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .foregroundStyle(.black)
        
        
    }
}

//#Preview {
//    GraphView(hourweatherList: weatherKitManager)
//}
