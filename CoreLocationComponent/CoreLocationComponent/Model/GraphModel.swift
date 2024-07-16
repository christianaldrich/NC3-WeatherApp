//
//  GraphModel.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 16/07/24.
//

import Foundation
import SwiftUI
import WeatherKit

struct GraphModel: Identifiable {
    var id: UUID = UUID()
    var value: HourWeather
    var textColor: Color {
        switch self.weatherState{
            case .safe:
                return .white
            case .unsafe, .drizzle:
                return .black
        }
    }
    var graphWeatherSymbol: GraphWeatherSymbolModel {
        var weatherExtension = ".fill"
        var weatherColor = Color.white
        
        if self.value.symbolName == "wind" || self.value.symbolName == "snowflake" || self.value.symbolName == "tornado" || self.value.symbolName == "hurricane" {
            weatherExtension = ""
        }
        
        switch self.weatherState {
        case .safe:
            weatherColor = Color.white
        case .unsafe, .drizzle:
            weatherColor = Color.gray
        }
        
        return GraphWeatherSymbolModel(
            weatherSymbolExtension: weatherExtension,
            weatherSymbolColor: weatherColor
        )
    }
    var graphDescription: GraphDescriptionModel {
        var symbol = ""
        var symbolColor = Color.white
        var symbolExtension = ""
        
        switch self.weatherState {
        case .safe:
            symbol = "checkmark"
            symbolColor = .white
        case .unsafe:
            symbol = "exclamationmark"
            symbolColor = .red
        case .drizzle:
            symbol = "exclamationmark"
            symbolColor = .orange
        }
        
        return GraphDescriptionModel(
            descriptionSymbol: symbol,
            descriptionSymbolColor: symbolColor,
            descriptionSymbolExtension: symbolExtension
        )
    }
    var weatherState: GraphState
}

struct GraphWeatherSymbolModel{
    var weatherSymbolExtension: String
    var weatherSymbolColor: Color
}

struct GraphDescriptionModel{
    var descriptionSymbol: String
    var descriptionSymbolColor: Color
    var descriptionSymbolExtension: String
}

enum GraphState {
    case safe
    case unsafe
    case drizzle
}
