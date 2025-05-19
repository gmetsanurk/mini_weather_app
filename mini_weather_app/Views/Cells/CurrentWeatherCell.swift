//
//  CurrentWeatherCell.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

final class CurrentWeatherCell: UITableViewCell {
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
        configureIconImageView()
        configureLabels()
        addSubviews()
        activateConstraints()
    }

    private func configureIconImageView() {
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = AppGeometry.iconSize.width / 2
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureLabels() {
        locationLabel.font = .systemFont(ofSize: 18, weight: .medium)
        tempLabel.font = .systemFont(ofSize: 32, weight: .bold)
        conditionLabel.font = .systemFont(ofSize: AppGeometry.fontSize)
        [locationLabel, tempLabel, conditionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func addSubviews() {
        [iconImageView, locationLabel, tempLabel, conditionLabel]
            .forEach { contentView.addSubview($0) }
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppGeometry.padding),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppGeometry.padding),
            iconImageView.widthAnchor.constraint(equalToConstant: AppGeometry.iconSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: AppGeometry.iconSize.height),

            // Location label
            locationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: AppGeometry.padding),
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppGeometry.padding),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppGeometry.padding),

            // Temp label
            tempLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            tempLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: AppGeometry.interItemSpacing),

            // Condition label
            conditionLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            conditionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: AppGeometry.interItemSpacing),
            conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppGeometry.padding)
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
