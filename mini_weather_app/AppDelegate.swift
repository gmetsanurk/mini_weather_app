import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let locationService = LocationService()
        let apiClient = WeatherAPIClient()
        let presenter = WeatherPresenter(apiClient: apiClient, locationService: locationService)
        let rootVC = WeatherViewController(presenter: presenter)
        presenter.view = rootVC

        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
        return true
    }
}


