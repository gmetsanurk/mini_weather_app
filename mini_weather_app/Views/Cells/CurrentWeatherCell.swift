//
//  CurrentWeatherCell.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    private let locationLabel = UILabel()
    private let tempLabel = UILabel()
    private let conditionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        locationLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        tempLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        conditionLabel.font = UIFont.systemFont(ofSize: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(conditionLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            locationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 8),
            conditionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with current: CurrentWeather, locationName: String) {
        locationLabel.text = locationName
        tempLabel.text = "\(Int(current.temp_c))°C"
        conditionLabel.text = current.condition.text
    }
}
