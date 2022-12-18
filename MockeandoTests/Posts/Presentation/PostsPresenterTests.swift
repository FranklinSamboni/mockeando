//
//  PostsPresenterTests.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import XCTest
import Mockeando

final class PostsPresenterTests: XCTestCase {
    
    func test_init_doesNotLoadData() {
        let (_, postsViewSpy, errorViewSpy, loadingViewSpy, postsLoaderSpy) = makeSUT()
        
        XCTAssertEqual(postsViewSpy.receivedMessages.count, 0)
        XCTAssertEqual(loadingViewSpy.receivedMessages.count, 0)
        XCTAssertEqual(errorViewSpy.receivedMessages.count, 0)
        XCTAssertEqual(postsLoaderSpy.receivedMessages.count, 0)
    }
    
    func test_load_displaysPostsOnLoaderSucceedResponse() {
        let (sut, postsViewSpy, errorViewSpy, loadingViewSpy, postsLoaderSpy) = makeSUT()

        sut.load()
        XCTAssertEqual(loadingViewSpy.receivedMessages, [isLoading(true)])
        
        let post = Post(userId: 0, id: 0, title: "expected title", body: "a body", isFavorite: false)
        let expectedViewModel = PostsViewModel(favorites: [], lists: [PostViewModel(id: post.id, title: "expected title", isFavorite: false)])
        postsLoaderSpy.completeLoadWith(posts: [post])
        
        XCTAssertEqual(postsLoaderSpy.receivedMessages.count, 1)
        XCTAssertEqual(loadingViewSpy.receivedMessages, [isLoading(true), isLoading(false)])
        XCTAssertEqual(postsViewSpy.receivedMessages, [expectedViewModel])

        XCTAssertEqual(errorViewSpy.receivedMessages.count, 0)
    }
    
    func test_load_displaysErrorOnLoaderErrorResponse() {
        let (sut, postsViewSpy, errorViewSpy, loadingViewSpy, postsLoaderSpy) = makeSUT()

        sut.load()
        XCTAssertEqual(loadingViewSpy.receivedMessages, [isLoading(true)])
        
        postsLoaderSpy.completeLoadWith(error: NSError(domain: "An error", code: 0))
        
        XCTAssertEqual(postsLoaderSpy.receivedMessages.count, 1)
        XCTAssertEqual(loadingViewSpy.receivedMessages, [isLoading(true), isLoading(false)])
        XCTAssertEqual(postsViewSpy.receivedMessages.count, 0)
        XCTAssertEqual(errorViewSpy.receivedMessages.count, 1)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: PostsPresenter,
                                                                                 postsView: PostsViewSpy,
                                                                                 errorViewSpy: ErrorViewSpy,
                                                                                 loadingViewSpy: LoadingViewSpy,
                                                                                 adapter: PostsPresenterAdapterSpy) {
        let postsViewSpy = PostsViewSpy()
        let errorViewSpy = ErrorViewSpy()
        let loadingViewSpy = LoadingViewSpy()
        let adapterSpy = PostsPresenterAdapterSpy()
        
        let sut = PostsPresenter(postsView: postsViewSpy, loadingView: loadingViewSpy, errorView: errorViewSpy, adapter: adapterSpy)

        trackForMemoryLeak(postsViewSpy, file: file, line: line)
        trackForMemoryLeak(errorViewSpy, file: file, line: line)
        trackForMemoryLeak(loadingViewSpy, file: file, line: line)
        trackForMemoryLeak(adapterSpy, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, postsViewSpy, errorViewSpy, loadingViewSpy, adapterSpy)
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
