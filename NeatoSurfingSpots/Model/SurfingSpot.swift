//
//  SurfingSpot.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import Foundation

class SurfingSpot: Codable {
    let cities: [City]?

    init(cities: [City]?) {
        self.cities = cities
    }
}

class City: Codable {
    let name: String?

    init(name: String?) {
        self.name = name
    }
}
