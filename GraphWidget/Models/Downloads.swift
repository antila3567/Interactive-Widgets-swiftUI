//
//  Downloads.swift
//  GraphWidgetExtension
//
//  Created by Иван Легенький on 26.12.2023.
//

import SwiftUI

struct Downloads: Identifiable, Equatable {
    var id: UUID = .init()
    var date: Date
    var value: Int
}

extension Date {
    static func day(_ value: Int) -> Date {
        let calendar = Calendar.current
        
        return calendar.date(byAdding: .day, value: value, to: .now) ?? .now
    }
}

var appDownloads: [Downloads] = [
    .init(date: .day(0), value: 100),
    .init(date: .day(-1), value: 30),
    .init(date: .day(-2), value: 222),
    .init(date: .day(-3), value: 490),
    .init(date: .day(-4), value: 30),
    .init(date: .day(-5), value: 998),
    .init(date: .day(-6), value: 55),
]

var appDownloads1: [Downloads] = [
    .init(date: .day(0), value: 20),
    .init(date: .day(-1), value: 40),
    .init(date: .day(-2), value: 102),
    .init(date: .day(-3), value: 160),
    .init(date: .day(-4), value: 290),
    .init(date: .day(-5), value: 648),
    .init(date: .day(-6), value: 755),
]

var appDownloads2: [Downloads] = [
    .init(date: .day(0), value: 220),
    .init(date: .day(-1), value: 440),
    .init(date: .day(-2), value: 2),
    .init(date: .day(-3), value: 60),
    .init(date: .day(-4), value: 90),
    .init(date: .day(-5), value: 48),
    .init(date: .day(-6), value: 55),
]

