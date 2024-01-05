//
//  WeatherDto.swift
//  Weather
//
//  Created by Ilya Stoletov on 02.01.2024.
//

import Foundation

struct WeatherDto: Codable {
    let fact: FactWeather
    let forecast: ForecastObject
}

struct FactWeather: Codable {
    let temp: Int
    let feelsLike: Int
    let icon: String
    let condition: String
}

struct ForecastObject: Codable {
    let parts: [PartlyPrediction]
}

struct PartlyPrediction: Codable {
    let partName: String
    let tempAvg: Int
    let feelsLike: Int
    let icon: String
    let condition: String
    
    static func convertToHourlyPredictionList(parts: [PartlyPrediction]) -> [HourlyPrediction] {
        return parts.map { part in
            HourlyPrediction(
                hour: HourlyPrediction.resolvePartOfDay(partFromDto: part.partName),
                condition: Condition.resolveCondition(condition: part.condition),
                degrees: part.tempAvg
            )
        }
    }
    
}
