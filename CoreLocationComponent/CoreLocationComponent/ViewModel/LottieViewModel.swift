//
//  LottieViewModel.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 16/07/24.
//

import Foundation
import Lottie
import WeatherKit

class LottieViewModel{
    
    func showLottie(weathers: [HourWeather], safeWeather: [TimeRange]) -> String{
        for weather in weathers {
            if safeWeather.contains(where: { $0.startTime <= weather.date && $0.endTime >= weather.date }) {
//                LottieView(animationName: "Clear 4")
                return "Clear 4"
            } else {
//                LottieView(animationName: "Rain 4")
                return "Rain 4"
            }
        }
        return "Clear 4"
    }
    
}
