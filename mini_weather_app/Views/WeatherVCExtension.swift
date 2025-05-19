//
//  WeatherVCExtension.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-19.
//

import UIKit

extension WeatherViewController {
    
    func setupViews() {
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
        retryButton.addAction(UIAction { _ in
            self.didTapRetry()
        }, for: .primaryActionTriggered)
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
    
    private func didTapRetry() {
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
