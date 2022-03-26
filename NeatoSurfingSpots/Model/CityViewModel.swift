//
//  CityViewModel.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 26/03/22.
//

import Foundation
import UIKit
import FNEasyBind

protocol CityViewModelProtocol {
    var displayName: String? {get}
    var temperature: Observable<Int> {get}
    var skylineImage: UIImage? {get}
    func skyline() -> UIImage?
    var isSunny: Bool {get}
    func weatherConditions() -> String
}

class CityViewModel: CityViewModelProtocol {
    private(set) var city: City
    private var network: Network

    var displayName: String? {
        return city.name
    }

    var skylineImage: UIImage?
    func skyline() -> UIImage? {
        if isSunny {
            return skylineImage
        }
        return nil
    }

    var isSunny: Bool {
        guard let temperature = self.temperature.value else {
            return false
        }
        return temperature > 30
    }

    var temperature: Observable<Int> {
        return temperatureVariable.asObservable()
    }
    private let temperatureVariable = Variable<Int>(Int.random(in: 0..<100))

    func weatherConditions() -> String {
        "\(isSunny ? NSLocalizedString("Sunny", comment: "") : NSLocalizedString("Cloudy", comment: "")) - \(self.temperature.value ?? 0) degree"
    }

    init(_ city: City, network: Network = NetworkClient()) {
        self.city = city
        self.network = network
        self.skylineImage = UIImage(named: "\(Int.random(in: 1..<7))") // 1-6
    }

}

 extension CityViewModel: Hashable {
     func hash(into hasher: inout Hasher) {
         hasher.combine(city.name)
     }

     static func == (lhs: CityViewModel, rhs: CityViewModel) -> Bool {
         lhs.city.name == rhs.city.name
     }
 }

 extension CityViewModel: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "\(self.displayName ?? "nowhere") \(self.temperature.value ?? 0) degree"
    }

    var debugDescription: String {
        return self.description
    }
 }
