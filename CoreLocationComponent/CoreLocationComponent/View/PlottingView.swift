//
//  PlottingView.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import SwiftUI
import Charts
import WeatherKit



struct PlottingView: View {
    
    let hourlyWeatherData : [HourWeather]
    
    var body: some View {
        Chart{
            ForEach(hourlyWeatherData.prefix(10), id: \.date){ hourlyWeather in
                LineMark(x: .value("Hour", hourlyWeather.date), y: .value("Chance", hourlyWeather.cloudCover))
            }
        }
    }
}

//#Preview {
//    PlottingView()
//}
