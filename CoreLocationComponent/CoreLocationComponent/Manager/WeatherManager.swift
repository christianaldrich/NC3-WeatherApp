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
    
    var todayWeather: [HourWeather] {
            let currentDate = Date()
            let calendar = Calendar.current
            
            // Start of today
            let startOfToday = calendar.startOfDay(for: currentDate)
            
            // End of next day
            let endOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
            
            let hourWeather = weather?.hourlyForecast.forecast.filter { $0.date > currentDate && $0.date < endOfNextDay }
        
            if let currentWeather = self.currentWeather {
                return [currentWeather] + (hourWeather!)
           }
            
            return hourWeather ?? []
        }
    
    var tomorrowWeather: [HourWeather] {
            let calendar = Calendar.current
            guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) else { return [] }
            
            let startDay = calendar.startOfDay(for: tomorrow)
            let endDay = calendar.date(byAdding: .day, value: 1, to: startDay)!
            
            let hourWeather = weather?.hourlyForecast.forecast.filter { $0.date >= startDay && $0.date < endDay }
            
            return hourWeather ?? []
        }
    
    var allWeather: [HourWeather] {
        let todayWeather = self.todayWeather
        let tomorrowWeather = self.tomorrowWeather
        return todayWeather + tomorrowWeather
    }
    
    var currentWeather: HourWeather? {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let thisHour = calendar.date(byAdding: .hour, value: -1, to: currentDate)
        let currentWeather = weather?.hourlyForecast.forecast.first { $0.date > thisHour ?? Date() && $0.date < calendar.date(byAdding: .hour, value: 1, to: thisHour ?? Date())! }
            
            return currentWeather
        }
    
    var safeWeather: [TimeRange] {
        let todayWeather = self.allWeather
        var timeRange: [TimeRange] = []
        var startDate: Date = Date.distantPast
        var endDate: Date = Date.distantPast
        for weather in todayWeather {
            if startDate == Date.distantPast && checkWeather(weather: weather) {
                //get new data
                startDate = weather.date
                endDate = weather.date
            } else if checkWeather(weather: weather) {
                endDate = weather.date
            } else if startDate != Date.distantPast {
                timeRange.append(TimeRange(startTime: startDate, endTime: endDate))
                startDate = Date.distantPast
                endDate = Date.distantPast
            }
        }
        if startDate != Date.distantPast {
            timeRange.append(TimeRange(startTime: startDate, endTime: todayWeather.last?.date ?? Date()))
        }
        return timeRange
    }
    
    func checkWeather(weather: HourWeather) -> Bool {
        switch weather.condition{
            case .drizzle, .heavyRain, .isolatedThunderstorms, .rain, .sunShowers, .scatteredThunderstorms, .strongStorms, .thunderstorms:
                return false
            default:
                return true
        }
    }
}

