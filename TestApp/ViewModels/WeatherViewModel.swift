import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: [String: WeatherResponse] = [:]
    @Published var error: Error?
    @Published var isLoading = false
    @Published var currentCityIndex = 0
    
    private let weatherService = WeatherService()
    
    let cities = [
        (name: "Istanbul", timezone: "Europe/Istanbul"),
        (name: "London", timezone: "Europe/London"),
        (name: "New York", timezone: "America/New_York")
    ]
    
    var currentCity: (name: String, timezone: String) {
        cities[currentCityIndex]
    }
    
    func nextCity() {
        currentCityIndex = (currentCityIndex + 1) % cities.count
    }
    
    func previousCity() {
        currentCityIndex = (currentCityIndex - 1 + cities.count) % cities.count
    }
    
    func fetchAllWeather() {
        isLoading = true
        
        Task {
            await withTaskGroup(of: Void.self) { group in
                for city in cities {
                    group.addTask {
                        do {
                            let weather = try await self.weatherService.fetchWeather(for: city.name)
                            await MainActor.run {
                                self.weatherData[city.name] = weather
                            }
                        } catch {
                            await MainActor.run {
                                self.error = error
                            }
                        }
                    }
                }
            }
            isLoading = false
        }
    }
} 