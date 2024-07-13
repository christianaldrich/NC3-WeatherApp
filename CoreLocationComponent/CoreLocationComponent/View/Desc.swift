//
//  Desc.swift
//  CoreLocationComponent
//
//  Created by Lucinda Artahni on 12/07/24.
//

import SwiftUI

struct Desc: View {
    @State var desc: String = ""
    let timeList : [TimeRange]
    @State var timeDesc: String = ""
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // "h a" will format the time as "1 PM", "2 AM", etc.
        formatter.pmSymbol = "pm"
        formatter.amSymbol = "am"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 10){
         Text(desc)
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 357)
            
            Text(timeDesc)
                .font(.body)
                .fontWeight(.regular)
            
            
        }
        .onChange(of: timeList, perform: { _ in
                    updateDescription()
                })
    }
    
    
    func updateDescription() {
        let currentTime = Date()
        let calendar = Calendar.current
        let startOfTomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentTime)!)
        let startOfToday = calendar.startOfDay(for: currentTime)
        
        if !timeList.isEmpty{
            let timeRange = timeList[0]
            if currentTime >= timeRange.startTime && currentTime <= timeRange.endTime {
                desc = "You can get optimal delivery time now"
                timeDesc = "until \(timeFormatter.string(from: timeRange.endTime))"
                
            } else if currentTime <= timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfTomorrow) {
                desc = "Delivery fee maybe increased"
                timeDesc = "optimal delivery fee start from tomorrow"
                
            } else if currentTime <= timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfToday){
                desc = "Delivery fee maybe increased"
                timeDesc = "optimal delivery fee start from \(timeFormatter.string(from: timeRange.startTime))"
                
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
