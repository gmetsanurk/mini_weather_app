//
//  WeatherViewController.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit

class WeatherViewController: UIViewController, WeatherViewProtocol {
    let presenter: WeatherPresenter
    let apiClient: WeatherAPIClientProtocol
    let activity = UIActivityIndicatorView(style: .large)
    let errorLabel = UILabel()
    let retryButton = UIButton(type: .system)
    let tableView = UITableView()
    var weatherResponse: WeatherResponse?
    
    init(presenter: WeatherPresenter, apiClient: WeatherAPIClientProtocol) {
        self.presenter = presenter
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        presenter.viewDidLoad()
    }
}
