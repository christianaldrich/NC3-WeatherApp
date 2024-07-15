//
//  Desc.swift
//  CoreLocationComponent
//
//  Created by Lucinda Artahni on 12/07/24.
//

import SwiftUI

struct Desc: View {
    @State var desc: LocalizedStringKey = ""
    let timeList : [TimeRange]
    @State var timeDesc: LocalizedStringKey = ""
    
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
        
        print("Current time: \(currentTime)")
        
        if !timeList.isEmpty{
            let timeRange = timeList[0]
            let adjustedEndTime = timeRange.endTime.addingTimeInterval(1)
            
            print("Time range start: \(timeRange.startTime), end: \(timeRange.endTime)")
            
            
            if currentTime >= timeRange.startTime && currentTime <= timeRange.endTime {
                desc = LocalizedStringKey("You can get optimal delivery time now")
                timeDesc = LocalizedStringKey("until \(timeFormatter.string(from: adjustedEndTime))")
                
            } else if currentTime <= timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfTomorrow) {
                desc = LocalizedStringKey("Delivery fee maybe increased")
                timeDesc = LocalizedStringKey("optimal delivery fee start from tomorrow")
                
            } else if currentTime <= timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfToday){
                desc = LocalizedStringKey("Delivery fee maybe increased")
                timeDesc = LocalizedStringKey("optimal delivery fee start from \(timeFormatter.string(from: adjustedEndTime))")
                
            }
            else {
                desc = LocalizedStringKey("We haven't found the optimal time yet")
            }
        } else {
            desc = LocalizedStringKey("We haven't found the optimal time yet") //TODO: ganti copywriting
            
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
