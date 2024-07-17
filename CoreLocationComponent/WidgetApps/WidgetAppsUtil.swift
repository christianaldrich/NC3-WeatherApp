//
//  WidgetAppsUtil.swift
//  WidgetAppsExtension
//
//  Created by Reynard Octavius Tan on 16/07/24.
//

import Foundation


enum currentWeatherWidgetUtil: Int, Codable, Hashable, Identifiable{
    case risk
    case safe
    
    var imageSystemName : String {
        switch self{
        case .risk : return "cloud.rain.fill"
        case .safe : return "sun.max.fill"
        }
    }
    
    var copyWritingFeeDelivery : String {
        switch self{
        case .safe : return "Optimal delivery fee"
        case .risk : return "Increased delivery fee"
        }
    }
    
    var copyWritingOrdering : String {
        switch self{
        case .safe : return "Order Now"
        case .risk : return "Order Later"
        }
    }
    
    var statusCondition : String {
        switch self{
        case .risk : return "rain until"
        case .safe : return "until"
        }
    }
    
    var id: Int {return self.rawValue}
}



