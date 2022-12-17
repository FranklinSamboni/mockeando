//
//  RemotePostsLoaderTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 15/12/22.
//

import XCTest
import Mockeando

final class RemotePostsLoaderTests: XCTestCase {
    
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
        let expectedError = RemoteLoader.LoaderError.invalidData
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
            XCTAssertEqual(receivedError as! RemoteLoader.LoaderError, expectedError)
        }
    }
    
    func test_load_completesWithEmptyOnEmptyDataResponse() {
        // Given
        let emptyData = Data("[]".utf8)
        let expectedEmptyPosts = [Post]()
        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        // Then
        expect(sut, toCompleteWith: expectedEmptyPosts, when: {
            httpClientSpy.completeLoad(with: emptyData)
        })
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
        
        // Then
        expect(sut, toCompleteWith: expectedPosts, when: {
            let dataJSON = try! JSONSerialization.data(withJSONObject: itemsJSON)
            httpClientSpy.completeLoad(with: dataJSON)
        })
    }
    
    // MARK: Helpers
    private func makeSUT(url: URL, file: StaticString = #filePath, line: UInt = #line) -> (PostsLoader, HTTPClientSpy) {
        let httpClienSpy = HTTPClientSpy()
        let sut = RemoteLoader(httpClient: httpClienSpy, url: url)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(httpClienSpy, file: file, line: line)
        
        return (sut, httpClienSpy)
    }
    
    private func anyURL() -> URL {
        URL(string: "any-url.com")!
    }
    
    private func expect(_ sut: PostsLoader,
                        toCompleteWith expectedPosts: [Post],
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        
        let receivedResponse = loadResponseFor(sut, when: action)
        
        switch receivedResponse {
        case .success(let receivedPosts):
            XCTAssertEqual(receivedPosts, expectedPosts, file: file, line: line)
        case .failure:
            XCTFail("Expected success got \(receivedResponse) instead", file: file, line: line)
        }
    }
    
    private func loadResponseFor(_ sut: PostsLoader, when action: () -> Void) -> Result<[Post], Error> {
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
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been dellocated, potential memory leak", file: file, line: line)
        }
    }
}
