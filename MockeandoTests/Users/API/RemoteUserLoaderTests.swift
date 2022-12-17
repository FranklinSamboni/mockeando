//
//  RemoteUserLoaderTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class RemoteUserLoaderTests: XCTestCase {
    
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
    
    func test_load_completesWithUserOnValidData() {
        // Given
        let user = User(id: 10, name: "a name", username: "a username", email: "a email", city: "a city", website: "a website", company: "a company")
        let userJSON: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "username": user.username,
            "email": user.email,
            "address": ["street": "a stree",
                        "suite": "a suite",
                        "city": "a city",
                        "zipcode": "a zipcode",
                        "geo": ["lat": "a lat", "lng": "a lng"]],
            "phone": "a phone",
            "website": user.website,
            "company": ["name": user.company,
                        "catchPhrase": "a catchPhrase",
                        "bs": "a bs"]
        ]

        let (sut, httpClientSpy) = makeSUT(url: anyURL())
        
        // Then
        expect(sut, toCompleteWith: user, when: {
            let dataJSON = try! JSONSerialization.data(withJSONObject: userJSON)
            httpClientSpy.completeLoad(with: dataJSON)
        })
    }
    
    // MARK: Helpers
    private func makeSUT(url: URL, file: StaticString = #filePath, line: UInt = #line) -> (UserLoader, HTTPClientSpy) {
        let httpClienSpy = HTTPClientSpy()
        let sut = RemoteLoader(httpClient: httpClienSpy, url: url)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(httpClienSpy, file: file, line: line)
        
        return (sut, httpClienSpy)
    }
    
    private func anyURL() -> URL {
        URL(string: "any-url.com")!
    }
    
    private func expect(_ sut: UserLoader,
                        toCompleteWith expectedUser: User,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        
        let receivedResponse = loadResponseFor(sut, when: action)
        
        switch receivedResponse {
        case .success(let receivedUser):
            XCTAssertEqual(receivedUser, expectedUser, file: file, line: line)
        case .failure:
            XCTFail("Expected success got \(receivedResponse) instead", file: file, line: line)
        }
    }
    
    private func loadResponseFor(_ sut: UserLoader, when action: () -> Void) -> Result<User, Error> {
        let exp = expectation(description: "wait for completion")
        
        var receivedResponse: Result<User, Error>!
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
