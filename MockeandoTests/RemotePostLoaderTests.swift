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
        let (_, httpClienSpy) = makeSUT()
        
        XCTAssertEqual(httpClienSpy.receivedURLs, [])
    }
    
    func test_load_requestDataFromURL() {
        let expectedURL = URL(string: "any-url.com")!
        let (sut, httpClienSpy) = makeSUT(url: expectedURL)

        sut.load()
        
        XCTAssertEqual(httpClienSpy.receivedURLs, [expectedURL])
    }
    
    // MARK: Helpers
    private func makeSUT(url: URL = URL(string: "any-url.com")!) -> (RemotePostLoader, HTTPClientSpy) {
        let httpClienSpy = HTTPClientSpy()
        let sut = RemotePostLoader(httpClient: httpClienSpy, url: url)
        return (sut, httpClienSpy)
    }
    
    class HTTPClientSpy: HTTPClient {
        var receivedURLs: [URL] = []
        
        func get(from url: URL) {
            receivedURLs.append(url)
        }
    }
    
}
