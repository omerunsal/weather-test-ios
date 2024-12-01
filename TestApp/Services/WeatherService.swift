import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check the city name."
        case .invalidResponse:
            return "Invalid response from the server."
        case .invalidData:
            return "Could not process weather data."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class WeatherService {
    private let apiKey = ""
    private let baseURL = ""
    
    func fetchWeather(for city: String = "Istanbul") async throws -> WeatherResponse {
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.invalidResponse
            }
            
            if httpResponse.statusCode == 401 {
                throw WeatherError.networkError(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid API key. Please check your OpenWeatherMap API key."]))
            }
            
            guard httpResponse.statusCode == 200 else {
                // Try to decode error message if available
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw WeatherError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.message]))
                }
                throw WeatherError.invalidResponse
            }
            
            do {
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                return weather
            } catch {
                print("Decoding error: \(error)")
                throw WeatherError.invalidData
            }
        } catch {
            if let weatherError = error as? WeatherError {
                throw weatherError
            }
            throw WeatherError.networkError(error)
        }
    }
}

struct ErrorResponse: Codable {
    let message: String
} 