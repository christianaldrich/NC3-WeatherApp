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
    
    // 'a' indicates the presence of AM/PM symbols, hence it's a 12-hour format
    if dateFormatter?.contains("a") == true {
        return false
    } else {
        return true
    }
}


struct GraphView: View {
    
    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.dateFormat = "ha" // "h a" will format the time as "1 PM", "2 AM", etc.
//        formatter.pmSymbol = "pm"
//        formatter.amSymbol = "am"
        
        if is24HourFormat(){
            //24-hour
            formatter.dateFormat = "HH"
            
        }else{
            //12-hour
            formatter.dateFormat = "ha"
        }
        
        return formatter
    }()
    
    @ObservedObject var weatherKitManager = WeatherManager()
    @StateObject var locationManager = LocationManager()
    
//    private var textColors : Color = .black
//    private var fillCheck : String = ""
    
    let hourWeatherList : [HourWeather]
    var date : Date
    
    var body: some View {
        
        let groupedWeather = weatherKitManager.groupWeatherData(hourWeatherList)
        
        VStack(alignment: .leading){
//            Text("Hourly Forecast")
            
            
            
            
//            if weatherKitManager.safeWeather.contains(where: { $0.startTime <= date && $0.endTime >= date }) {
                
                ZStack{
//                    RoundedRectangle(cornerRadius: 5)
//                        .foregroundStyle(.blue)
//                        .frame(height: 104)
                    
                    ScrollView(.horizontal){
                        HStack(spacing:18){
                            
                            ForEach(groupedWeather) { group in
                                    if group.type == .safe{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color.blue.opacity(1))
                                                .frame(height: 104)
                                            
//                                            Ellipse().fill(Color.red).frame(width: 50)
                                                                            
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
//                            ForEach(hourWeatherList, id: \.date){ hourWeatherItem in
//                                VStack(spacing: 20){
//                                    
//                                    let (textColor, fillCheck, symbolColor) = getTextColorAndFillCheck(for: hourWeatherItem.date)
//                                    
//                                    Text(timeFormatter.string(from: hourWeatherItem.date))
//                                        .foregroundStyle(textColor)
//                                    Image(systemName: "\(hourWeatherItem.symbolName)\(fillCheck)")
////                                        .resizable()
////                                        .aspectRatio(contentMode: .fit)
////                                        .frame(width: 227)
//                                        .foregroundStyle(symbolColor)
//                                        
//                                    
//                                    //gnti sesuai indeks
//                                    
//        //                            Text(hourWeatherItem.temperature.formatted())
//        //                                .fontWeight(.medium)
//                                    Image(systemName: "checkmark.circle.fill")
//                                            .foregroundStyle(Color.green)
////                                    Image(systemName: "exclamationmark.circle.fill")
////                                            .foregroundStyle(Color.red)
//
//                                }
//                                
//                            }
                        }
//                        .padding()
                    }
//                    .padding()
                    .frame(height: 114)
                    
                }
                
//            }
            
            
        }
        .padding()
        .background{
            Color.white
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .foregroundStyle(.black)
        
        
    }
    
    @ViewBuilder
        private func weatherItemsView(_ items: [HourWeather]) -> some View {
            HStack(spacing: 18) {
                ForEach(items, id: \.date) { hourWeatherItem in
                    VStack(spacing: 20) {
                        let (textColor, fillCheck, symbolColor,littleSymbolDesc, littleSymbolColor, fillLittleSymbol) = getTextColorAndFillCheck(for: hourWeatherItem.date, item: hourWeatherItem)
                        
                        Text(timeFormatter.string(from: hourWeatherItem.date))
                            .foregroundStyle(textColor)
                        
                        if hourWeatherItem.symbolName == "wind" || hourWeatherItem.symbolName == "snowflake" || hourWeatherItem.symbolName == "tornado" || hourWeatherItem.symbolName == "hurricane"{
                            Image(systemName: "wind")
                                .foregroundStyle(symbolColor)
                            
                        }else {
                            Image(systemName: "\(hourWeatherItem.symbolName)\(fillCheck)")
                                .foregroundStyle(symbolColor)
                        }
                        
                        Image(systemName: "\(littleSymbolDesc).circle\(fillLittleSymbol)")
                            .foregroundStyle(littleSymbolColor)
                    }
                    .padding(5)
                }
            }
        }
    
    private func getTextColorAndFillCheck(for date: Date, item: HourWeather) -> (Color, String, Color, String, Color, String) {
        
        //bisa input .circle kalo udh mentok
        
            if weatherKitManager.safeWeather.contains(where: { $0.startTime <= date && $0.endTime >= date }) {
                return (.white, ".fill", .white, "checkmark", .white, ".fill")
            } else {
                
                if item.condition == .drizzle {
                    return (.black, ".fill", .gray, "exclamationmark", .orange, "")
                }
                else {
                    return (.black, ".fill", .gray,"exclamationmark", .red, "")
                }
                
            }
        
        
        }
    
    
}

//#Preview {
//    GraphView(hourweatherList: weatherKitManager)
//}
