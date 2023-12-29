import Foundation

struct WeatherCondition: Codable {
    let main: String
    let description: String
}
struct WeatherData: Codable {
    let temp: Double
    let humidity: Double
}
struct WeatherResponse: Codable {
    let weather: [WeatherCondition]
    let main: WeatherData
}
class WeatherFetchService {
    let apiKey: String
    let baseUrl: String
    init(apiKey: String) {
        self.apiKey = apiKey
        self.baseUrl = "https://api.openweathermap.org/data/2.5"
    }

    func getThreeDayForecast(city: String, completion: @escaping ([DailyWeather]?, Error?) -> Void) {
        let forecastURL = "\(baseUrl)/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: forecastURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                let forecastsGroupedByDay = Dictionary(grouping: forecastResponse.list) { element in
                    return self.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(element.dt)))
                }
                var dailyForecasts: [DailyWeather] = []
                for (date, forecasts) in forecastsGroupedByDay {
                    if let forecastClosestToNoon = forecasts.min(by: { abs($0.dt - self.timeIntervalForNoon(for: date)) < abs($1.dt - self.timeIntervalForNoon(for: date)) }) {
                        dailyForecasts.append(DailyWeather(date: date, weatherData: [forecastClosestToNoon]))
                    }
                }
                let sortedDailyForecasts = dailyForecasts.sorted(by: { $0.date < $1.date })
                let threeDayForecasts = Array(sortedDailyForecasts.prefix(3))
                completion(threeDayForecasts, nil)
                
            } catch let decoderError {
                completion(nil, decoderError)
            }
        }
        task.resume()
    }
    private func startOfDay(for date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    private func timeIntervalForNoon(for date: Date) -> Int {
        let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date)!
        return Int(noon.timeIntervalSince1970)
    }
}

