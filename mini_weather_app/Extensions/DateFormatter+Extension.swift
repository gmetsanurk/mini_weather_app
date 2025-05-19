//
//  DateFormatter+Extension.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import Foundation

extension DateFormatter {
    static let apiDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
}
