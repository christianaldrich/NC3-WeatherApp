//
//  GroupWeatherView.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 16/07/24.
//

import SwiftUI

struct GroupWeatherView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    var weathers: [GraphModel]
    
    var body: some View {
        HStack(spacing: 18) {
            ForEach(weathers, id: \.id) { weather in
                VStack(spacing: 20) {
                    GraphItemView(viewModel: viewModel, item: weather)
                }
                .padding(5)
            }
        }
    }
}
