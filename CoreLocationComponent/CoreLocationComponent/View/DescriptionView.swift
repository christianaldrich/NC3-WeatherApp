//
//  Desc.swift
//  CoreLocationComponent
//
//  Created by Lucinda Artahni on 12/07/24.
//

import SwiftUI


struct DescriptionView: View {
    
    @Binding var descriptionModel: DescriptionModel
    
    var body: some View {
        VStack(spacing: 10){
            Text(descriptionModel.conclusionDescription)
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 357)
            
//            Text(descriptionModel.timeDescription)
//                .font(.body)
//                .fontWeight(.regular)
        }
    }
}
