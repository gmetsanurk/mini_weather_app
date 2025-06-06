//
//  DailyWeatherCell.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

final class DailyWeatherCell: UITableViewCell {
    private let dateLabel = UILabel()
    private let highLowLabel = UILabel()
    
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
        dateLabel.font = UIFont.systemFont(ofSize: AppGeometry.fontSize)
        highLowLabel.font = UIFont.systemFont(ofSize: AppGeometry.fontSize)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        highLowLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addLabelSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(highLowLabel)
    }

    private func activateLabelConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppGeometry.padding),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            highLowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppGeometry.padding),
            highLowLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }
    
    func configure(with day: ForecastDay) {
        dateLabel.text = day.date ?? "—"
        let highValue = day.day.maxtemp_c != nil ? "\(day.day.maxtemp_c!)" : "—"
        let lowValue  = day.day.mintemp_c != nil ? "\(day.day.mintemp_c!)"  : "—"
        
        highLowLabel.text = "High: \(highValue)° / Low: \(lowValue)°"
    }
}
