//
//  PostsEndpointTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class PostsEndpointTests: XCTestCase {
    func test_posts_endpointURL() {
        let baseURL = URL(string: "http://a-base-url.com")!

        let received = PostsEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://a-base-url.com/posts")!

        XCTAssertEqual(received, expected)
    }
}
