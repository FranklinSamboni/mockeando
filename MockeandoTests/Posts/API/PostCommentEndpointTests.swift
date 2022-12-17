//
//  PostCommentEndpointTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class PostCommentEndpointTests: XCTestCase {
    func test_postComment_endpointURL() {
        let baseURL = URL(string: "http://a-base-url.com")!

        let received = PostCommentEndpoint.get(id: "123").url(baseURL: baseURL)
        let expected = URL(string: "http://a-base-url.com/posts/123/comments")!

        XCTAssertEqual(received, expected)
    }
}
