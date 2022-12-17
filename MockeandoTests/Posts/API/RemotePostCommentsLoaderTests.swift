//
//  RemotePostCommentsLoaderTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class RemotePostCommentsLoaderTests: XCTestCase {
    
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
        let expectedEmptyComments = [PostComment]()
        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        // Then
        expect(sut, toCompleteWith: expectedEmptyComments, when: {
            httpClientSpy.completeLoad(with: emptyData)
        })
    }
    
    func test_load_completesWithCommentsOnValidData() {
        // Given
        let comments = PostComment(id: 10, postId: 10, name: "a name", email: "a email", body: "a body")
        let commentsJSON: [String: Any] = [
            "id": comments.id,
            "postId": comments.postId,
            "name": comments.name,
            "email": comments.email,
            "body": comments.body
        ]
        
        let itemsJSON = [commentsJSON]
        let expectedComments = [comments]

        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        // Then
        expect(sut, toCompleteWith: expectedComments, when: {
            let dataJSON = try! JSONSerialization.data(withJSONObject: itemsJSON)
            httpClientSpy.completeLoad(with: dataJSON)
        })
    }
    
    // MARK: Helpers
    private func makeSUT(url: URL, file: StaticString = #filePath, line: UInt = #line) -> (PostCommentsLoader, HTTPClientSpy) {
        let httpClienSpy = HTTPClientSpy()
        let sut = RemoteLoader(httpClient: httpClienSpy, url: url)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(httpClienSpy, file: file, line: line)
        
        return (sut, httpClienSpy)
    }
    
    private func anyURL() -> URL {
        URL(string: "any-url.com")!
    }
    
    private func expect(_ sut: PostCommentsLoader,
                        toCompleteWith expectedComments: [PostComment],
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        
        let receivedResponse = loadResponseFor(sut, when: action)
        
        switch receivedResponse {
        case .success(let receivedComments):
            XCTAssertEqual(receivedComments, expectedComments, file: file, line: line)
        case .failure:
            XCTFail("Expected success got \(receivedResponse) instead", file: file, line: line)
        }
    }
    
    private func loadResponseFor(_ sut: PostCommentsLoader, when action: () -> Void) -> Result<[PostComment], Error> {
        let exp = expectation(description: "wait for completion")
        
        var receivedResponse: Result<[PostComment], Error>!
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
