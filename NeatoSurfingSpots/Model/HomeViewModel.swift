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
}
enum HomeViewModelSection {
    case main
}

class HomeViewModel: HomeViewModelProtocol {

    private let service: Network!
    let title: String = "Surfing Spots"
    
    private var tempTimer : Timer?

    init(service: Network = NetworkClient()) {
        self.service = service
    }

    /// the value is immutable, so you can only subscribe to changes.
    var isfetching: Observable<Bool> {
        isfetchingVariable.asObservable()
    }
    /// the value is mutable, so only this class can modify it.
    private let isfetchingVariable = Variable<Bool>(false)

//    var citiesChangeSnapshot: Observable<HomeCitiesSnapshot?> {
//        return citiesChangeSnapshotVariable.asObservable()
//    }
//    private let citiesChangeSnapshotVariable = Variable<HomeCitiesSnapshot?>(nil)

    var cities: Observable<[CityViewModel]> {
        return citiesVariable.asObservable()
    }
    private let citiesVariable = Variable<[CityViewModel]>([])
    
    func startUpdatingTemperatures(){
        
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
                    // .sorted(by: { $0.temperature > $1.temperature }
                        .compactMap { CityViewModel($0) }
                    self.citiesVariable.onNext(value: viewmodels)
                case .failure:
                    self.citiesVariable.onNext(value: [])
                }
                self.isfetchingVariable.onNext(value: false)
            }
        }
    }
}
