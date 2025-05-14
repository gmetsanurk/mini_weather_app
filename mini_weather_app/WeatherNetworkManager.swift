import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
}

class WeatherNetworkManager {
    static let shared = WeatherNetworkManager()
    private let apiKey = ApiKey.openWeatherKey
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    private init() {}
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        
        let urlString = "\(baseURL)?q=\(city)&APPID=\(apiKey)"
        request(urlString: urlString, completion: completion)
        print(urlString)
    }
    
    func fetchWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=ru"
        request(urlString: urlString, completion: completion)
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
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(NetworkError.decodingFailed))
            }
        }
        
        task.resume()
    }
}
