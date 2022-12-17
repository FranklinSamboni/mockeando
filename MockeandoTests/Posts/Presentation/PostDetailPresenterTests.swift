//
//  PostDetailPresenterTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class PostDetailPresenterTests: XCTestCase {

    func test_init_doesNotLoadData() {
        let (_, detailView, errorView, loadingView, adapter) = makeSUT()
        
        XCTAssertEqual(detailView.receivedMessages.count, 0)
        XCTAssertEqual(errorView.receivedMessages.count, 0)
        XCTAssertEqual(loadingView.receivedMessages.count, 0)
        XCTAssertEqual(adapter.receivedMessages.count, 0)
    }
    
    func test_load_displaysDataOnLoaderSucceedResponse() {
        let (sut, detailView, errorView, loadingView, adapter) = makeSUT()

        sut.load()
        XCTAssertEqual(loadingView.receivedMessages, [isLoading(true)])
        
        let post = Post(userId: 10,
                        id: 10,
                        title: "Expected title",
                        body: "Expected body",
                        isFavorite: false)
        let comment = PostComment(id: 20,
                                   postId: 20,
                                   name: "Expected name",
                                   email: "Expected email",
                                   body: "Expected body")
        let user = User(id: 30,
                        name: "Expected name",
                        username: "Expected username",
                        email: "Expected email",
                        city: "Expected city",
                        website: "Expected website",
                        company: "Expected company")
        let data = (post: post, comments: [comment], user: user)
        
        let expectedViewModel = PostDetailViewModel(title: post.title,
                                                    body: post.body,
                                                    author: user.username,
                                                    location: user.city,
                                                    website: user.website,
                                                    comments: [PostCommentViewModel(author: comment.email,
                                                                                    title: comment.name,
                                                                                    description: comment.body)])
                                                               
        adapter.completeLoadWith(data: data)
                                                               
        XCTAssertEqual(adapter.receivedMessages.count, 1)
        XCTAssertEqual(loadingView.receivedMessages, [isLoading(true), isLoading(false)])
        XCTAssertEqual(detailView.receivedMessages, [expectedViewModel])
        XCTAssertEqual(errorView.receivedMessages.count, 0)
    }
    
    func test_load_displaysErrorOnLoaderErrorResponse() {
        let (sut, detailView, errorView, loadingView, adapter) = makeSUT()

        sut.load()
        XCTAssertEqual(loadingView.receivedMessages, [isLoading(true)])
        
        adapter.completeLoadWith(error: NSError(domain: "An error", code: 0))
        
        XCTAssertEqual(adapter.receivedMessages.count, 1)
        XCTAssertEqual(loadingView.receivedMessages, [isLoading(true), isLoading(false)])
        XCTAssertEqual(detailView.receivedMessages.count, 0)
        XCTAssertEqual(errorView.receivedMessages.count, 1)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: PostDetailPresenter,
                                                                                 detailView: PostDetailViewSpy,
                                                                                 errorViewSpy: ErrorViewSpy,
                                                                                 loadingViewSpy: LoadingViewSpy,
                                                                                 adapterSpy: PostDetailsPresenderAdaterSpy) {
        let detailViewSpy = PostDetailViewSpy()
        let errorViewSpy = ErrorViewSpy()
        let loadingViewSpy = LoadingViewSpy()
        let adapterSpy = PostDetailsPresenderAdaterSpy()
        
        let sut = PostDetailPresenter(detailView: detailViewSpy, loadingView: loadingViewSpy, errorView: errorViewSpy, adapter: adapterSpy)
        
        trackForMemoryLeak(detailViewSpy, file: file, line: line)
        trackForMemoryLeak(errorViewSpy, file: file, line: line)
        trackForMemoryLeak(loadingViewSpy, file: file, line: line)
        trackForMemoryLeak(adapterSpy, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, detailViewSpy, errorViewSpy, loadingViewSpy, adapterSpy)
    }
    
    private func isLoading(_ bool: Bool) -> LoadingViewModel {
        LoadingViewModel(isLoading: bool)
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been dellocated, potential memory leak", file: file, line: line)
        }
    }
}
