//
//  Cells.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    private let tempLabel = UILabel()
    private let conditionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        tempLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        conditionLabel.font = UIFont.systemFont(ofSize: 16)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tempLabel)
        contentView.addSubview(conditionLabel)
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            conditionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 8),
            conditionLabel.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor),
            conditionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with current: CurrentWeather) {
        tempLabel.text = "\(current.temp_c)°C"
        conditionLabel.text = current.condition.text
    }
}
