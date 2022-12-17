//
//  PostDetailsPresenderAdaterSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation
import Mockeando

class PostDetailsPresenderAdaterSpy: PostDetailsPresenderAdater {
    
    var receivedMessages = [(Result<(Post, [PostComment], User), Error>) -> Void]()

    init() {
        super.init(postLoader: PostLoaderMock(),
                   commentsLoader: PostCommentsLoaderMock(),
                   userLoader: UserLoaderMock())
    }
    
    override func load(completion: @escaping (Result<(Post, [PostComment], User), Error>) -> Void) {
        receivedMessages.append(completion)
    }
    
    func completeLoadWith(data: (post: Post, comments: [PostComment], user: User), at index: Int = 0) {
        receivedMessages[0](.success(data))
    }
                            
    func completeLoadWith(error: NSError, at index: Int = 0) {
        receivedMessages[0](.failure(error))
    }
}
