//
//  URLSessionHTTPClientTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 16/12/22.
//

import XCTest
import Mockeando

final class URLSessionHTTPClientTests: XCTestCase {
    
    override class func tearDown() {
        URLProtocolStub.stub = nil
        super.tearDown()
    }
    
    func test_get_failsOnRepresentationError() {
        URLProtocolStub.stub = nil
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for completion")
        sut.get(from: URL(string: "any-URL.com")!) { response in
            switch response {
            case let .failure(error as NSError):
                XCTAssertEqual(error.domain, "Unexpected Error")
            case .success:
                XCTFail("Expected error got \(response) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.3)
    }
    
    func test_get_failsOnRequestError() {
        URLProtocolStub.stub = .failure(NSError(domain: "an error", code: 400))
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for completion")
        sut.get(from: URL(string: "any-URL.com")!) { response in
            switch response {
            case .failure: break
            case .success:
                XCTFail("Expected error got \(response) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.3)
    }
    
    func test_get_completesWithDataOnReceivedResponse() {
        let expectedData = Data("Any data".utf8)
        URLProtocolStub.stub = .success(expectedData)
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for completion")
        sut.get(from: URL(string: "any-URL.com")!) { response in
            switch response {
            case let .success(receivedData):
                XCTAssertEqual(receivedData, expectedData)
            case .failure:
                XCTFail("Expected success got \(response) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.3)
    }
    
    // MARK: Helpers
    private func makeSUT() -> URLSessionHTTPClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let urlSession = URLSession(configuration: config)
        let sut = URLSessionHTTPClient(session: urlSession)
        
        return sut
    }
    
    private class URLProtocolStub: URLProtocol {
        
        private static var _stub: HTTPClient.Response?
        static var stub: HTTPClient.Response? {
            get { return queue.sync { _stub } }
            set { queue.sync { _stub = newValue } }
        }
        
        private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let stub = Self._stub {
                switch stub {
                case let .failure(error):
                    client?.urlProtocol(self, didFailWithError: error)

                case let .success(data):
                    client?.urlProtocol(self, didLoad: data)
                    client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .notAllowed)
                }
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
