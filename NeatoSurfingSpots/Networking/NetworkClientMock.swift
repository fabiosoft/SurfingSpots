//
//  NetworkClientMock.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import Foundation

class NetworkSessionTaskMock: NetworkSessionTask {

    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.closure()
        }
    }

    func cancel() {

    }
}

class NetworkClientMock: Network {

    var randomNumber: Int?

    func cities(completion: @escaping (Result<[City], NetworkError>) -> Void) {
        let task = NetworkSessionTaskMock {
            let cities = [
                City(name: "Cuba"),
                City(name: "Los Angeles"),
                City(name: "Miami"),
                City(name: "Porto"),
                City(name: "Ortona"),
                City(name: "Riccione"),
                City(name: "Midgar")
            ]
            completion(.success(cities))
        }
        task.resume()
    }

    func randomNumber(completion: @escaping (Result<Int, NetworkError>) -> Void) {
        let task = NetworkSessionTaskMock {
            if let number = self.randomNumber {
                completion(.success(number))
                return
            }
            completion(.success(Int.random(in: 1..<100)))
        }
        task.resume()
    }

}
