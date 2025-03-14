import UIKit

class WeatherViewController: UIViewController {
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let refreshButton = UIButton(type: .system)
    
    private let weatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

