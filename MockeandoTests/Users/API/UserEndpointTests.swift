//
//  UserEndpointTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class UserEndpointTests: XCTestCase {
    func test_posts_endpointURL() {
        let baseURL = URL(string: "http://a-base-url.com")!

        let received = UserEndpoint.get(id: "123").url(baseURL: baseURL)
        let expected = URL(string: "http://a-base-url.com/users/123")!

        XCTAssertEqual(received, expected)
    }
}
