//
//  ContentView.swift
//  Actual Weather App
//
//  Created by Ilya Stoletov on 01.02.2024.
//

import Combine
import SwiftUI
import Foundation

struct MainScreenView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    @StateObject private var deviceLocationService = DeviceLocationService.shared
    
    @State private var tokens: Set<AnyCancellable> = []
    @State private var cityName: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 50) {
                if self.viewModel.isLoading {
                    LoadingView()
                } else {
                    WeatherInfo(
                        cityName: $cityName,
                        viewModel: self.viewModel
                    )
                    HourlyPredictionList(viewModel: self.viewModel)
                }
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
        .edgesIgnoringSafeArea(.all)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.74, green: 0.91, blue: 1), location: 0.00),
                    Gradient.Stop(color: .white, location: 0.6)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .onAppear {
            observeCoordinatesUpdate()
            observeLocationPermissionDenied()
            observeCityNameChange()
            deviceLocationService.requestLocationUpdates()
        }
    }
    
    private func observeCoordinatesUpdate() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                },
                receiveValue: { receivedLocation in
                    viewModel.getWeather(lat: receivedLocation.latitude, lon: receivedLocation.longitude)
                }
            )
            .store(in: &tokens)
    }
    
    private func observeCityNameChange() {
        deviceLocationService.cityNamePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let failure) = completion {
                        print(failure)
                    }
                },
                receiveValue: { cityName in
                    self.cityName = cityName
                }
            )
            .store(in: &tokens)
    }
    
    private func observeLocationPermissionDenied() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Some error")
            }
            .store(in: &tokens)
    }
    
}

private struct WeatherInfo: View {
    
    @Binding var cityName: String
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            
            Text(cityName)
                .bold()
                .font(Font.custom("base_font", size: 30))
                .frame(maxWidth: 330)
                .multilineTextAlignment(.center)
            
            Image(viewModel.weatherData.condition.imageId)
                .resizable()
                .frame(width: 156, height: 156)
            
            Text(viewModel.weatherData.condition.name)
                .font(Font.custom("base_font", size: 20))
            
            Text("\(viewModel.weatherData.degrees) °C")
                .bold()
                .font(Font.custom("base_font", size: 50))
            
            Text("Ощущается как: \(viewModel.weatherData.feelsLike) °C")
                .font(Font.custom("base_font", size: 20))
            
        }
    }
    
}

private struct HourlyPredictionList: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            Text("Прогноз по частям дня:")
                .font(Font.custom("base_font", size: 18))
            
            let hourlyPrediction = viewModel.weatherData.hourlyPredictionList
            VStack(alignment: .center) {
                ForEach(0..<hourlyPrediction.count) { i in
                    HourlyPredictionView(predictionItem: hourlyPrediction[i])
                    Rectangle()
                        .fill(SwiftUI.Color.gray.opacity(0.3))
                        .frame(
                            width: .infinity,
                            height: 1
                        )
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
}

private struct HourlyPredictionView: View {
    
    var predictionItem: HourlyPrediction
    
    var body: some View {
        HStack(alignment: .center, spacing: 60) {
            
            Text(predictionItem.hour)
                .bold()
                .font(Font.custom("base_font", size: 25))
            
            VStack(spacing: 10) {
                Text(predictionItem.condition.name)
                    .font(Font.custom("base_font", size: 20))
                    .foregroundStyle(SwiftUI.Color.gray.opacity(0.7))
                
                Text("\(predictionItem.degrees) °C")
                    .bold()
                    .font(Font.custom("base_font", size: 23))
            }
            
            Image(predictionItem.condition.imageId)
                .resizable()
                .frame(width: 64, height: 64)
            
        }
    }
    
}

/*
 VStack(alignment: .center) {
     
     Text(predictionItem.hour)
         .font(Font.custom("base_font", size: 12))
     
     Image(predictionItem.condition.imageId)
         .resizable()
         .frame(width: 32, height: 32)
     
     Text("\(predictionItem.degrees) °C")
         .font(Font.custom("base_font", size: 12))
 }
 .frame(width: 70, height: 100)
 .background(
     SwiftUI.Color.gray.opacity(0.3)
 )
 .cornerRadius(10)
 */

