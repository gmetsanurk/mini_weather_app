# mini_weather_app

An iOS application built in Swift that provides up-to-date weather forecasts.

## Features

- **MVP + Coordinator Pattern**: Manages app flow and navigation via `AppCoordinator`.
- **Location Detection**: Automatically fetches the device's current location with a fallback to Moscow coordinates.
- **Async/Await Networking**: Uses Swift concurrency (`async/await`) for clean and efficient API calls to WeatherAPI.
- **SOLID Principles**: Clear separation of concerns in networking, presentation, and UI layers.
- **Custom UI**: Displays current, hourly, and daily weather in customizable table views with custom cells (`CurrentWeatherCell`, `HourlyWeatherCell`, `DailyWeatherCell`).
