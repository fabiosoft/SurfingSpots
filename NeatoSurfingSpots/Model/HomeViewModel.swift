//
//  HomeViewModel.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import UIKit
import FNEasyBind

protocol HomeViewModelProtocol {
    var title: String { get }
    var isfetching: Observable<Bool> { get }
    var cities: Observable<[CityViewModel]> { get }
    func fetchCities()
    func startUpdatingTemperatures()
}
enum HomeViewModelSection {
    case main
}

class HomeViewModel: HomeViewModelProtocol {

    private let service: Network!
    let title: String = NSLocalizedString("Surfing Spots", comment: "")

    private var tempTimer: Timer?

    init(service: Network = NetworkClient()) {
        self.service = service
    }

    /// the value is immutable, so you can only subscribe to changes.
    var isfetching: Observable<Bool> {
        isfetchingVariable.asObservable()
    }
    /// the value is mutable, so only this class can modify it.
    private let isfetchingVariable = Variable<Bool>(false)

    var cities: Observable<[CityViewModel]> {
        return citiesVariable.asObservable()
    }
    private let citiesVariable = Variable<[CityViewModel]>([])

    func startUpdatingTemperatures() {
        self.tempTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in

            self.service.randomNumber { result in
                switch result {

                case .success(let number):
                    let randomCity = self.citiesVariable.value.randomElement()
                    randomCity?.temperature.onNext(value: number)
                    let sortedCities = self.citiesVariable.value.sorted(by: { self.sortPredicate($0.temperature.value, $1.temperature.value) })
                    self.citiesVariable.onNext(value: sortedCities)
                case .failure:
                    break
                }
            }
        })
    }

    private func sortPredicate<Element: Comparable>(_ elem1: Element?, _ elem2: Element?) -> Bool {
        guard let temperature1 = elem1,
              let temperature2 = elem2
        else {
            return false
        }
        return temperature1 > temperature2 // descending
    }

    func fetchCities() {
        if isfetchingVariable.value {
            return
        }
        isfetchingVariable.onNext(value: true)
        service.cities { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                switch result {

                case .success(let cities):
                    let viewmodels = cities
                        .compactMap { CityViewModel($0) }
                        .sorted(by: { self.sortPredicate($0.temperature.value, $1.temperature.value) })
                    self.citiesVariable.onNext(value: viewmodels)
                case .failure:
                    self.citiesVariable.onNext(value: [])
                }
                self.isfetchingVariable.onNext(value: false)
            }
        }
    }
}
