//
//  GraphItemView.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 16/07/24.
//

import SwiftUI

struct GraphItemView: View {
    
    var item: GraphModel
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
    
    var body: some View {
        VStack(spacing: 20) {
            Text(timeFormatter.string(from: item.value.date))
                .foregroundStyle(item.textColor)
            
                Image(systemName: "\(item.value.symbolName)\(item.graphWeatherSymbol.weatherSymbolExtension)")
                    .foregroundStyle(item.graphWeatherSymbol.weatherSymbolColor)
            
            Image(systemName: "\(item.graphDescription.descriptionSymbol).circle\(item.graphDescription.descriptionSymbolExtension)")
                .foregroundStyle(item.graphDescription.descriptionSymbolColor)
        }
        .padding(5)
    }
}
