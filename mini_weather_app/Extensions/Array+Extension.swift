//
//  Array+Extension.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
