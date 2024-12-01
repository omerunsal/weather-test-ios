//
//  ContentView.swift
//  TestApp
//
//  Created by omer on 30.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            } else {
                VStack {
                    Text("Weather")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Navigation buttons and card
                    HStack {
                        Button(action: {
                            withAnimation {
                                viewModel.previousCity()
                            }
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        if let weather = viewModel.weatherData[viewModel.currentCity.name] {
                            CityCard(weather: weather, timeZoneIdentifier: viewModel.currentCity.timezone)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)
                                ))
                        }
                        
                        Button(action: {
                            withAnimation {
                                viewModel.nextCity()
                            }
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.cities.count, id: \.self) { index in
                            Circle()
                                .fill(index == viewModel.currentCityIndex ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .onAppear {
            viewModel.fetchAllWeather()
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("Retry") {
                viewModel.fetchAllWeather()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
    }
}
