//
//  RemotePostLoaderTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 15/12/22.
//

import XCTest
import Mockeando

final class RemotePostLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, httpClientSpy) = makeSUT(url: anyURL())
        
        XCTAssertEqual(httpClientSpy.receivedURLs, [])
    }
    
    func test_load_requestDataFromURL() {
        let expectedURL = anyURL()
        let (sut, httpClientSpy) = makeSUT(url: expectedURL)

        sut.load { _ in }
        
        XCTAssertEqual(httpClientSpy.receivedURLs, [expectedURL])
    }
    
    func test_load_completesWithErrorOnError() {
        let expectedError = NSError(domain: "an error", code: 0)
        let (sut, httpClientSpy) = makeSUT(url: anyURL())

        let exp = expectation(description: "wait for completion")
        sut.load { response in
            switch response {
            case .success:
                XCTFail("Expected failure got \(response) instead")
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
            }
            exp.fulfill()
        }
        
        httpClientSpy.completions[0](nil, expectedError)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: Helpers
    private func makeSUT(url: URL) -> (PostLoader, HTTPClientSpy) {
        let httpClienSpy = HTTPClientSpy()
        let sut = RemotePostLoader(httpClient: httpClienSpy, url: url)
        return (sut, httpClienSpy)
    }
    
    private func anyURL() -> URL {
        URL(string: "any-url.com")!
    }
    
    class HTTPClientSpy: HTTPClient {
        var receivedURLs: [URL] = []
        var completions: [(Data?, Error?) -> Void] = []

        func get(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
            receivedURLs.append(url)
            completions.append(completion)
        }
    }
    
}
