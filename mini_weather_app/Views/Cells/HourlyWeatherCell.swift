//
//  HourlyWeatherCell.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

final class HourlyWeatherCell: UITableViewCell {
    private let timeLabel = UILabel()
    private let tempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        configureLabels()
        addLabelSubviews()
        activateLabelConstraints()
    }

    private func configureLabels() {
        timeLabel.font = UIFont.systemFont(ofSize: AppGeometry.fontSize)
        tempLabel.font = UIFont.systemFont(ofSize: AppGeometry.fontSize)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addLabelSubviews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(tempLabel)
    }

    private func activateLabelConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppGeometry.padding),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppGeometry.padding),
            tempLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor)
        ])
    }
    
    func configure(with hour: HourlyWeather) {
        if let time = hour.time {
            timeLabel.text = String(time.suffix(5))
        } else {
            timeLabel.text = "--:--"
        }
        
        if let temp = hour.temp_c {
            tempLabel.text = "\(temp)°C"
        } else {
            tempLabel.text = "--°C"
        }
    }
}
