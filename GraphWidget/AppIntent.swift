//
//  AppIntent.swift
//  GraphWidget
//
//  Created by Иван Легенький on 26.12.2023.
//

import WidgetKit
import AppIntents
import SwiftUI

struct TabButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "Tab Button Intent"
    
    @Parameter(title: "App ID", default: "")
    
    var appID: String
    
    init() {
        
    }
    
    init(appID: String) {
        self.appID = appID
    }
    
    func perform() async throws -> some IntentResult {
        UserDefaults.standard.setValue(appID, forKey: "selectedApp")
        return .result()
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")
    
    @Parameter(title: "Line Chart", default: false)
    var isLineChart: Bool
    
    @Parameter(title: "Chart Tint", query: ChartTintQuery())
    var chartTint: ChartTint?
}

struct ChartTint: AppEntity {
    var id: UUID = .init()
    var name: String
    var color: Color
    
    static var defaultQuery = ChartTintQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Chart Tint"
    
    var displayRepresentation: DisplayRepresentation {
        return .init(title: "\(name)")
    }
}

struct ChartTintQuery: EntityQuery {
    func entities(for identifiers: [ChartTint.ID]) async throws -> [ChartTint] {
        return chartTints.filter { tint in
            identifiers.contains(where: { $0 == tint.id })
        }
    }
    
    func suggestedEntities() async throws -> [ChartTint] {
        return chartTints
    }
    
    func defaultResult() async -> ChartTint? {
        return chartTints.first
    }
}

var chartTints: [ChartTint] = [
    .init(name: "Red", color: .red),
    .init(name: "Blue", color: .blue),
    .init(name: "Green", color: .green),
    .init(name: "Purple", color: .purple)
]
