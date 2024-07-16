//
//  HomeViewModel.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 16/07/24.
//
//
import Foundation
import WeatherKit
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var description: DescriptionModel
    
    init() {
        description = DescriptionModel(conclusionDescription: "Undefined", timeDescription: "Undefined")
    }
    
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
    
    func prepareGraph(weathers: [HourWeather], safeWeather: [TimeRange]) -> [GraphModel] {
        var graphModels: [GraphModel] = []
        for weather in weathers {
            var producedModel: GraphModel
            var state: GraphState = .safe
            if safeWeather.contains(where: { $0.startTime <= weather.date && $0.endTime >= weather.date }) {
                state = .safe
            } else {
                if weather.condition == .drizzle {
                    state = .drizzle
                }
                else {
                    state = .unsafe
                }
            }
            graphModels.append(GraphModel(value: weather, weatherState: state))
        }
        return graphModels
    }
    
    func updateDescription(timeList: [TimeRange]) {
        let currentTime = Date()
        let calendar = Calendar.current
        let startOfTomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentTime)!)
        let startOfToday = calendar.startOfDay(for: currentTime)
        let startOf2Day = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 2, to: currentTime)!)
        
        var desc: LocalizedStringKey = ""
        var timeDesc: LocalizedStringKey = ""

        if !timeList.isEmpty{
            let timeRange = timeList[0]
            
            let adjustedEndTime = timeRange.endTime.addingTimeInterval(1)

            if adjustedEndTime >= calendar.startOfDay(for: startOf2Day) && calendar.isDate(timeRange.startTime, inSameDayAs: startOfToday){
                desc = LocalizedStringKey("Place order anytime you want")
                timeDesc = LocalizedStringKey("No increasing delivery fee for today")
                
            }else if currentTime >= timeRange.startTime && currentTime <= timeRange.endTime {
                desc = LocalizedStringKey("Order now for optimal delivery fee")
                timeDesc = LocalizedStringKey("Optimal delivery fee until  \(timeFormatter.string(from: adjustedEndTime))")
                
            } else if currentTime < timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfTomorrow) {
                desc = LocalizedStringKey("Get optimal delivery fee tomorrow")
                timeDesc = LocalizedStringKey("Optimal delivery fee starts tomorrow at \(timeFormatter.string(from: timeRange.startTime))")
                
            } else if currentTime < timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfToday){
                desc = LocalizedStringKey("Order later to avoid increased fare")
                timeDesc = LocalizedStringKey("Optimal delivery fee start at  \(timeFormatter.string(from: timeRange.startTime))")
                
            }
            else {
                desc = LocalizedStringKey("We haven't found the optimal time yet")
            }
        } else {
            desc = LocalizedStringKey("We haven't found the optimal time yet")
            
        }
        
        self.description = DescriptionModel(conclusionDescription: desc, timeDescription: timeDesc)
        print("update Description: \(description.conclusionDescription)")
    }
    
    func groupWeatherData(_ weatherData: [GraphModel], safeWeather: [TimeRange]) -> [GroupedWeather] {
        var groupedWeather: [GroupedWeather] = []
        
        var currentType: WeatherType?
        var currentItems: [GraphModel] = []
        
        for weatherItem in weatherData {
            let isSafe = safeWeather.contains { $0.startTime <= weatherItem.value.date && $0.endTime >= weatherItem.value.date }
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
        return groupedWeather
    }
    
    func checkWeatherSymbol(symbolName: String) -> Bool {
        if symbolName == "wind" || symbolName == "snowflake" || symbolName == "tornado" || symbolName == "hurricane" {
            return false
        } else {
            return true
        }
    }
}
