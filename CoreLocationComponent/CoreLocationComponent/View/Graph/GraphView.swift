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
    if dateFormatter?.contains("a") == true {
        return false
    } else {
        return true
    }
}


struct GraphView: View {
    
    @EnvironmentObject var weatherKitManager: WeatherManager
    @EnvironmentObject var locationManager: LocationManager
    
    @ObservedObject var viewModel: HomeViewModel
    var groupedWeather: [GroupedWeather]
    
    var body: some View {
        VStack(alignment: .leading){
                ZStack{
                    ScrollView(.horizontal){
                        HStack(spacing:18){
                            
                            ForEach(groupedWeather) { group in
                                    if group.type == .safe{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color.blue.opacity(1))
                                                .frame(height: 104)
                                            GroupWeatherView(viewModel: viewModel, weathers: group.items)
                                                .padding()
                                        }

                                    }else{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 0)
                                                .foregroundStyle(Color.white.opacity(0.5))
                                                .frame(height: 104)
                                            GroupWeatherView(viewModel: viewModel, weathers: group.items)
                                        }
                                    }
                                
                            }
                        }
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
}
