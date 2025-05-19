import Foundation

class WeatherViewModel {
    var weatherData: ((WeatherData) -> Void)?
    var errorMessage: ((String) -> Void)?
    
    func fetchWeather(for city: String) {
        WeatherNetworkManager.shared.fetchWeather(for: city) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.weatherData?(data)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage?(error.localizedDescription)
                }
            }
        }
    }
}

