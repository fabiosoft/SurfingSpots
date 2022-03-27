//
//  MockyURLProtocol.swift
//  NeatoSurfingSpotsTests
//
//  Created by Fabio Nisci on 27/03/22.
//

import Foundation

class MockyURLProtocol: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let data = MockyURLProtocol.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
