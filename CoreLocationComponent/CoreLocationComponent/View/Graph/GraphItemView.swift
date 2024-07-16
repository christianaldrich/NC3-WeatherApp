//
//  GraphItemView.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 16/07/24.
//

import SwiftUI

struct GraphItemView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    var item: GraphModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.timeFormatter.string(from: item.value.date))
                .foregroundStyle(item.textColor)
            
            Image(systemName: "\(item.value.symbolName)\(item.graphWeatherSymbol.weatherSymbolExtension)")
                    .foregroundStyle(item.graphWeatherSymbol.weatherSymbolColor)
            
            Image(systemName: "\(item.graphDescription.descriptionSymbol).circle\(item.graphDescription.descriptionSymbolExtension)")
                .foregroundStyle(item.graphDescription.descriptionSymbolColor)
        }
        .padding(5)
    }
}
