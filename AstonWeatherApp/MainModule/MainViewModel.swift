//
//  MainViewModel.swift
//  AstonWeatherApp
//
//  Created by Гриша  on 27.12.2023.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation


class WeatherViewModel {
    let forecast: BehaviorSubject<[DailyWeather]> = BehaviorSubject(value: [])
    let error: PublishSubject<Error> = PublishSubject()
    
    private let weatherFetchService: WeatherFetchService
    private let disposeBag = DisposeBag()
    
    init(weatherFetchService: WeatherFetchService) {
        self.weatherFetchService = weatherFetchService
    }

    func fetchThreeDayForecast(for city: String) {
        weatherFetchService.getThreeDayForecast(city: city) { [weak self] (dailyWeather, error) in
            DispatchQueue.main.async {
                if let dailyWeather = dailyWeather {
                    self?.forecast.onNext(dailyWeather)
                } else if let error = error {
                    self?.error.onNext(error)
                }
            }
        }
    }
}

