//
//  OptimalTime.swift
//  CoreLocationComponent
//
//  Created by Lucinda Artahni on 11/07/24.
//

import SwiftUI

struct OptimalTime: View {
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha" // "h a" will format the time as "1 PM", "2 AM", etc.
        formatter.pmSymbol = "pm"
        formatter.amSymbol = "am"
        return formatter
    }()
    
    let timeList : [TimeRange]
    
    var body: some View {
        VStack {
            Text("Optimal delivery times:")
                .font(.system(size: 17, weight: .regular, design: .default))
                .padding(.bottom, -10)
            
            VStack(spacing: 10) {
                ForEach(Array(timeList.prefix(2).enumerated()), id: \.element.id) { index, timeListItem in
                    if index == 0 {
                        ZStack {
                            HStack {
                                Text("\(timeFormatter.string(from: timeListItem.startTime))")
                                    .font(Font.custom("SF Pro", size: 34).weight(.bold))
                                //TODO: implement SF Pro pake weight bold
                                
                                Text("to \(timeFormatter.string(from: timeListItem.endTime))")
                                    .font(Font.custom("SF Pro", size: 34).weight(.bold))
                            }
                            .zIndex(1)
                            
                            Rectangle()
                                .frame(width: 242, height: 77)
                                .cornerRadius(10)
                                .foregroundColor(.descText)
                        }
                    } else {
                        HStack {
                            
                            Text("or \(timeFormatter.string(from: timeListItem.startTime))")
                                .font(Font.custom("SF Pro", size: 17).weight(.bold))
                            
                            Text("to \(timeFormatter.string(from: timeListItem.endTime))")
                                .font(Font.custom("SF Pro", size: 17).weight(.bold))
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    let sampleTimes = [
        TimeRange(startTime: Date(), endTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!),
        TimeRange(startTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!, endTime: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!)
    ]
    return OptimalTime(timeList: sampleTimes)
}
