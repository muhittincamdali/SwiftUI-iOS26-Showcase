// WeatherAppMain.swift
// SwiftUI-iOS26-Showcase
//
// A complete Weather app demonstration using iOS 26 features
// Showcases Liquid Glass design, animations, and modern SwiftUI patterns

import SwiftUI

// MARK: - Weather Data Models

/// Weather condition types
enum WeatherCondition: String, CaseIterable {
    case sunny = "Sunny"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case stormy = "Stormy"
    case snowy = "Snowy"
    case foggy = "Foggy"
    case windy = "Windy"
    
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .stormy: return "cloud.bolt.rain.fill"
        case .snowy: return "cloud.snow.fill"
        case .foggy: return "cloud.fog.fill"
        case .windy: return "wind"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .sunny: return [Color(red: 1, green: 0.8, blue: 0.2), Color(red: 1, green: 0.5, blue: 0.1)]
        case .partlyCloudy: return [Color(red: 0.4, green: 0.7, blue: 1), Color(red: 0.3, green: 0.5, blue: 0.8)]
        case .cloudy: return [Color(red: 0.5, green: 0.5, blue: 0.6), Color(red: 0.3, green: 0.3, blue: 0.4)]
        case .rainy: return [Color(red: 0.3, green: 0.4, blue: 0.6), Color(red: 0.2, green: 0.3, blue: 0.5)]
        case .stormy: return [Color(red: 0.2, green: 0.2, blue: 0.3), Color(red: 0.1, green: 0.1, blue: 0.2)]
        case .snowy: return [Color(red: 0.7, green: 0.8, blue: 0.9), Color(red: 0.5, green: 0.6, blue: 0.8)]
        case .foggy: return [Color(red: 0.6, green: 0.6, blue: 0.7), Color(red: 0.4, green: 0.4, blue: 0.5)]
        case .windy: return [Color(red: 0.5, green: 0.6, blue: 0.7), Color(red: 0.3, green: 0.4, blue: 0.5)]
        }
    }
}

/// Hourly forecast data
struct HourlyForecast: Identifiable {
    let id = UUID()
    let hour: String
    let temperature: Int
    let condition: WeatherCondition
    let precipitation: Int
    
    static func generate(baseTemp: Int, condition: WeatherCondition) -> [HourlyForecast] {
        let hours = ["Now", "1PM", "2PM", "3PM", "4PM", "5PM", "6PM", "7PM", "8PM", "9PM"]
        return hours.enumerated().map { index, hour in
            let tempVariation = Int.random(in: -3...3)
            let conditions: [WeatherCondition] = [condition, condition, .partlyCloudy, condition, condition]
            return HourlyForecast(
                hour: hour,
                temperature: baseTemp + tempVariation,
                condition: conditions[index % conditions.count],
                precipitation: Int.random(in: 0...30)
            )
        }
    }
}

/// Daily forecast data
struct DailyForecast: Identifiable {
    let id = UUID()
    let day: String
    let highTemp: Int
    let lowTemp: Int
    let condition: WeatherCondition
    let precipitation: Int
    
    static let sample: [DailyForecast] = [
        DailyForecast(day: "Today", highTemp: 28, lowTemp: 18, condition: .sunny, precipitation: 0),
        DailyForecast(day: "Tomorrow", highTemp: 26, lowTemp: 17, condition: .partlyCloudy, precipitation: 10),
        DailyForecast(day: "Wednesday", highTemp: 24, lowTemp: 16, condition: .cloudy, precipitation: 30),
        DailyForecast(day: "Thursday", highTemp: 22, lowTemp: 15, condition: .rainy, precipitation: 80),
        DailyForecast(day: "Friday", highTemp: 20, lowTemp: 14, condition: .stormy, precipitation: 90),
        DailyForecast(day: "Saturday", highTemp: 23, lowTemp: 15, condition: .partlyCloudy, precipitation: 20),
        DailyForecast(day: "Sunday", highTemp: 27, lowTemp: 17, condition: .sunny, precipitation: 0)
    ]
}

/// Weather details
struct WeatherDetails {
    let humidity: Int
    let windSpeed: Int
    let uvIndex: Int
    let visibility: Int
    let pressure: Int
    let dewPoint: Int
    
    static let sample = WeatherDetails(
        humidity: 65,
        windSpeed: 12,
        uvIndex: 6,
        visibility: 16,
        pressure: 1013,
        dewPoint: 14
    )
}

/// Location weather data
struct LocationWeather: Identifiable {
    let id = UUID()
    let city: String
    let country: String
    let temperature: Int
    let condition: WeatherCondition
    let isCurrentLocation: Bool
    
    static let sample: [LocationWeather] = [
        LocationWeather(city: "San Francisco", country: "USA", temperature: 22, condition: .partlyCloudy, isCurrentLocation: true),
        LocationWeather(city: "New York", country: "USA", temperature: 28, condition: .sunny, isCurrentLocation: false),
        LocationWeather(city: "London", country: "UK", temperature: 18, condition: .rainy, isCurrentLocation: false),
        LocationWeather(city: "Tokyo", country: "Japan", temperature: 30, condition: .sunny, isCurrentLocation: false),
        LocationWeather(city: "Sydney", country: "Australia", temperature: 15, condition: .cloudy, isCurrentLocation: false)
    ]
}

// MARK: - Weather View Model

@Observable
final class WeatherViewModel {
    var currentLocation: LocationWeather = .sample[0]
    var locations: [LocationWeather] = LocationWeather.sample
    var hourlyForecast: [HourlyForecast] = []
    var dailyForecast: [DailyForecast] = DailyForecast.sample
    var details: WeatherDetails = .sample
    var isLoading: Bool = false
    var selectedLocationIndex: Int = 0
    
    init() {
        updateHourlyForecast()
    }
    
    func updateHourlyForecast() {
        hourlyForecast = HourlyForecast.generate(
            baseTemp: currentLocation.temperature,
            condition: currentLocation.condition
        )
    }
    
    func selectLocation(at index: Int) {
        selectedLocationIndex = index
        currentLocation = locations[index]
        updateHourlyForecast()
    }
    
    func refresh() async {
        isLoading = true
        try? await Task.sleep(for: .seconds(1))
        updateHourlyForecast()
        isLoading = false
    }
}

// MARK: - Main Weather View

/// Complete weather app showcase
public struct WeatherAppMain: View {
    @State private var viewModel = WeatherViewModel()
    @State private var showLocationPicker = false
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                currentWeatherHeader
                
                hourlyForecastSection
                
                dailyForecastSection
                
                weatherDetailsGrid
                
                sunriseSunsetSection
            }
            .padding()
        }
        .background(backgroundGradient)
        .refreshable {
            await viewModel.refresh()
        }
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerSheet(
                locations: viewModel.locations,
                selectedIndex: viewModel.selectedLocationIndex
            ) { index in
                viewModel.selectLocation(at: index)
                showLocationPicker = false
            }
            .presentationDetents([.medium])
        }
        .navigationTitle("Weather")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showLocationPicker = true
                } label: {
                    Image(systemName: "location.circle")
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    // MARK: - Current Weather
    
    private var currentWeatherHeader: some View {
        VStack(spacing: 16) {
            // Location
            HStack {
                Image(systemName: viewModel.currentLocation.isCurrentLocation ? "location.fill" : "location")
                    .font(.caption)
                
                Text(viewModel.currentLocation.city)
                    .font(.title3.bold())
                
                if viewModel.currentLocation.isCurrentLocation {
                    Text("Current Location")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.2)))
                }
            }
            .foregroundStyle(.white)
            
            // Temperature
            Text("\(viewModel.currentLocation.temperature)°")
                .font(.system(size: 96, weight: .thin))
                .foregroundStyle(.white)
            
            // Condition
            HStack(spacing: 8) {
                Image(systemName: viewModel.currentLocation.condition.icon)
                    .font(.title2)
                
                Text(viewModel.currentLocation.condition.rawValue)
                    .font(.title3)
            }
            .foregroundStyle(.white.opacity(0.9))
            
            // High/Low
            HStack(spacing: 16) {
                Label("H: \(viewModel.dailyForecast[0].highTemp)°", systemImage: "arrow.up")
                Label("L: \(viewModel.dailyForecast[0].lowTemp)°", systemImage: "arrow.down")
            }
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.vertical, 32)
    }
    
    // MARK: - Hourly Forecast
    
    private var hourlyForecastSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("HOURLY FORECAST")
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.6))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.hourlyForecast) { forecast in
                        HourlyForecastCard(forecast: forecast)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Daily Forecast
    
    private var dailyForecastSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7-DAY FORECAST")
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.6))
            
            VStack(spacing: 0) {
                ForEach(viewModel.dailyForecast) { forecast in
                    DailyForecastRow(forecast: forecast)
                    
                    if forecast.id != viewModel.dailyForecast.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Details Grid
    
    private var weatherDetailsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            WeatherDetailCard(
                title: "HUMIDITY",
                value: "\(viewModel.details.humidity)%",
                icon: "humidity.fill",
                description: "The dew point is \(viewModel.details.dewPoint)° right now"
            )
            
            WeatherDetailCard(
                title: "WIND",
                value: "\(viewModel.details.windSpeed) km/h",
                icon: "wind",
                description: "Gusts up to 20 km/h"
            )
            
            WeatherDetailCard(
                title: "UV INDEX",
                value: "\(viewModel.details.uvIndex)",
                icon: "sun.max.fill",
                description: uvIndexDescription
            )
            
            WeatherDetailCard(
                title: "VISIBILITY",
                value: "\(viewModel.details.visibility) km",
                icon: "eye.fill",
                description: "Clear visibility"
            )
            
            WeatherDetailCard(
                title: "PRESSURE",
                value: "\(viewModel.details.pressure) hPa",
                icon: "gauge.medium",
                description: "Normal pressure"
            )
            
            WeatherDetailCard(
                title: "FEELS LIKE",
                value: "\(viewModel.currentLocation.temperature + 2)°",
                icon: "thermometer.medium",
                description: "Humidity makes it feel warmer"
            )
        }
    }
    
    // MARK: - Sunrise/Sunset
    
    private var sunriseSunsetSection: some View {
        HStack(spacing: 12) {
            SunTimeCard(
                title: "SUNRISE",
                time: "6:23 AM",
                icon: "sunrise.fill",
                color: .orange
            )
            
            SunTimeCard(
                title: "SUNSET",
                time: "7:45 PM",
                icon: "sunset.fill",
                color: .pink
            )
        }
    }
    
    // MARK: - Helpers
    
    private var uvIndexDescription: String {
        switch viewModel.details.uvIndex {
        case 0...2: return "Low"
        case 3...5: return "Moderate"
        case 6...7: return "High"
        case 8...10: return "Very High"
        default: return "Extreme"
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: viewModel.currentLocation.condition.colors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Supporting Views

struct HourlyForecastCard: View {
    let forecast: HourlyForecast
    
    var body: some View {
        VStack(spacing: 12) {
            Text(forecast.hour)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
            
            Image(systemName: forecast.condition.icon)
                .font(.title2)
                .foregroundStyle(.white)
            
            Text("\(forecast.temperature)°")
                .font(.headline)
                .foregroundStyle(.white)
        }
        .frame(width: 60)
    }
}

struct DailyForecastRow: View {
    let forecast: DailyForecast
    
    var body: some View {
        HStack {
            Text(forecast.day)
                .font(.subheadline)
                .foregroundStyle(.white)
                .frame(width: 80, alignment: .leading)
            
            Image(systemName: forecast.condition.icon)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 30)
            
            if forecast.precipitation > 0 {
                Text("\(forecast.precipitation)%")
                    .font(.caption)
                    .foregroundStyle(.cyan)
                    .frame(width: 35)
            } else {
                Spacer()
                    .frame(width: 35)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(forecast.lowTemp)°")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
                
                TemperatureBar(low: forecast.lowTemp, high: forecast.highTemp)
                    .frame(width: 80)
                
                Text("\(forecast.highTemp)°")
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
        }
        .padding(.vertical, 12)
    }
}

struct TemperatureBar: View {
    let low: Int
    let high: Int
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let range = 20.0 // Assume range from 10 to 30
            let lowPercent = CGFloat(low - 10) / range
            let highPercent = CGFloat(high - 10) / range
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 4)
                
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: (highPercent - lowPercent) * width, height: 4)
                    .offset(x: lowPercent * width)
            }
        }
        .frame(height: 4)
    }
}

struct WeatherDetailCard: View {
    let title: String
    let value: String
    let icon: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
            }
            .foregroundStyle(.white.opacity(0.6))
            
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct SunTimeCard: View {
    let title: String
    let time: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
            }
            .font(.caption)
            .foregroundStyle(.white.opacity(0.6))
            
            Text(time)
                .font(.title2.bold())
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct LocationPickerSheet: View {
    let locations: [LocationWeather]
    let selectedIndex: Int
    let onSelect: (Int) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(locations.enumerated()), id: \.element.id) { index, location in
                    Button {
                        onSelect(index)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    if location.isCurrentLocation {
                                        Image(systemName: "location.fill")
                                            .font(.caption)
                                    }
                                    Text(location.city)
                                        .font(.headline)
                                }
                                
                                Text(location.country)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Image(systemName: location.condition.icon)
                                Text("\(location.temperature)°")
                                    .font(.title2)
                            }
                            
                            if index == selectedIndex {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle("Locations")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

#Preview("Weather App") {
    NavigationStack {
        WeatherAppMain()
    }
}
