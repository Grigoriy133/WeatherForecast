//
//  ViewController.swift
//  AstonWeatherApp
//
//  Created by Гриша  on 27.12.2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CoreLocation

class MainViewController: UIViewController {
    
    var viewModel = WeatherViewModel(weatherFetchService: WeatherFetchService(apiKey: "e6e0ace140766b967298a10b37b838b8"))

    private var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let temperatureLabelRN = UILabel()
    private let descriptionLabelRN = UILabel()
    private let dateLabelRN = UILabel()
       
    private let temperatureLabelTomorrow = UILabel()
    private let descriptionLabelTomorrow = UILabel()
    private let dateLabelTomorrow = UILabel()
    
    private let temperatureLabelDayAfterTomorrow = UILabel()
    private let descriptionLabelDayAfterTomorrow = UILabel()
    private let dateLabelDayAfterTomorrow = UILabel()
    
    private let currentLocationButton = UIButton()
    private let anotherLocationButton = UIButton()
    
    var currentForecastObjectLabel = UILabel()
    let mainOffset = UIScreen.main.bounds.width / 20

  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        LocationService.shared.requestLocationAccess()
        setupViews()
        setupConstraints()
        bindViewModel()
    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        featchCurrentLocationForecast()
       }
    private func featchCurrentLocationForecast(){
        LocationService.shared.getCurrentCity { [weak self] city, error in
            if let city = city {
                self?.viewModel.fetchThreeDayForecast(for: city)
                self?.currentForecastObjectLabel.text = city
            } else if let error = error {
                print("\(error.localizedDescription)")
            }
        }
    }
    @objc func myLocation(){
        featchCurrentLocationForecast()
    }
    @objc func featchForecastFor() {
        let alert = UIAlertController(title: "Pick a city", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "City"
            }
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let cityName = alert.textFields?.first?.text else { return }
                self?.viewModel.fetchThreeDayForecast(for: cityName)
                self?.currentForecastObjectLabel.text = cityName
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
    }

    // MARK: - Setup UI
    private func setupViews() {
        configurateViews(label: temperatureLabelRN, font: CGFloat(24))
        configurateViews(label: descriptionLabelRN, font: CGFloat(20))
        configurateViews(label: dateLabelRN, font: CGFloat(18))
        configurateViews(label: temperatureLabelTomorrow, font: CGFloat(20))
        configurateViews(label: descriptionLabelTomorrow, font: CGFloat(14))
        configurateViews(label: dateLabelTomorrow, font: CGFloat(14))
        configurateViews(label: temperatureLabelDayAfterTomorrow, font: CGFloat(20))
        configurateViews(label: descriptionLabelDayAfterTomorrow, font: CGFloat(14))
        configurateViews(label: dateLabelDayAfterTomorrow, font: CGFloat(14))
        configurateViews(label: currentForecastObjectLabel, font: CGFloat(30))
        
        currentLocationButton.setTitle("My location Forecast", for: .normal)
        currentLocationButton.backgroundColor = .green
        currentLocationButton.addTarget(self, action: #selector(myLocation), for: .touchUpInside)
        
        anotherLocationButton.setTitle("Select another City", for: .normal)
        anotherLocationButton.backgroundColor = .gray
        anotherLocationButton.addTarget(self, action: #selector(featchForecastFor), for: .touchUpInside)
        
        view.addSubview(currentLocationButton)
        view.addSubview(anotherLocationButton)
    }
    
    func configurateViews(label: UILabel, font: CGFloat) {
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = .center
        label.textColor = .black
    }
    private func setupConstraints() {
        currentForecastObjectLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(mainOffset)
            $0.left.right.equalTo(view).inset(mainOffset)
            $0.height.equalTo(mainOffset * 1.5)
        }
        temperatureLabelRN.snp.makeConstraints {
            $0.top.equalTo(currentForecastObjectLabel.snp.bottom).offset(mainOffset * 1.5)
            $0.left.right.equalTo(view).inset(mainOffset)
            $0.height.equalTo(mainOffset * 1.5)
        }
        descriptionLabelRN.snp.makeConstraints {
            $0.top.equalTo(temperatureLabelRN.snp.bottom).offset(mainOffset)
            $0.left.right.equalTo(temperatureLabelRN)
            $0.height.equalTo(mainOffset * 1.5)
        }
        dateLabelRN.snp.makeConstraints {
            $0.top.equalTo(descriptionLabelRN.snp.bottom).offset(mainOffset)
            $0.left.right.equalTo(descriptionLabelRN)
            $0.height.equalTo(mainOffset * 1.5)
        }
        temperatureLabelTomorrow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateLabelRN).offset(mainOffset * 5)
            $0.height.equalTo(mainOffset * 1.5)
                }
        descriptionLabelTomorrow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(temperatureLabelTomorrow).offset(mainOffset)
            $0.height.equalTo(mainOffset * 1.5)
                }
        dateLabelTomorrow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabelTomorrow).offset(mainOffset)
            $0.height.equalTo(mainOffset * 1.5)
                }
        temperatureLabelDayAfterTomorrow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateLabelTomorrow).offset(mainOffset * 2.5)
            $0.height.equalTo(mainOffset * 1.5)
                }
        descriptionLabelDayAfterTomorrow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(temperatureLabelDayAfterTomorrow).offset(mainOffset)
            $0.height.equalTo(mainOffset * 1.5)
                }
        dateLabelDayAfterTomorrow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabelDayAfterTomorrow).offset(mainOffset)
            $0.height.equalTo(mainOffset * 1.5)
                }
        currentLocationButton.snp.makeConstraints{
            $0.left.bottom.equalToSuperview().inset(mainOffset)
            $0.height.equalTo(dateLabelTomorrow)
            $0.width.equalTo(dateLabelTomorrow.snp.width).dividedBy(2)
        }
        anotherLocationButton.snp.makeConstraints{
            $0.right.bottom.equalToSuperview().inset(mainOffset)
            $0.height.width.equalTo(currentLocationButton)
        }
}
    // MARK: - Binding
    private func bindViewModel() {
        viewModel.forecast
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dailyWeather in
                guard dailyWeather.count >= 3 else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, MMM d"
                let todayWeather = dailyWeather[0]
                self?.temperatureLabelRN.text = "Temperature: \(todayWeather.weatherData[0].main.temp)°C"
                self?.descriptionLabelRN.text = " \(todayWeather.weatherData[0].weather.first?.description ?? "")"
                let todayDateString = dateFormatter.string(from: todayWeather.date)
                self?.dateLabelRN.text = "Date: \(todayDateString)"
                // Завтра
                let tomorrowWeather = dailyWeather[1]
                self?.temperatureLabelTomorrow.text = "Temperature: \(tomorrowWeather.weatherData[0].main.temp)°C"
                self?.descriptionLabelTomorrow.text = " \(tomorrowWeather.weatherData[0].weather.first?.description ?? "")"
                let tomorrowDateString = dateFormatter.string(from: tomorrowWeather.date)
                self?.dateLabelTomorrow.text = "Date: \(tomorrowDateString)"
                
                // Послезавтра
                let dayAfterTomorrowWeather = dailyWeather[2]
                self?.temperatureLabelDayAfterTomorrow.text = "Temperature: \(dayAfterTomorrowWeather.weatherData[0].main.temp)°C"
                self?.descriptionLabelDayAfterTomorrow.text = " \(dayAfterTomorrowWeather.weatherData[0].weather.first?.description ?? "")"
                let dayAfterTomorrowDateString = dateFormatter.string(from: dayAfterTomorrowWeather.date)
                self?.dateLabelDayAfterTomorrow.text = "Date: \(dayAfterTomorrowDateString)"
            })
            .disposed(by: disposeBag)
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                print("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}


