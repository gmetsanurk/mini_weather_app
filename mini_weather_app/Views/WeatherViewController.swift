//
//  WeatherViewController.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

class WeatherViewController: UIViewController, WeatherViewProtocol {
    private let presenter: WeatherPresenterProtocol

    private let activity = UIActivityIndicatorView(style: .large)
    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private let tableView = UITableView()

    private var weatherResponse: WeatherResponse?

    init(presenter: WeatherPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        presenter.viewDidLoad()
    }

    private func setupViews() {
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        view.addSubview(errorLabel)

        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.isHidden = true
        view.addSubview(retryButton)

        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: "CurrentCell")
        tableView.register(HourlyWeatherCell.self, forCellReuseIdentifier: "HourlyCell")
        tableView.register(DailyWeatherCell.self, forCellReuseIdentifier: "DailyCell")
        tableView.isHidden = true
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func didTapRetry() {
        errorLabel.isHidden = true
        retryButton.isHidden = true
        tableView.isHidden = true
        presenter.retry()
    }

    func showLoading() {
        activity.startAnimating()
        tableView.isHidden = true
    }

    func hideLoading() {
        activity.stopAnimating()
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        retryButton.isHidden = false
        tableView.isHidden = true
    }

    func showWeather(_ response: WeatherResponse) {
        self.weatherResponse = response
        tableView.reloadData()
        tableView.alpha = 0
        tableView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.activity.stopAnimating()
            self.tableView.alpha = 1
        }
    }
}

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
        guard let response = weatherResponse else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCell", for: indexPath) as! CurrentWeatherCell
            cell.configure(with: response.current)
            return cell
        case 1:
            let todayHours = response.forecast.forecastday.first?.hour.filter {
                DateFormatter.apiDateFormatter.date(from: $0.time)! > Date()
            } ?? []
            let allHours = todayHours + (response.forecast.forecastday[safe: 1]?.hour ?? [])
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyCell", for: indexPath) as! HourlyWeatherCell
            cell.configure(with: allHours[indexPath.row])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyWeatherCell
            cell.configure(with: response.forecast.forecastday[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}
