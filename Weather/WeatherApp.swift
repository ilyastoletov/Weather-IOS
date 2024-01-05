//
//  WeatherApp.swift
//  Weather
//
//  Created by Ilya Stoletov on 02.01.2024.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreenView(viewModel: ContentViewModel())
        }
    }
}

