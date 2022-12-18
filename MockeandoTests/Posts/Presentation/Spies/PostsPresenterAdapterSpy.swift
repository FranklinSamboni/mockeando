//
//  PostsPresenterAdapterSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation
import Mockeando

class PostsPresenterAdapterSpy: PostsPresenterAdapter {
    
    var receivedMessages = [(Result<[Post], Error>) -> Void]()

    init() {
        super.init(remoteLoader: PostsLoaderSpy(), localLoader: PostsLoaderSpy(), postCache: PostCacheSpy())
    }
    
    override func load(completion: @escaping (Result<[Post], Error>) -> Void) {
        receivedMessages.append(completion)
    }
    
    func completeLoadWith(posts: [Post], at index: Int = 0) {
        receivedMessages[0](.success(posts))
    }
                            
    func completeLoadWith(error: NSError, at index: Int = 0) {
        receivedMessages[0](.failure(error))
    }
}

class PostCacheSpy: PostCache {
    func save(posts: [Mockeando.Post], completion: @escaping (Bool) -> Void) { }
    func delete(postIds: [Int], completion: @escaping (Bool) -> Void) {}
    func favorite(postId: Int) {}
    func unfavorite(postId: Int) {}
}
