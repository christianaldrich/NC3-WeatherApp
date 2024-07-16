//
//  HomeViewModel.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 16/07/24.
//
//
import Foundation
import WeatherKit

class HomeViewModel: ObservableObject {
    
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
}
