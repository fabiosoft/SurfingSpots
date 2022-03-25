//
//  CityViewModel.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 26/03/22.
//

import Foundation

protocol CityViewModelProtocol {
    var displayName: String? {get}
}

class CityViewModel: CityViewModelProtocol {
    private(set) var city: City
    private var network: Network

    var displayName: String? {
        return city.name
    }

    init(_ city: City, network: Network = NetworkClient()) {
        self.city = city
        self.network = network
    }

}

extension CityViewModel: Hashable {
    static func == (lhs: CityViewModel, rhs: CityViewModel) -> Bool {
        return lhs.displayName == rhs.displayName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.displayName)
    }

}
