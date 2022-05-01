//
//  Spy.swift
//  NeatoSurfingSpotsTests
//
//  Created by Fabio Nisci on 28/04/22.
//

import Foundation
import FNEasyBind
@testable import NeatoSurfingSpots

class SpyTest<T> {
    private(set) var values = [T]()
    private(set) var disposeBag = DisposeBag()
    init(_ publisher: Observable<T>) {
        publisher.subscribe { [weak self] new, _ in
            self?.values.append(new)
        }.disposed(by: &disposeBag)
    }
}

class SpyTestSequence<T: Sequence> {
    private(set) var values = [T.Element]()
    private(set) var disposeBag = DisposeBag()
    init(_ publisher: Observable<T>) {
        publisher.subscribe { [weak self] values, _ in
            values.forEach { value in
                self?.values.append(value)
            }
        }.disposed(by: &disposeBag)
    }
}

class NetworkServiceMock: Network {
    var result: Result<[City], NetworkError>? = nil
    func cities(completion: @escaping (Result<[City], NetworkError>) -> Void) {
        let cities = [
            City(name: "Napoli")
        ]
        completion(self.result ?? .success(cities))
    }
    func randomNumber(completion: @escaping (Result<Int, NetworkError>) -> Void) {
        
    }
}
