//
//  PostDetailsPresenderAdaterTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class PostDetailsPresenderAdaterTests: XCTestCase {
    
    func test_load_completesWithErrorOnAnyError() {
        let (sut, postLoader, commentsLoader, userLoader) = makeSUT()
        
        postLoader.stub = .failure(anyError())
        commentsLoader.stub = .success([])
        userLoader.stub = .failure(anyError())
        
        let exp = expectation(description: "wait for completion")
        var receivedResponse: Result<(Post,[PostComment], User), Error>!
        sut.load { response in
            receivedResponse = response
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.3)

        XCTAssertThrowsError(try receivedResponse.get(), "Expect a failure got \(String(describing: receivedResponse)) instead")
    }
    
    func test_load_completesDataOnSucceed() throws {
        let (sut, postLoader, commentsLoader, userLoader) = makeSUT()
        
        let post = Post(userId: 0, id: 0, title: "title", body: "body", isFavorite: false)
        postLoader.stub = .success(post)
        
        let comments = [PostComment(id: 0, postId: 0, name: "name", email: "email", body: "body")]
        commentsLoader.stub = .success(comments)
        
        let user = User(id: 0, name: "name", username: "username", email: "email", city: "city", website: "website", company: "company")
        userLoader.stub = .success(user)
        
        let exp = expectation(description: "wait for completion")
        var receivedResponse: Result<(Post, [PostComment], User), Error>!
        sut.load { response in
            receivedResponse = response
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.3)

        XCTAssertNoThrow(try receivedResponse.get())
        let data = try receivedResponse.get()
        
        XCTAssertEqual(data.0, post)
        XCTAssertEqual(data.1, comments)
        XCTAssertEqual(data.2, user)
    }
    
    func test_load_dispatchesInTheMainThread() throws {
        let (sut, postLoader, commentsLoader, userLoader) = makeSUT()
        
        postLoader.stub = .failure(anyError())
        commentsLoader.stub = .success([])
        userLoader.stub = .failure(anyError())
        
        let exp = expectation(description: "wait for completion")
        sut.load { response in
            XCTAssertTrue(Thread.isMainThread, "Should displatch work in the main thread")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.3)

    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: PostDetailsPresenderAdater,
                                                                                 postLoader: PostLoaderMock,
                                                                                 commentsLoader: PostCommentsLoaderMock,
                                                                                 userLoader: UserLoaderMock) {
        let postLoader = PostLoaderMock()
        let commentsLoader = PostCommentsLoaderMock()
        let userLoader = UserLoaderMock()
        let sut = PostDetailsPresenderAdater(postLoader: postLoader, commentsLoader: commentsLoader, userLoader: userLoader)

        trackForMemoryLeak(postLoader, file: file, line: line)
        trackForMemoryLeak(commentsLoader, file: file, line: line)
        trackForMemoryLeak(userLoader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, postLoader, commentsLoader, userLoader)
    }
    
    private func anyError() -> Error {
        return NSError(domain: "any error", code: 0)
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been dellocated, potential memory leak", file: file, line: line)
        }
    }
}

class PostLoaderMock: PostLoader {
    var stub: Response!

    func load(completion: @escaping (Response) -> Void) {
        completion(stub)
    }
}

class PostCommentsLoaderMock: PostCommentsLoader {
    var stub: Response!

    func load(completion: @escaping (Response) -> Void) {
        completion(stub)
    }
}

class UserLoaderMock: UserLoader {
    var stub: Response!

    func load(completion: @escaping (Response) -> Void) {
        completion(stub)
    }
}


