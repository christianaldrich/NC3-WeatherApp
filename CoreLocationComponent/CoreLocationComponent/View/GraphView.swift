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
    
//    private var textColors : Color = .black
//    private var fillCheck : String = ""
    
    let hourWeatherList : [HourWeather]
    var date : Date
    
    var body: some View {
        
        VStack(alignment: .leading){
//            Text("Hourly Forecast")
            
            
            
            
            if weatherKitManager.safeWeather.contains(where: { $0.startTime <= date && $0.endTime >= date }) {
                
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.blue)
                        .frame(height: 104)
                    
                    ScrollView(.horizontal){
                        HStack(spacing:18){
                            ForEach(hourWeatherList, id: \.date){ hourWeatherItem in
                                VStack(spacing: 20){
                                    
                                    let (textColor, fillCheck, symbolColor) = getTextColorAndFillCheck(for: hourWeatherItem.date)
                                    
                                    Text(timeFormatter.string(from: hourWeatherItem.date))
                                        .foregroundStyle(textColor)
                                    Image(systemName: "\(hourWeatherItem.symbolName)\(fillCheck)")
                                        .foregroundStyle(symbolColor)
                                    
                                    //gnti sesuai indeks
                                    
        //                            Text(hourWeatherItem.temperature.formatted())
        //                                .fontWeight(.medium)
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.green)

                                }
                                
                            }
                        }
                        .padding()
                    }
                    .frame(height: 114)
                    
                }
                
            }
            else{
                ScrollView(.horizontal){
                    HStack(spacing:18){
                        ForEach(hourWeatherList, id: \.date){ hourWeatherItem in
                            VStack(spacing: 20){
                                
                                let (textColor, fillCheck, symbolColor) = getTextColorAndFillCheck(for: hourWeatherItem.date)
                                
                                Text(timeFormatter.string(from: hourWeatherItem.date))
                                    .foregroundStyle(textColor)
                                Image(systemName: "\(hourWeatherItem.symbolName)\(fillCheck)")
                                    .foregroundStyle(symbolColor)
                                
                                //gnti sesuai indeks
                                
    //                            Text(hourWeatherItem.temperature.formatted())
    //                                .fontWeight(.medium)

                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundStyle(Color.red)
                                                    
                            }
                        }
                    }
                    .padding()
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
    
    private func safeWeatherBackground(for date: Date) -> some View {
            if weatherKitManager.safeWeather.contains(where: { $0.startTime <= date && $0.endTime >= date }) {
                return Color.blue.opacity(1) // Adjust the opacity as needed
            } else {
                return Color.clear
            }
        }
    
    private func getTextColorAndFillCheck(for date: Date) -> (Color, String, Color) {
            if weatherKitManager.safeWeather.contains(where: { $0.startTime <= date && $0.endTime >= date }) {
                return (.white, ".fill", .white)
            } else {
                return (.black, ".fill", .gray)
            }
        }
    
    
}

//#Preview {
//    GraphView(hourweatherList: weatherKitManager)
//}
