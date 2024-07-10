//
//  WeatherManager.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import Foundation
import WeatherKit

@MainActor class WeatherManager:ObservableObject {
    @Published var weather: Weather?
    
    func getWeather(latitude: Double, longitude: Double) {
        async {
            do {
                weather = try await Task.detached(priority: .userInitiated) {
                    return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
                }.value
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }
    
    var temp: String {
        let temp = weather?.currentWeather.temperature
        let convertedTemp = temp?.converted(to: .celsius).description
        return convertedTemp ?? "Connecting to Apple Weather Kit"
    }
    
    var hourWeather: [HourWeather] {
            let currentDate = Date()
            let calendar = Calendar.current
            
            // Start of today
            let startOfToday = calendar.startOfDay(for: currentDate)
            
            // End of next day
            let endOfNextDay = calendar.date(byAdding: .day, value: 2, to: startOfToday)!
            
            let hourWeather = weather?.hourlyForecast.forecast.filter { $0.date > currentDate && $0.date < endOfNextDay }
            
            return hourWeather ?? []
        }
    
    var currentWeather: HourWeather? {
            let currentDate = Date()
            let calendar = Calendar.current
        
            let thisHour = calendar.date(byAdding: .hour, value: -1, to: currentDate)
        let currentWeather = weather?.hourlyForecast.forecast.first { $0.date > thisHour ?? Date() && $0.date < calendar.date(byAdding: .hour, value: 1, to: thisHour ?? Date())! }
            
            return currentWeather
        }
}
