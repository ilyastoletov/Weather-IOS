//
//  WeatherCondition.swift
//  Weather
//
//  Created by Ilya Stoletov on 02.01.2024.
//

import Foundation

struct Condition {
    let name: String
    let imageId: String
    
    init() {
        self.name = ""
        self.imageId = ""
    }
    
    init(name: String, imageId: String) {
        self.name = name
        self.imageId = imageId
    }
    
    static func resolveCondition(condition: String) -> Condition {
        switch condition {
        case "clear":
            return Condition(name: "Ясно", imageId: "Sunny")
        case "partly-cloudy":
            return Condition(name: "Малооблачно", imageId: "very-cloudy")
        case "cloudy":
            return Condition(name: "Облачно", imageId: "very-cloudy")
        case "overcast":
            return Condition(name: "Пасмурно", imageId: "very-cloudy")
        case "light-rain":
            return Condition(name: "Небольшой дождь", imageId: "Rainy")
        case "rain":
            return Condition(name: "Дождь", imageId: "shower")
        case "heavy-rain":
            return Condition(name: "Сильный дождь", imageId: "shower")
        case "showers":
            return Condition(name: "Ливень", imageId: "very-rainy")
        case "wet-snow":
            return Condition(name: "Мокрый снег", imageId: "Snowy")
        case "light-snow":
            return Condition(name: "Небольшой снег", imageId: "Snow")
        case "snow":
            return Condition(name: "Снег", imageId: "clear-snow")
        case "snow-showers":
            return Condition(name: "Снегопад", imageId: "Snow")
        case "hail":
            return Condition(name: "Град", imageId: "hail")
        case "thunderstorm":
            return Condition(name: "Гроза", imageId: "thunderstorm")
        case "thunderstorm-with-rain":
            return Condition(name: "Гроза с дождем", imageId: "rain-with-thunder")
        case "thunderstorm-with-hail":
            return Condition(name: "Гроза с градом", imageId: "hail-with-thunder")
        default:
            return Condition(name: "", imageId: "")
        }
    }
}
