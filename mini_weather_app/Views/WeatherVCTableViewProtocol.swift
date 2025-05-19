//
//  WeatherVCTableViewProtocol.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-19.
//

import UIKit

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherResponse == nil ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let response = weatherResponse else { return 0 }
        switch section {
        case 0: return 1
        case 1:
            let todayHours = response.forecast.forecastday.first?.hour.filter {
                DateFormatter.apiDateFormatter.date(from: $0.time)! > Date()
            } ?? []
            let nextDay = response.forecast.forecastday[safe: 1]?.hour ?? []
            return todayHours.count + nextDay.count
        case 2: return response.forecast.forecastday.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resp = weatherResponse else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCell", for: indexPath) as! CurrentWeatherCell
            cell.configure(with: resp.current, locationName: resp.location.name, apiClient: apiClient)
            return cell
        case 1:
            let today = resp.forecast.forecastday.first?.hour.filter {
                DateFormatter.apiDateFormatter.date(from: $0.time)! > Date()
            } ?? []
            let allHours = today + (resp.forecast.forecastday[safe: 1]?.hour ?? [])
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyCell", for: indexPath) as! HourlyWeatherCell
            cell.configure(with: allHours[indexPath.row])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyWeatherCell
            cell.configure(with: resp.forecast.forecastday[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Hourly forecast"
        case 2: return "Weekly forecast"
        default: return nil
        }
    }
}
