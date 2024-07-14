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

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        //ngecek 24 jam Time line
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, safeWeatherData: data.weatherData())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
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
    @ObservedObject var weatherKitManager = WeatherManager()
    
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        
        switch widgetFamily{
        case .systemSmall:
            OptimalTime(timeList: weatherKitManager.safeWeather) //entah kenapa ga mauu gara gara ga ada datanya yang masuk ? perlu di handle ??? AAAAA KESALLL WKWKWKW
            
//            VStack (alignment: .leading){
//                Text("Optimal \nDelivery Time")
//                    .fontWeight(.regular)
//                    .font(.system(size: 17))
//                Spacer()
//                HStack{
//                    Text("7pmx")
//                        .fontWeight(.bold)
//                        .font(.system(size: 28))
//                    VStack{
//                        Image(systemName: "chevron.down").foregroundStyle(.green).opacity(0.5)
//                        Image(systemName: "chevron.down").foregroundStyle(.green)
//                    }
//                }
//                Text("until 12pm")
//                    .fontWeight(.bold)
//                    .font(.system(size: 17))
                
//                Text(entry.date, style: .time)
               
                
//            }
            
        default:
            VStack{
                Text("Optimal \nDelivery Time")
                    .fontWeight(.regular)
                    .font(.system(size: 11))
                Text("7pm until 12pm")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                // plot goes here
            }

        }
        
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

#Preview(as: .systemSmall) {
    WidgetApp()
} timeline: {
    SimpleEntry(date: .now, safeWeatherData: "7pm")
    SimpleEntry(date: .now, safeWeatherData: "8pm")
}
