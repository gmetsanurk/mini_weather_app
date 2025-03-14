import UIKit

class WeatherViewController: UIViewController {
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let refreshButton = UIButton(type: .system)
    
    private let weatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherViewModel.fetchWeather(for: "Moscow")
    }
    
    
    
    private func refreshWeather() {
        weatherViewModel.fetchWeather(for: "Moscow")
    }
    
    private func updateUI(with weather: WeatherData) {
        cityLabel.text = weather.name
        tempLabel.text = "\(Int(weather.main.temp))°C"
        
        let weatherType = weather.weather.first?.description ?? "clear"
        weatherIcon.image = UIImage(systemName: getWeatherIcon(for: weatherType))
    }
    
    private func getWeatherIcon(for description: String) -> String {
        if description.contains("rain") {
            return "cloud.rain.fill"
        } else if description.contains("clear") {
            return "sun.max.fill"
        } else {
            return "cloud.fill"
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

