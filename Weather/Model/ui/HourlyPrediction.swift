//
//  HourlyPrediction.swift
//  Weather
//
//  Created by Ilya Stoletov on 02.01.2024.
//

import Foundation

struct HourlyPrediction: Identifiable {
    var id = UUID()
    let hour: String
    let condition: Condition
    let degrees: Int
}

extension HourlyPrediction {
    static func resolvePartOfDay(partFromDto: String) -> String {
        switch (partFromDto) {
        case "morning":
            return "Утро"
        case "night":
            return "Ночь"
        case "evening":
            return "Вечер"
        case "afternoon":
            return "День"
        default:
            return "Ошибка"
        }
    }
}
