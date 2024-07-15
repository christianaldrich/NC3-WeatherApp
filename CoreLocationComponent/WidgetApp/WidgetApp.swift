//
//  WidgetApp.swift
//  WidgetApp
//  
//  Created by Reynard Octavius Tan on 13/07/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),safeWeatherData: data.weatherData())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), safeWeatherData: data.weatherData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        //ngecek 24 jam Time line
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, safeWeatherData: data.weatherData())
            entries.append(entry)
        }
        
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let safeWeatherData : String
}

struct WidgetAppEntryView : View {
    var entry: Provider.Entry
    let data = DataService()
    
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        
        let stringDate = self.entry.safeWeatherData
        let formattedTextofTime = dateFormatter(stringDate: stringDate)
        
        switch widgetFamily{
        case .systemSmall:
            
            VStack (alignment: .leading){
                Text("Optimal \nDelivery Time")
                    .fontWeight(.regular)
                    .font(.system(size: 17))
                Spacer()
                HStack{
                    Text(formattedTextofTime.0)
                        .fontWeight(.bold)
                        .font(.system(size: 28))
                    VStack{
                        Image(systemName: "chevron.down").foregroundStyle(.green).opacity(0.5)
                        Image(systemName: "chevron.down").foregroundStyle(.green)
                    }
                }
                Text("until \(formattedTextofTime.1)")
                    .fontWeight(.bold)
                    .font(.system(size: 17))
            }
            
        default:
            VStack(alignment: .trailing){
                Text("Optimal Delivery Time")
                    .fontWeight(.regular)
                    .font(.system(size: 11))
                Text("\(formattedTextofTime.0) until \(formattedTextofTime.1)")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                // plot goes here
                Spacer()
                
                
            }

        }
        
    }
    
    func dateFormatter(stringDate: String) -> (String, String) {
            let dateComponents = stringDate.components(separatedBy: " - ")
            guard dateComponents.count == 2 else {
                fatalError("Invalid date string format")
            }

            let startDateString = dateComponents[0]
            let endDateString = dateComponents[1]

            // Formatter untuk mengubah string menjadi Date
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

            // Formatter untuk mengubah Date menjadi string dengan format jam dan am/pm
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "ha"

            // Ubah string menjadi Date
            guard let startDate = inputFormatter.date(from: startDateString),
                  let endDate = inputFormatter.date(from: endDateString) else {
                fatalError("Invalid date format")
            }

            // Ubah Date menjadi string dengan format jam dan am/pm
            let startTimeString = outputFormatter.string(from: startDate)
            let endTimeString = outputFormatter.string(from: endDate)
            
            return (startTimeString, endTimeString)
        }
}

struct WidgetApp: Widget {
    let kind: String = "WidgetApp"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetAppEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetAppEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("-name apps-")
        .description("Help you to know the best time for ordering food")
        //bisa ada 2
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    WidgetApp()
} timeline: {
    SimpleEntry(date: .now, safeWeatherData: "2024-07-15 08:00:00 +0000 - 2024-07-16 12:00:00 +0000")
    SimpleEntry(date: .now, safeWeatherData: "2024-07-15 01:00:00 +0000 - 2024-07-16 17:00:00 +0000")
}

