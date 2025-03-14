import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
}

class WeatherNetworkManager {
    static let shared = WeatherNetworkManager()
    private let apiKey = "a2b4f69ada2c898ba84feba0043fc80a"
    private let baseUrl = "api.openweathermap.org"
    
    private init() {}
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric&lanr=ru"
        //request(urlString: urlString)
    }
    
    func request<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            
        }
    }
}
