//
//  WeatherVCTableViewProtocol.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-19.
//

import UIKit

extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.titleForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = presenter.item(at: indexPath) else {
            return UITableViewCell()
        }
        switch item {
        case .current(let current, let locationName):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCell", for: indexPath) as? CurrentWeatherCell ?? CurrentWeatherCell()
            cell.configure(with: current, locationName: locationName, apiClient: apiClient)
            return cell

        case .hourly(let hour):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyCell", for: indexPath) as? HourlyWeatherCell ?? HourlyWeatherCell()
            cell.configure(with: hour)
            return cell

        case .daily(let day):
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyWeatherCell ?? DailyWeatherCell()
            cell.configure(with: day)
            return cell
        }
    }
}

private extension UITableViewCell {
    static var reuseIdentifier: String { String(describing: self) }
}
