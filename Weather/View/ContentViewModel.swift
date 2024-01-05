//
//  ContentViewModel.swift
//  Actual Weather App
//
//  Created by Ilya Stoletov on 23.12.2023.
//

import Foundation

private let WEATHER_API_KEY = "8e45e1a6-86fb-44ce-8035-480574a446df"

final class ContentViewModel: ObservableObject {
    
    @Published public private(set) var weatherData: WeatherUiState = WeatherUiState.getDemoInstance()
    @Published public var isLoading = false
    
    func getWeather(lat: Double, lon: Double) {
        
        isLoading = true
        
        let endpoint = "https://api.weather.yandex.ru/v2/informers"
        var urlBuilder = URLComponents(string: endpoint)
        urlBuilder?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        guard let url = urlBuilder?.url else { return  }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(WEATHER_API_KEY, forHTTPHeaderField: "X-Yandex-API-Key")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let concreteData = data else {
                print("something wrong")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedData = try decoder.decode(WeatherDto.self, from: concreteData)
                print(decodedData)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.weatherData = WeatherUiState(
                        condition: Condition.resolveCondition(condition: decodedData.fact.condition),
                        iconUrl: "https://yastatic.net/weather/i/icons/funky/dark/\(decodedData.fact.icon).svg",
                        feelsLike: decodedData.fact.feelsLike,
                        degrees: decodedData.fact.temp,
                        hourlyPredictionList: PartlyPrediction.convertToHourlyPredictionList(parts: decodedData.forecast.parts)
                    )
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
}
