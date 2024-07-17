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
    
    @Binding var descriptionModel: DescriptionModel
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text(descriptionModel.timeDescription)
                .font(.body)
                .fontWeight(.regular)
                .foregroundStyle(Color("descText"))
            
            Divider()
                .foregroundStyle(Color(.systemGray3))
            ZStack{
                ScrollView(.horizontal){
                        HStack(spacing:18){
                            
                            ForEach(groupedWeather) { group in
                                    if group.type == .safe{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color.blue.opacity(1))
                                                .frame(height: 114)
                                            GroupWeatherView(viewModel: viewModel, weathers: group.items)
                                                .padding()
                                        }

                                    }else{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 0)
                                                .foregroundStyle(Color("graphViewColor").opacity(0.5))
                                                .frame(height: 114)
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
            Color("graphViewColor")
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .foregroundStyle(.black)
        
        
    }
}
