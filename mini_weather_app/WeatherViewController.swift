import UIKit

class WeatherViewController: UIViewController {
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let refreshButton = UIButton(type: .system)
    
    private let weatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //setupBindings()
        weatherViewModel.fetchWeather(for: "Moscow")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        cityLabel.font = .boldSystemFont(ofSize: 24)
        cityLabel.textAlignment = .center
        
        tempLabel.font = .systemFont(ofSize: 40, weight: .bold)
        tempLabel.textAlignment = .center
        
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.image = UIImage(systemName: "cloud.sun.fill")
        
        refreshButton.setTitle("Update", for: .normal)
        refreshButton.addAction(UIAction {[weak self] _ in
            self?.refreshWeather()
        }, for: .touchUpInside)
        
        view.addSubview(cityLabel)
        view.addSubview(tempLabel)
        view.addSubview(weatherIcon)
        view.addSubview(refreshButton)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherIcon.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 20),
            weatherIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100),
            weatherIcon.heightAnchor.constraint(equalToConstant: 100),
            
            refreshButton.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 20),
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupBindings() {
        weatherViewModel.weatherData = { [weak self] weather in
            self?.updateUI(with: weather)
        }
        
        weatherViewModel.errorMessage = { [weak self] message in
            self?.showError(message)
        }
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

