//
//  CurrentWeatherCell.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let locationLabel = UILabel()
    private let tempLabel = UILabel()
    private let conditionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setup() {
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 25
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        locationLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        tempLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        conditionLabel.font = UIFont.systemFont(ofSize: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(conditionLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),

            locationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            tempLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            tempLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),

            conditionLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            conditionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 8),
            conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with current: CurrentWeather, locationName: String, apiClient: WeatherAPIClientProtocol) {
        guard let temp = current.temp_c, let icon = current.condition.icon else { return }
        iconImageView.image = nil
        locationLabel.text = locationName
        tempLabel.text = "\(Int(temp))°C"
        conditionLabel.text = current.condition.text
        apiClient.fetchIcon(path: icon) { [weak self] image in
            self?.iconImageView.image = image
        }
    }
}
