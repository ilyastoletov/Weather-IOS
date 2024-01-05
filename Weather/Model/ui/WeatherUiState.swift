//
//  WeatherUiState.swift
//  Weather
//
//  Created by Ilya Stoletov on 02.01.2024.
//

import Foundation

struct WeatherUiState {
    let condition: Condition
    let iconUrl: String
    let feelsLike: Int
    let degrees: Int
    let hourlyPredictionList: [HourlyPrediction]
    
    static func getDemoInstance() -> WeatherUiState {
        return WeatherUiState(
            condition: Condition(),
            iconUrl: "",
            feelsLike: 0,
            degrees: 0,
            hourlyPredictionList: []
        )
    }
    
}
