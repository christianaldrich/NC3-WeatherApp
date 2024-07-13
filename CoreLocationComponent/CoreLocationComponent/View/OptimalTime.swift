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
//                .font(.system(size: 17, weight: .regular, design: .default))
//                .padding(.bottom, -10)
                        
            VStack (spacing: 10) {
                
                ForEach(timeList, id: \.id) { timeListItem in
                    ZStack{
                        
                        HStack {
                            Text("\(timeFormatter.string(from: timeListItem.startTime))")
//                                .font(.system(size: 34, weight: .bold, design: .default))
                            
                            
                            Text("to \(timeFormatter.string(from: timeListItem.endTime))")
//                                .font(.system(size: 34, weight: .bold, design: .default))
                            
                        }
                        .zIndex(1)
                        
                        
//                        Rectangle()
//                            .frame(width: 242, height: 77)
//                            .cornerRadius(10)
//                            .foregroundColor(.blue)
                        
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
