import Foundation

class WeatherNetworkManager {
    static let shared = WeatherNetworkManager()
    private let apiKey = "a2b4f69ada2c898ba84feba0043fc80a"
    private let baseUrl = "api.openweathermap.org"
    
    private init() {}
}
