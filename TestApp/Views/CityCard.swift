import SwiftUI

struct CityCard: View {
    let weather: WeatherResponse
    let timeZoneIdentifier: String
    
    // Fixed size constants
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 200
    
    private var localTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    private var backgroundColor: Color {
        let temp = weather.main.temp
        switch temp {
        case ...0: return Color.blue.opacity(0.7)
        case 0..<15: return Color.cyan.opacity(0.7)
        case 15..<25: return Color.orange.opacity(0.7)
        default: return Color.red.opacity(0.7)
        }
    }
    
    private var weatherSymbol: String {
        if let condition = weather.weather.first?.main.lowercased() {
            switch condition {
            case let x where x.contains("clear"): return "sun.max.fill"
            case let x where x.contains("cloud"): return "cloud.fill"
            case let x where x.contains("rain"): return "cloud.rain.fill"
            case let x where x.contains("snow"): return "snow"
            case let x where x.contains("thunder"): return "cloud.bolt.fill"
            default: return "cloud.fill"
            }
        }
        return "cloud.fill"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // City name and time
            HStack {
                Text(weather.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Text(localTime)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Weather icon and temperature
            HStack(alignment: .center) {
                Image(systemName: weatherSymbol)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .frame(width: 60)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(Int(round(weather.main.temp)))°")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(weather.weather.first?.description.capitalized ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Spacer()
            
            // Weather info badges
            HStack {
                WeatherInfoBadge(icon: "thermometer", value: "Feels \(Int(round(weather.main.feelsLike)))°")
                Spacer()
                WeatherInfoBadge(icon: "humidity", value: "\(weather.main.humidity)%")
                Spacer()
                WeatherInfoBadge(icon: "wind", value: "\(Int(round(weather.wind.speed))) m/s")
            }
        }
        .padding()
        .frame(width: cardWidth, height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(backgroundColor)
                .shadow(radius: 5)
        )
    }
}

struct WeatherInfoBadge: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(value)
                .font(.system(size: 12))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
        .foregroundColor(.white)
    }
} 