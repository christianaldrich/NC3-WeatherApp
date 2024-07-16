//
//  WeatherManager.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import Foundation
import WeatherKit
import SwiftUI

@MainActor class WeatherManager:ObservableObject {
    
    
    @AppStorage("safeWeatherData", store: UserDefaults(suiteName: "group.com.pang.CoreLocationComponent")) var safeWeatherData = " "
    
    @Published var weather: Weather?
    
    func getWeather(latitude: Double, longitude: Double) {
        async {
            do {
                weather = try await Task.detached(priority: .userInitiated) {
                    return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
                }.value
                safeWeatherData = self.safeWeather[0].startTime.description + " - " + self.safeWeather[0].endTime.description

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
        let calendar = Calendar.current
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
                endDate = calendar.date(byAdding: .minute, value: 59, to: endDate ?? Date())!
                endDate = calendar.date(byAdding: .second, value: 59, to: endDate ?? Date())!
                timeRange.append(TimeRange(startTime: startDate, endTime: endDate))
                startDate = Date.distantPast
                endDate = Date.distantPast
            }
        }
        if startDate != Date.distantPast {
            let adjustedEndDate = todayWeather.last?.date ?? Date()
               let lastMomentOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: adjustedEndDate) ?? Date()
               timeRange.append(TimeRange(startTime: startDate, endTime: lastMomentOfDay))
//            timeRange.append(TimeRange(startTime: startDate, endTime: todayWeather.last?.date ?? Date()))
        }
        
//        print(timeRange)
        return timeRange
    }
    
    func checkWeather(weather: HourWeather) -> Bool {
        
        switch weather.condition{
        case .drizzle, .heavyRain, .isolatedThunderstorms, .rain, .sunShowers, .scatteredThunderstorms, .strongStorms, .thunderstorms:
//        case .mostlyClear, .mostlyCloudy:
                return false
            default:
                return true
        }
        
        
    }
    
    struct GroupedWeather: Identifiable {
        var id = UUID()
        var type: WeatherType
        var items: [HourWeather]
    }

    enum WeatherType {
        case safe
        case risky
    }

    
    func groupWeatherData(_ weatherData: [HourWeather]) -> [GroupedWeather] {
        var groupedWeather: [GroupedWeather] = []
        
        var currentType: WeatherType?
        var currentItems: [HourWeather] = []
        
        for weatherItem in weatherData {
            let isSafe = safeWeather.contains { $0.startTime <= weatherItem.date && $0.endTime >= weatherItem.date }
            let weatherType: WeatherType = isSafe ? .safe : .risky
            
            if currentType == nil {
                currentType = weatherType
            }
            
            if currentType == weatherType {
                currentItems.append(weatherItem)
            } else {
                groupedWeather.append(GroupedWeather(type: currentType!, items: currentItems))
                currentType = weatherType
                currentItems = [weatherItem]
            }
        }
        
        if let currentType = currentType {
            groupedWeather.append(GroupedWeather(type: currentType, items: currentItems))
        }
        
//        print("Grouped Weather: \(groupedWeather)")
        
        return groupedWeather
    }

    
}

