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
    
}

class RemotePostLoader {
    
    init(httpClient: HTTPClient) {
        
    }
}

final class RemotePostLoaderTests: XCTestCase {
    
    func test_load_doesNotRequestDataFromURL() {
        let httpClienSpy = HTTPClientSpy()
        let sut = RemotePostLoader(httpClient: httpClienSpy)
        XCTAssertEqual(httpClienSpy.getCallCount, 0)
    }
    
    class HTTPClientSpy: HTTPClient {
        var getCallCount = 0
    }
    
}
