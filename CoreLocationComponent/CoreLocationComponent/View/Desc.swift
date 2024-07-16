//
//  Desc.swift
//  CoreLocationComponent
//
//  Created by Lucinda Artahni on 12/07/24.
//

import SwiftUI


struct Desc: View {
    
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
    
    @State var desc: LocalizedStringKey = ""
    let timeList : [TimeRange]
    @State var timeDesc: LocalizedStringKey = ""
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
        let startOf2Day = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 2, to: currentTime)!)

        if !timeList.isEmpty{
            let timeRange = timeList[0]
            
            let adjustedEndTime = timeRange.endTime.addingTimeInterval(1)

            if adjustedEndTime >= calendar.startOfDay(for: startOf2Day) && calendar.isDate(timeRange.startTime, inSameDayAs: startOfToday){
                desc = LocalizedStringKey("Place order anytime you want")
                timeDesc = LocalizedStringKey("No increasing delivery fee for today")
                
            }else if currentTime >= timeRange.startTime && currentTime <= timeRange.endTime {
                desc = LocalizedStringKey("Order now for optimal delivery fee")
                timeDesc = LocalizedStringKey("Optimal delivery fee until  \(timeFormatter.string(from: adjustedEndTime))")
                
            } else if currentTime < timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfTomorrow) {
                desc = LocalizedStringKey("Get optimal delivery fee tomorrow")
                timeDesc = LocalizedStringKey("Optimal delivery fee starts tomorrow at \(timeFormatter.string(from: timeRange.startTime))")
                
            } else if currentTime < timeRange.startTime && calendar.isDate(timeRange.startTime, inSameDayAs: startOfToday){
                desc = LocalizedStringKey("Order later to avoid increased fare")
                timeDesc = LocalizedStringKey("Optimal delivery fee start at  \(timeFormatter.string(from: timeRange.startTime))")
                
            }
            else {
                desc = LocalizedStringKey("We haven't found the optimal time yet")
            }
        } else {
            desc = LocalizedStringKey("We haven't found the optimal time yet")
            
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
