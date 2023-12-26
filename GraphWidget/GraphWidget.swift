//
//  GraphWidget.swift
//  GraphWidget
//
//  Created by Иван Легенький on 26.12.2023.
//

import WidgetKit
import SwiftUI
import Charts

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        //Fetch data Here
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), apps: apps)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, apps: apps)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let entry = SimpleEntry(date: .now, configuration: configuration, apps: apps)
        
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let apps: [AppModel]
}

struct GraphWidgetEntryView : View {
    var entry: Provider.Entry

    @AppStorage("selectedApp") private var selectedApp: String = "App 1"
    
    var body: some View {
        VStack {
            Text("App downloads")
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Last 7 Days")
                .font(.caption2)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, -8)
            
            let chartTint: Color = entry.configuration.chartTint?.color ?? .purple
            
            HStack(spacing: 0) {
                ForEach(entry.apps) { app in
                    Button(intent: TabButtonIntent(appID: app.id)) {
                        Text(app.id)
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundStyle(app.id == selectedApp ? .white : .primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background {
                GeometryReader {
                    let size = $0.size
                    let width = size.width / CGFloat(entry.apps.count)
                    
                    Capsule()
                        .fill(chartTint.gradient)
                        .frame(width: width)
                        .offset(x: width * CGFloat(selectedIndex))
                }
            }
            .frame(height: 28)
            .background(.primary.opacity(0.15), in: .capsule)
            
            Chart(selectedAppDownloads) { download in
                if entry.configuration.isLineChart {
                    LineMark(
                        x: .value("Day", dayString(download.date)),
                        y: .value("Downloads", download.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(chartTint)
                    
                    AreaMark(
                        x: .value("Day", dayString(download.date)),
                        y: .value("Downloads", download.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.linearGradient(colors: [
                        chartTint,
                        chartTint.opacity(0.6),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
                } else {
                    BarMark(
                        x: .value("Day", dayString(download.date)),
                        y: .value("Downloads", download.value)
                    )
                    .foregroundStyle(chartTint.gradient)
                }
            }
        }
    }
    
    func dayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEE"
        
        return formatter.string(from: date)
    }
    
    var selectedAppDownloads: [Downloads] {
        return entry.apps.first(where: {$0.id == selectedApp})?.appDownloads ?? []
    }
    
    var selectedIndex: Int {
        return entry.apps.firstIndex(where: {$0.id == selectedApp}) ?? 0
    }
}

struct GraphWidget: Widget {
    let kind: String = "GraphWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GraphWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemLarge, .systemExtraLarge])
    }
}


#Preview(as: .systemLarge) {
    GraphWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .init(), apps: apps)
}
