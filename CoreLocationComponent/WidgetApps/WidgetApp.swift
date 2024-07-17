//
//  WidgetApps.swift
//  WidgetApps
//
//  Created by Reynard Octavius Tan on 15/07/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), safeWeatherData: data.weatherData(), currentWeather: data.currentWeather())
//        SimpleEntry(date: Date(), safeWeatherData: data.weatherData(), currentWeather: .risk)
        
        
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), safeWeatherData: data.weatherData(), currentWeather: data.currentWeather())
//        let entry = SimpleEntry(date: Date(), safeWeatherData: data.weatherData(), currentWeather: .risk)
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfHour = calendar.date(bySetting: .minute, value: 0, of: currentDate)!
        let startOfCurrentHour = calendar.date(bySetting: .second, value: 0, of: startOfHour)!

        
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, safeWeatherData: data.weatherData(), currentWeather: data.currentWeather())
//            let entry = SimpleEntry(date: entryDate, safeWeatherData: data.weatherData(), currentWeather: .risk)
            entries.append(entry)
        }
        
//        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let nextUpdateDate = calendar.date(byAdding: .hour, value: 1, to: startOfCurrentHour)!

        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let safeWeatherData : String
    let currentWeather : currentWeatherWidgetUtil
}

struct WidgetAppEntryView : View {
    var entry: Provider.Entry
    let data = DataService()
    
    @Environment(\.widgetFamily) var widgetFamily
    
    
    var body: some View {
        
        let stringDate = self.entry.safeWeatherData
        let formattedTextofTime = dateFormatter(stringDate: stringDate)
        let weatherUtil = entry.currentWeather
        
        switch widgetFamily{
        case .systemSmall:
            ZStack{
                VStack{
                    Rectangle().foregroundStyle(weatherUtil == .safe ? Color.blue : Color.gray)
                        .frame(width: 158, height: 79)
                        .offset(y: 45)
                }
                VStack(alignment:.leading){
                    Image(systemName: weatherUtil.imageSystemName)
                        .font(.system(size: 30))
                        .foregroundStyle(weatherUtil == .safe ? Color.orange : Color.gray)
                        .padding(.bottom, 7)
                    
                    Text(weatherUtil.copyWritingFeeDelivery).fontWeight(.regular).font(.system(size: 11)).padding(.bottom, 5)
                    
                    
                    Text(weatherUtil.copyWritingOrdering)
                        .font(.system(size: 22))
                        .bold()
                        .foregroundStyle(Color.white)
                    
//                    Text("\(weatherUtil.statusCondition) \(formattedTextofTime.1)").fontWeight(.regular).font(.system(size: 15))
//                        .foregroundStyle(Color.white)
                    
                    Text("\(weatherUtil.statusCondition) \(formattedTextofTime.1)").fontWeight(.regular).font(.system(size: 15))
                        .foregroundStyle(Color.white)
                }
            }
            
        default:
            ZStack{
                VStack{
                    Rectangle().foregroundStyle(weatherUtil == .safe ? Color.blue : Color.gray)
                        .frame(width: 338, height: 59)
                        .offset(y: -50)
                }
                
                VStack(alignment: .leading){
                    Text(weatherUtil.copyWritingOrdering)
                        .fontWeight(.regular)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                    Text("\(weatherUtil.statusCondition) \(formattedTextofTime.0)")
                        .fontWeight(.regular)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white)
                    // plot goes here
                    Spacer()
                    
                    
                }.ignoresSafeArea()
                
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
    
//    func getFormattedText(weatherUtil: currentWeatherWidgetUtil, formattedTextofTime: (String, String)) -> String {
//
//        
//        }
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
        .configurationDisplayName("Weathery")
        .description("Help you to know the best time for ordering food")
        //bisa ada 2
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall ) {
    WidgetApp()
} timeline: {
    SimpleEntry(date: .now, safeWeatherData: "2024-07-15 08:00:00 +0000 - 2024-07-16 12:00:00 +0000", currentWeather: .safe)
    SimpleEntry(date: .now, safeWeatherData: "2024-07-15 01:00:00 +0000 - 2024-07-16 17:00:00 +0000", currentWeather: .risk)
}
