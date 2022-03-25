//
//  Reusable.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 26/03/22.
//

import Foundation

protocol Reusable: NSObject {
    static var reuseIdentifier: String {get}

    associatedtype DataType
    var model: DataType? {get set}
}
