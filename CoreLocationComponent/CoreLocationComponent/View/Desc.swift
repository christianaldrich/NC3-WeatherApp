//
//  Desc.swift
//  CoreLocationComponent
//
//  Created by Lucinda Artahni on 12/07/24.
//

import SwiftUI

struct Desc: View {
    @State var desc: String = "Delivery fee may increased"
    let timeList : [TimeRange]
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 359, height: 58)
                .cornerRadius(10)
                .foregroundColor(.desc)
            
            Text(desc)
                .foregroundColor(.descText)
                .font(Font.custom("SF Pro", size: 17))
            
        }
        .onAppear(perform: {
            updateDescription()
        })
    }
    
    
    func updateDescription() {
            let currentTime = Date()
        if !timeList.isEmpty{
                let timeRange = timeList[1]
                if currentTime >= timeRange.startTime && currentTime <= timeRange.endTime {
                    desc = "You can get optimal delivery time now"
                } else {
                    desc = "Delivery fee may increased"
                }
            } else {
                desc = "Delivery fee may increased"
            }
        }
}

#Preview {
    let sampleTimes = [
        TimeRange(startTime: Date(), endTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!),
        TimeRange(startTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, endTime: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!)
    ]
    return Desc(timeList: sampleTimes)
}
