//
//  WeatherManager.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import Foundation
import WeatherKit
import SwiftUI

@MainActor
class WeatherManager: ObservableObject {
    @Published var weather: Weather?
    static var shared = WeatherManager()
    
    @AppStorage("safeWeatherData", store: UserDefaults(suiteName: packageIdentifier)) var safeWeatherData = " "
    @AppStorage("safeWeatherData", store: UserDefaults(suiteName: packageIdentifier)) var isClearWeather : Bool = true
    
    
    func getWeather(latitude: Double, longitude: Double) {
        Task.init{
            do {
                weather = try await Task.detached(priority: .userInitiated) {
                    return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
                }.value
                if !safeWeather.isEmpty {
                    safeWeatherData = self.safeWeather[0].startTime.description + " - " + self.safeWeather[0].endTime.description
                }else {
                    safeWeatherData = "All rain for today"
                }
            
                
                if let currentWeather = self.currentWeather {
                    isClearWeather = checkWeather(weather: currentWeather)
                    print("Check => \(currentWeather)")
                    print("isClearWeather : \(isClearWeather)")
                    print("isClearWeather : \(isClearWeather)")
                    print("isClearWeatherOnWidget : \(DataService().currentWeather())")
                    print("func checkWeather : \(checkWeather(weather: currentWeather))")
                } else {
                    isClearWeather = false
//                    print("Check => \(currentWeather)")
//                    print("isClearWeather : \(isClearWeather)")
//                    print("func checkWeather : \(checkWeather(weather: currentWeather!))")
                }
                
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    var todayWeather: [HourWeather] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let startOfToday = calendar.startOfDay(for: currentDate)
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

