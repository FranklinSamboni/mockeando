//
//  PostsLoaderSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation
import Mockeando

class PostsLoaderSpy: PostsLoader {
    var receivedMessages = [(Response) -> Void]()
    
    func load(completion: @escaping (Response) -> Void) {
        receivedMessages.append(completion)
    }
    
    // MARK: Helpers
    func completeLoadWith(posts: [Post], at index: Int = 0) {
        receivedMessages[index](.success(posts))
    }
    
    func completeLoadWith(error: NSError, at index: Int = 0) {
        receivedMessages[index](.failure(error))
    }
}
