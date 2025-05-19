//
//  DailyWeatherCell.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

class DailyWeatherCell: UITableViewCell {
    private let dateLabel = UILabel()
    private let highLowLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        highLowLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        highLowLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        contentView.addSubview(highLowLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            highLowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            highLowLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }

    func configure(with day: ForecastDay) {
        dateLabel.text = day.date
        highLowLabel.text = "High: \(day.day.maxtemp_c)° / Low: \(day.day.mintemp_c)°"
    }
}
