//
//  AppModel.swift
//  GraphWidgetExtension
//
//  Created by Иван Легенький on 26.12.2023.
//

import SwiftUI

struct AppModel: Identifiable {
    var id: String
    var appName: String
    var appDownloads: [Downloads]
}

let apps: [AppModel] = [
    .init(id: "App 1", appName: "App 1 name", appDownloads: appDownloads),
    .init(id: "App 2", appName: "App 2 name", appDownloads: appDownloads1),
    .init(id: "App 3", appName: "App 3 name", appDownloads: appDownloads2),
]
