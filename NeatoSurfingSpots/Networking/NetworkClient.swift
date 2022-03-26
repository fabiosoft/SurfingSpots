//
//  NetworkClient.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import UIKit

protocol Network {
    func cities(completion: @escaping (Result<[City], NetworkError>) -> Void)
    func randomNumber(completion: @escaping (Result<Int, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case networkError
    case malformedURL
    case malformedData
}

protocol NetworkSession {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionTask
}
protocol NetworkSessionTask {
    func resume()
    func cancel()
}

extension URLSessionDataTask: NetworkSessionTask {

}

extension URLSession: NetworkSession {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkSessionTask {
        return dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
}

class NetworkClient: Network {
    private let session: NetworkSession
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func cities(completion: @escaping (Result<[City], NetworkError>) -> Void) {
        let urlString = "https://run.mocky.io/v3/652ceb94-b24e-432b-b6c5-8a54bc1226b6"
        guard let url = URL(string: urlString) else {
            completion(.failure(.malformedURL))
            return
        }
        let task = session.loadData(from: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkError))
                return
            }
            let root = try? JSONDecoder().decode(SurfingSpot.self, from: data)
            completion(.success(root?.cities ?? []))

        }
        task.resume()
    }

    func randomNumber(completion: @escaping (Result<Int, NetworkError>) -> Void) {
        let urlString = "http://numbersapi.com/random/math"
        guard let url = URL(string: urlString) else {
            completion(.failure(.malformedURL))
            return
        }
        let task = session.loadData(from: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkError))
                return
            }

            guard
                let string = String(data: data, encoding: .utf8),
                let stringValue = string.components(separatedBy: " ").first?.lowercased(),
                stringValue != "infinity"
            else {
                return completion(.failure(.malformedData))
            }
            guard let randomNumber = Int(stringValue) else {
                guard let exponential = self.exponential(from: stringValue) else {
                    return completion(.failure(.malformedData))
                }
                return completion(.success(exponential / 100))
            }
            return completion(.success(randomNumber / 100))
        }
        task.resume()
    }

    private func exponential(from string: String) -> Int? {
        guard let exponential = string.components(separatedBy: "e").first else {
            return nil
        }
        return Int(exponential)
    }
}
