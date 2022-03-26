//
//  CityViewModel.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 26/03/22.
//

import Foundation

protocol CityViewModelProtocol {
    var displayName: String? {get}
    var temperature: Int {get set}
    var isSunny: Bool {get}
}

class CityViewModel: CityViewModelProtocol {
    private(set) var city: City
    private var network: Network

    var displayName: String? {
        return city.name
    }

    var temperature: Int

    var isSunny: Bool {
        self.temperature > 30
    }

    init(_ city: City, network: Network = NetworkClient()) {
        self.city = city
        self.network = network
        self.temperature = Int.random(in: 0..<100)
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
        return "\(self.displayName ?? "nowhere") \(self.temperature)"
    }

    var debugDescription: String {
        return self.description
    }
 }
