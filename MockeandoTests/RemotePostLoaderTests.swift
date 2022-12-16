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
        // Given
        let expectedError = NSError(domain: "an error", code: 0)
        let (sut, httpClientSpy) = makeSUT(url: anyURL())

        // When
        let receivedResponse = loadResponseFor(sut, when: {
            httpClientSpy.completeLoad(with: expectedError)
        })
        
        // Then
        switch receivedResponse {
        case .success:
            XCTFail("Expected failure got \(receivedResponse) instead")
        case .failure(let receivedError):
            XCTAssertEqual(receivedError as NSError, expectedError)
        }
    }
    
    func test_load_completesWithErrorOnInvalidData() {
        // Given
        let invalidJSON = Data("Invalid JSON".utf8)
        let expectedError = RemotePostLoader.LoaderError.invalidData
        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        // When
        let receivedResponse = loadResponseFor(sut, when: {
            httpClientSpy.completeLoad(with: invalidJSON)
        })
        
        // Then
        switch receivedResponse {
        case .success:
            XCTFail("Expected failure got \(receivedResponse) instead")
        case let .failure(receivedError):
            XCTAssertEqual(receivedError as! RemotePostLoader.LoaderError, expectedError)
        }
    }
    
    func test_load_completesWithEmptyOnEmptyDataResponse() {
        // Given
        let emptyPosts = Data("[]".utf8)
        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        // When
        let receivedResponse = loadResponseFor(sut, when: {
            httpClientSpy.completeLoad(with: emptyPosts)
        })
        
        // Then
        switch receivedResponse {
        case .success(let receivedPosts):
            XCTAssertTrue(receivedPosts.isEmpty)
        case .failure:
            XCTFail("Expected success got \(receivedResponse) instead")
        }
    }
    
    func test_load_completesWithPostsOnValidData() {
        // Given
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
        
        // When
        let receivedResponse = loadResponseFor(sut, when: {
            let data = try! JSONSerialization.data(withJSONObject: itemsJSON)
            httpClientSpy.completeLoad(with: data)
        })

        // Then
        switch receivedResponse {
        case .success(let receivedPosts):
            XCTAssertEqual(receivedPosts, expectedPosts)
        case .failure:
            XCTFail("Expected success got \(receivedResponse) instead")
        }
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
    
    private func loadResponseFor(_ sut: PostLoader, when action: () -> Void) -> Result<[Post], Error> {
        let exp = expectation(description: "wait for completion")
        
        var receivedResponse: Result<[Post], Error>!
        sut.load { response in
            receivedResponse = response
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 0.5)
        return receivedResponse
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
