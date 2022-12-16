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

protocol HTTPClient {
    func get(from url: URL)
}

class RemotePostLoader {
    private let httpClient: HTTPClient
    private let url: URL
    
    init(httpClient: HTTPClient, url: URL) {
        self.httpClient = httpClient
        self.url = url
    }
    
    func load() {
        httpClient.get(from: url)
    }
}

final class RemotePostLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let httpClienSpy = HTTPClientSpy()
        let _ = RemotePostLoader(httpClient: httpClienSpy, url: URL(string: "any-url.com")!)
        
        XCTAssertEqual(httpClienSpy.getCallCount, 0)
    }
    
    func test_load_requestDataFromURL() {
        let httpClienSpy = HTTPClientSpy()
        let expectedURL = URL(string: "any-url.com")!
        let sut = RemotePostLoader(httpClient: httpClienSpy, url: expectedURL)
        
        sut.load()
        
        XCTAssertEqual(httpClienSpy.getCallCount, 1)
        XCTAssertEqual(httpClienSpy.receivedURL, expectedURL)
    }
    
    // MARK: Helpers
    class HTTPClientSpy: HTTPClient {
        var getCallCount = 0
        var receivedURL: URL!
        
        func get(from url: URL) {
            getCallCount += 1
            receivedURL = url
        }
    }
    
}
