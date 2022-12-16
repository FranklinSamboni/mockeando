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
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(httpClientSpy.receivedURLs, [expectedURL, expectedURL, expectedURL])
    }
    
    func test_load_completesWithErrorOnClientError() {
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
        
        httpClientSpy.completeLoad(with: expectedError)
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_load_completesWithEmptyOnEmptyDataResponse() {
        let emptyPosts = Data("[]".utf8)
        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        let exp = expectation(description: "wait for completion")
        sut.load { response in
            switch response {
            case .success(let receivedPosts):
                XCTAssertTrue(receivedPosts.isEmpty)
            case .failure:
                XCTFail("Expected success got \(response) instead")
            }
            exp.fulfill()
        }
        
        httpClientSpy.completeLoad(with: emptyPosts)
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_load_completesWithPostsOnValidData() {
        let post = Post(userId: 0, id: 0, title: "a title", body: "a body")
        let postJSON: [String: Any] = [
            "userId": post.userId,
            "id": post.id,
            "title": post.title,
            "body": post.body
        ]
        
        let itemsJSON = [postJSON]
        let expectedPosts = [post]

        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        let exp = expectation(description: "wait for completion")
        sut.load { response in
            switch response {
            case .success(let receivedPosts):
                XCTAssertEqual(receivedPosts, expectedPosts)
            case .failure:
                XCTFail("Expected success got \(response) instead")
            }
            exp.fulfill()
        }
        
        let data = try! JSONSerialization.data(withJSONObject: itemsJSON)
        httpClientSpy.completeLoad(with: data)
        
        wait(for: [exp], timeout: 0.5)
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
    
    private class HTTPClientSpy: HTTPClient {
        var receivedURLs: [URL] = []
        var completions: [(Data?, Error?) -> Void] = []

        func get(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
            receivedURLs.append(url)
            completions.append(completion)
        }
        
        // MARK: Helpers
        func completeLoad(with error: NSError, at index: Int = 0) {
            completions[index](nil, error)
        }
        
        func completeLoad(with data: Data, at index: Int = 0) {
            completions[index](data, nil)
        }
    }
    
}
