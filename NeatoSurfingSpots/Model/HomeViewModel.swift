//
//  HomeViewModel.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import Foundation

protocol HomeViewModelProtocol {
    var title: String { get }
}

class HomeViewModel: HomeViewModelProtocol {

    let title: String = "Surfing Spots"

}
