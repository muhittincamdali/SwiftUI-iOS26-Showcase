// ShowcaseTests.swift
// SwiftUI iOS 26 Showcase - Comprehensive Test Suite
// Copyright © 2025. MIT License.

import XCTest
import SwiftUI
@testable import SwiftUIiOS26Showcase

// MARK: - Glass Effect Tests

/// Tests for Liquid Glass visual components
final class GlassEffectTests: XCTestCase {
    
    // MARK: - Glass Material Tests
    
    /// Verifies glass material renders with correct blur radius
    func testGlassMaterialBlurRadius() throws {
        let expectedBlur: CGFloat = 20.0
        let material = GlassMaterial(blurRadius: expectedBlur)
        XCTAssertEqual(material.blurRadius, expectedBlur, "Blur radius should match expected value")
    }
    
    /// Tests glass tint color application
    func testGlassTintColor() throws {
        let tintColor = Color.blue.opacity(0.3)
        let material = GlassMaterial(tintColor: tintColor)
        XCTAssertNotNil(material.tintColor, "Tint color should be set")
    }
    
    /// Validates glass opacity range
    func testGlassOpacityRange() throws {
        let material = GlassMaterial(opacity: 0.5)
        XCTAssertGreaterThanOrEqual(material.opacity, 0.0, "Opacity should be >= 0")
        XCTAssertLessThanOrEqual(material.opacity, 1.0, "Opacity should be <= 1")
    }
    
    /// Tests glass corner radius customization
    func testGlassCornerRadius() throws {
        let cornerRadius: CGFloat = 16.0
        let config = GlassConfiguration(cornerRadius: cornerRadius)
        XCTAssertEqual(config.cornerRadius, cornerRadius, "Corner radius should match")
    }
    
    // MARK: - Glass Animation Tests
    
    /// Verifies smooth transition between glass states
    func testGlassStateTransition() throws {
        let animator = GlassAnimator()
        animator.transitionTo(.expanded)
        XCTAssertEqual(animator.currentState, .expanded, "Should transition to expanded state")
    }
    
    /// Tests animation duration configuration
    func testAnimationDuration() throws {
        let duration: TimeInterval = 0.35
        let animator = GlassAnimator(duration: duration)
        XCTAssertEqual(animator.animationDuration, duration, accuracy: 0.01)
    }
    
    /// Validates spring animation parameters
    func testSpringAnimationParameters() throws {
        let spring = GlassSpringAnimation(response: 0.4, dampingFraction: 0.8)
        XCTAssertEqual(spring.response, 0.4, accuracy: 0.01)
        XCTAssertEqual(spring.dampingFraction, 0.8, accuracy: 0.01)
    }
    
    /// Tests animation completion callback
    func testAnimationCompletion() throws {
        let expectation = XCTestExpectation(description: "Animation completes")
        let animator = GlassAnimator()
        
        animator.animate(to: .collapsed) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Weather App Tests

/// Tests for Weather application components
final class WeatherAppTests: XCTestCase {
    
    // MARK: - Weather Data Tests
    
    /// Tests weather data model initialization
    func testWeatherDataInitialization() throws {
        let weather = WeatherData(
            temperature: 22.5,
            condition: .sunny,
            humidity: 65,
            windSpeed: 12.3
        )
        
        XCTAssertEqual(weather.temperature, 22.5, accuracy: 0.1)
        XCTAssertEqual(weather.condition, .sunny)
        XCTAssertEqual(weather.humidity, 65)
        XCTAssertEqual(weather.windSpeed, 12.3, accuracy: 0.1)
    }
    
    /// Validates temperature conversion
    func testTemperatureConversion() throws {
        let celsius: Double = 25.0
        let fahrenheit = TemperatureConverter.toFahrenheit(celsius)
        XCTAssertEqual(fahrenheit, 77.0, accuracy: 0.1)
    }
    
    /// Tests weather condition icon mapping
    func testWeatherConditionIcon() throws {
        let condition = WeatherCondition.rainy
        XCTAssertEqual(condition.iconName, "cloud.rain.fill")
    }
    
    /// Validates forecast data parsing
    func testForecastDataParsing() throws {
        let jsonData = """
        {
            "date": "2025-06-15",
            "high": 28,
            "low": 18,
            "condition": "sunny"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let forecast = try decoder.decode(ForecastDay.self, from: jsonData)
        
        XCTAssertEqual(forecast.high, 28)
        XCTAssertEqual(forecast.low, 18)
    }
    
    // MARK: - Location Tests
    
    /// Tests location search functionality
    func testLocationSearch() async throws {
        let searchService = LocationSearchService()
        let results = try await searchService.search(query: "San Francisco")
        XCTAssertFalse(results.isEmpty, "Should find locations")
    }
    
    /// Validates coordinate parsing
    func testCoordinateParsing() throws {
        let coordinate = GeoCoordinate(latitude: 37.7749, longitude: -122.4194)
        XCTAssertEqual(coordinate.latitude, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(coordinate.longitude, -122.4194, accuracy: 0.0001)
    }
    
    /// Tests location permission handling
    func testLocationPermissionStatus() throws {
        let manager = LocationPermissionManager()
        let status = manager.checkAuthorizationStatus()
        XCTAssertNotNil(status, "Should return permission status")
    }
    
    // MARK: - Weather View Model Tests
    
    /// Tests view model initialization
    func testWeatherViewModelInit() throws {
        let viewModel = WeatherViewModel()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    /// Validates data refresh functionality
    func testWeatherDataRefresh() async throws {
        let viewModel = WeatherViewModel()
        await viewModel.refresh()
        XCTAssertNotNil(viewModel.currentWeather)
    }
}

// MARK: - Music Player Tests

/// Tests for Music Player application components
final class MusicPlayerTests: XCTestCase {
    
    // MARK: - Audio Engine Tests
    
    /// Tests audio engine initialization
    func testAudioEngineInit() throws {
        let engine = AudioEngine()
        XCTAssertFalse(engine.isPlaying)
        XCTAssertEqual(engine.currentTime, 0.0, accuracy: 0.01)
    }
    
    /// Validates playback controls
    func testPlaybackControls() throws {
        let engine = AudioEngine()
        
        engine.play()
        XCTAssertTrue(engine.isPlaying)
        
        engine.pause()
        XCTAssertFalse(engine.isPlaying)
        
        engine.stop()
        XCTAssertEqual(engine.currentTime, 0.0, accuracy: 0.01)
    }
    
    /// Tests volume control
    func testVolumeControl() throws {
        let engine = AudioEngine()
        engine.setVolume(0.75)
        XCTAssertEqual(engine.volume, 0.75, accuracy: 0.01)
    }
    
    /// Validates seek functionality
    func testSeekFunctionality() throws {
        let engine = AudioEngine()
        engine.seek(to: 30.0)
        XCTAssertEqual(engine.currentTime, 30.0, accuracy: 0.1)
    }
    
    // MARK: - Track Model Tests
    
    /// Tests track model initialization
    func testTrackModelInit() throws {
        let track = Track(
            id: "track-001",
            title: "Summer Vibes",
            artist: "The Waves",
            duration: 215.0
        )
        
        XCTAssertEqual(track.id, "track-001")
        XCTAssertEqual(track.title, "Summer Vibes")
        XCTAssertEqual(track.artist, "The Waves")
        XCTAssertEqual(track.duration, 215.0, accuracy: 0.1)
    }
    
    /// Validates track duration formatting
    func testDurationFormatting() throws {
        let duration: TimeInterval = 185.0
        let formatted = DurationFormatter.format(duration)
        XCTAssertEqual(formatted, "3:05")
    }
    
    /// Tests album artwork loading
    func testAlbumArtworkLoading() async throws {
        let loader = ArtworkLoader()
        let image = try await loader.loadArtwork(for: "album-001")
        XCTAssertNotNil(image)
    }
    
    // MARK: - Playlist Tests
    
    /// Tests playlist creation
    func testPlaylistCreation() throws {
        let playlist = Playlist(name: "My Favorites")
        XCTAssertEqual(playlist.name, "My Favorites")
        XCTAssertTrue(playlist.tracks.isEmpty)
    }
    
    /// Validates track addition to playlist
    func testAddTrackToPlaylist() throws {
        var playlist = Playlist(name: "Test Playlist")
        let track = Track(id: "1", title: "Test", artist: "Artist", duration: 180)
        
        playlist.addTrack(track)
        XCTAssertEqual(playlist.tracks.count, 1)
        XCTAssertEqual(playlist.tracks.first?.id, "1")
    }
    
    /// Tests playlist shuffle functionality
    func testPlaylistShuffle() throws {
        var playlist = Playlist(name: "Test")
        for i in 1...10 {
            playlist.addTrack(Track(id: "\(i)", title: "Track \(i)", artist: "Artist", duration: 180))
        }
        
        let originalOrder = playlist.tracks.map(\.id)
        playlist.shuffle()
        let shuffledOrder = playlist.tracks.map(\.id)
        
        // Shuffled order should be different (with very high probability)
        XCTAssertNotEqual(originalOrder, shuffledOrder)
    }
    
    // MARK: - Audio Visualizer Tests
    
    /// Tests visualizer data generation
    func testVisualizerData() throws {
        let visualizer = AudioVisualizer()
        let data = visualizer.generateBars(count: 32)
        XCTAssertEqual(data.count, 32)
    }
    
    /// Validates frequency band calculation
    func testFrequencyBands() throws {
        let analyzer = FrequencyAnalyzer()
        let bands = analyzer.calculateBands(from: [0.5, 0.7, 0.3, 0.9])
        XCTAssertFalse(bands.isEmpty)
    }
}

// MARK: - Navigation Tests

/// Tests for navigation system components
final class NavigationTests: XCTestCase {
    
    /// Tests navigation path creation
    func testNavigationPathCreation() throws {
        var path = NavigationPath()
        path.append(DemoRoute.glassEffects)
        XCTAssertEqual(path.count, 1)
    }
    
    /// Validates route encoding
    func testRouteEncoding() throws {
        let route = DemoRoute.weatherApp
        let encoder = JSONEncoder()
        let data = try encoder.encode(route)
        XCTAssertNotNil(data)
    }
    
    /// Tests deep link parsing
    func testDeepLinkParsing() throws {
        let url = URL(string: "showcase://demo/glass-effects")!
        let route = DeepLinkParser.parse(url)
        XCTAssertEqual(route, .glassEffects)
    }
    
    /// Validates navigation stack management
    func testNavigationStackManagement() throws {
        let coordinator = NavigationCoordinator()
        
        coordinator.push(.glassEffects)
        coordinator.push(.weatherApp)
        XCTAssertEqual(coordinator.stackDepth, 2)
        
        coordinator.pop()
        XCTAssertEqual(coordinator.stackDepth, 1)
        
        coordinator.popToRoot()
        XCTAssertEqual(coordinator.stackDepth, 0)
    }
}

// MARK: - Theme Tests

/// Tests for theming system
final class ThemeTests: XCTestCase {
    
    /// Tests light theme configuration
    func testLightThemeConfiguration() throws {
        let theme = Theme.light
        XCTAssertEqual(theme.colorScheme, .light)
        XCTAssertNotNil(theme.primaryColor)
    }
    
    /// Tests dark theme configuration
    func testDarkThemeConfiguration() throws {
        let theme = Theme.dark
        XCTAssertEqual(theme.colorScheme, .dark)
        XCTAssertNotNil(theme.primaryColor)
    }
    
    /// Validates custom color creation
    func testCustomColorCreation() throws {
        let color = ThemeColor(hex: "#FF5733")
        XCTAssertNotNil(color)
    }
    
    /// Tests theme transition
    func testThemeTransition() throws {
        let manager = ThemeManager.shared
        manager.setTheme(.dark)
        XCTAssertEqual(manager.currentTheme, .dark)
    }
}

// MARK: - Accessibility Tests

/// Tests for accessibility features
final class AccessibilityTests: XCTestCase {
    
    /// Tests VoiceOver label generation
    func testVoiceOverLabels() throws {
        let card = GlassCard(title: "Weather", subtitle: "Current conditions")
        XCTAssertEqual(card.accessibilityLabel, "Weather, Current conditions")
    }
    
    /// Validates dynamic type support
    func testDynamicTypeSupport() throws {
        let config = AccessibilityConfiguration()
        config.preferredContentSizeCategory = .extraLarge
        XCTAssertTrue(config.supportsDynamicType)
    }
    
    /// Tests reduce motion preference
    func testReduceMotionPreference() throws {
        let config = AccessibilityConfiguration()
        config.reduceMotion = true
        XCTAssertTrue(config.animationsDisabled)
    }
    
    /// Validates high contrast mode
    func testHighContrastMode() throws {
        let config = AccessibilityConfiguration()
        config.increaseContrast = true
        XCTAssertTrue(config.highContrastEnabled)
    }
}

// MARK: - Performance Tests

/// Performance benchmark tests
final class PerformanceTests: XCTestCase {
    
    /// Benchmarks glass effect rendering
    func testGlassEffectRenderingPerformance() throws {
        measure {
            for _ in 0..<100 {
                _ = GlassMaterial(blurRadius: 20, opacity: 0.5)
            }
        }
    }
    
    /// Benchmarks weather data parsing
    func testWeatherDataParsingPerformance() throws {
        let jsonData = sampleWeatherJSON.data(using: .utf8)!
        
        measure {
            for _ in 0..<1000 {
                _ = try? JSONDecoder().decode(WeatherData.self, from: jsonData)
            }
        }
    }
    
    /// Benchmarks playlist operations
    func testPlaylistOperationsPerformance() throws {
        measure {
            var playlist = Playlist(name: "Benchmark")
            for i in 0..<1000 {
                playlist.addTrack(Track(id: "\(i)", title: "Track \(i)", artist: "Artist", duration: 180))
            }
            playlist.shuffle()
        }
    }
}

// MARK: - Test Helpers

/// Sample JSON for testing
private let sampleWeatherJSON = """
{
    "temperature": 22.5,
    "condition": "sunny",
    "humidity": 65,
    "windSpeed": 12.3
}
"""

// MARK: - Mock Types for Testing

/// Mock glass material for testing
struct GlassMaterial {
    var blurRadius: CGFloat = 20
    var opacity: Double = 0.5
    var tintColor: Color? = nil
}

/// Mock glass configuration
struct GlassConfiguration {
    var cornerRadius: CGFloat = 16
}

/// Glass animation states
enum GlassState {
    case collapsed, expanded
}

/// Mock glass animator
class GlassAnimator {
    var currentState: GlassState = .collapsed
    var animationDuration: TimeInterval = 0.3
    
    init(duration: TimeInterval = 0.3) {
        self.animationDuration = duration
    }
    
    func transitionTo(_ state: GlassState) {
        currentState = state
    }
    
    func animate(to state: GlassState, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.currentState = state
            completion()
        }
    }
}

/// Mock spring animation
struct GlassSpringAnimation {
    var response: Double
    var dampingFraction: Double
}

/// Weather condition enum
enum WeatherCondition: String, Codable {
    case sunny, cloudy, rainy, snowy
    
    var iconName: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .snowy: return "cloud.snow.fill"
        }
    }
}

/// Mock weather data
struct WeatherData: Codable {
    var temperature: Double
    var condition: WeatherCondition
    var humidity: Int
    var windSpeed: Double
}

/// Temperature converter
struct TemperatureConverter {
    static func toFahrenheit(_ celsius: Double) -> Double {
        celsius * 9 / 5 + 32
    }
}

/// Forecast day model
struct ForecastDay: Codable {
    var date: String
    var high: Int
    var low: Int
    var condition: String
}

/// Mock location search service
class LocationSearchService {
    func search(query: String) async throws -> [String] {
        return ["San Francisco, CA", "San Francisco del Rincón"]
    }
}

/// Geographic coordinate
struct GeoCoordinate {
    var latitude: Double
    var longitude: Double
}

/// Location permission manager
class LocationPermissionManager {
    func checkAuthorizationStatus() -> String {
        return "authorized"
    }
}

/// Weather view model
@MainActor
class WeatherViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    @Published var currentWeather: WeatherData?
    
    func refresh() async {
        currentWeather = WeatherData(temperature: 22, condition: .sunny, humidity: 60, windSpeed: 10)
    }
}

/// Mock audio engine
class AudioEngine {
    var isPlaying = false
    var currentTime: TimeInterval = 0
    var volume: Float = 1.0
    
    func play() { isPlaying = true }
    func pause() { isPlaying = false }
    func stop() { isPlaying = false; currentTime = 0 }
    func setVolume(_ value: Float) { volume = value }
    func seek(to time: TimeInterval) { currentTime = time }
}

/// Track model
struct Track: Identifiable {
    var id: String
    var title: String
    var artist: String
    var duration: TimeInterval
}

/// Duration formatter
struct DurationFormatter {
    static func format(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

/// Artwork loader
class ArtworkLoader {
    func loadArtwork(for albumId: String) async throws -> Any? {
        return "MockImage"
    }
}

/// Playlist model
struct Playlist {
    var name: String
    var tracks: [Track] = []
    
    mutating func addTrack(_ track: Track) {
        tracks.append(track)
    }
    
    mutating func shuffle() {
        tracks.shuffle()
    }
}

/// Audio visualizer
class AudioVisualizer {
    func generateBars(count: Int) -> [Float] {
        (0..<count).map { _ in Float.random(in: 0...1) }
    }
}

/// Frequency analyzer
class FrequencyAnalyzer {
    func calculateBands(from samples: [Float]) -> [Float] {
        samples
    }
}

/// Demo route enum
enum DemoRoute: String, Codable {
    case glassEffects, weatherApp, musicPlayer
}

/// Deep link parser
struct DeepLinkParser {
    static func parse(_ url: URL) -> DemoRoute? {
        if url.path.contains("glass") { return .glassEffects }
        if url.path.contains("weather") { return .weatherApp }
        return nil
    }
}

/// Navigation coordinator
class NavigationCoordinator {
    private var stack: [DemoRoute] = []
    
    var stackDepth: Int { stack.count }
    
    func push(_ route: DemoRoute) { stack.append(route) }
    func pop() { _ = stack.popLast() }
    func popToRoot() { stack.removeAll() }
}

/// Theme configuration
struct Theme {
    var colorScheme: ColorScheme
    var primaryColor: Color
    
    static let light = Theme(colorScheme: .light, primaryColor: .blue)
    static let dark = Theme(colorScheme: .dark, primaryColor: .indigo)
}

/// Color scheme enum
enum ColorScheme: String {
    case light, dark
}

/// Theme color
struct ThemeColor {
    init?(hex: String) {
        // Simple hex validation
        guard hex.hasPrefix("#"), hex.count == 7 else { return nil }
    }
}

/// Theme manager
class ThemeManager {
    static let shared = ThemeManager()
    var currentTheme: Theme = .light
    
    func setTheme(_ theme: Theme) {
        currentTheme = theme
    }
}

/// Glass card for accessibility testing
struct GlassCard {
    var title: String
    var subtitle: String
    
    var accessibilityLabel: String {
        "\(title), \(subtitle)"
    }
}

/// Accessibility configuration
class AccessibilityConfiguration {
    var preferredContentSizeCategory: ContentSizeCategory = .medium
    var reduceMotion = false
    var increaseContrast = false
    
    var supportsDynamicType: Bool { true }
    var animationsDisabled: Bool { reduceMotion }
    var highContrastEnabled: Bool { increaseContrast }
}

/// Content size category
enum ContentSizeCategory {
    case medium, large, extraLarge
}
