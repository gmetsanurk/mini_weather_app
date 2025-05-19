//
//  LoadingViewController.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-19.
//
import UIKit

final class LoadingViewController: UIViewController {
    private let activity = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupActivityIndicator()
    }

    private func setupActivityIndicator() {
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activity.startAnimating()
    }
}
