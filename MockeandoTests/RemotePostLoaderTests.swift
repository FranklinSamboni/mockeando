//
//  RemotePostLoaderTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 15/12/22.
//

import XCTest
import Mockeando

struct Post {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol PostLoader {
    typealias Response = Result<[Post], Error>
    
    func load(completion: @escaping (Response) -> Void)
}

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Data?, Error?) -> Void)
}

class RemotePostLoader {
    private let httpClient: HTTPClient
    private let url: URL
    
    init(httpClient: HTTPClient, url: URL) {
        self.httpClient = httpClient
        self.url = url
    }
    
    func load(completion: @escaping (Result<[Post], Error>) -> Void) {
        httpClient.get(from: url) { data, error in
            if let error = error {
                completion(.failure(error))
            }
        }
    }
}

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
    private func makeSUT(url: URL) -> (RemotePostLoader, HTTPClientSpy) {
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
