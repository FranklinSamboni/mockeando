//
//  PostDetailsPresenderAdater.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

open class PostDetailsPresenderAdater {
    private let postLoader: PostLoader
    private let commentsLoader: PostCommentsLoader
    private let userLoader: UserLoader
        
    private let dispatchGroup = DispatchGroup()
    
    public init(postLoader: PostLoader, commentsLoader: PostCommentsLoader, userLoader: UserLoader) {
        self.postLoader = postLoader
        self.commentsLoader = commentsLoader
        self.userLoader = userLoader
    }
    
    open func load(completion: @escaping (Result<(Post, [PostComment], User), Error>) -> Void) {
        var postResponse: PostLoader.Response?
        var commentsResponse: PostCommentsLoader.Response?
        var userResponse: UserLoader.Response?
        
        dispatchGroup.enter()
        postLoader.load { [weak self] response in
            postResponse = response
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        commentsLoader.load { [weak self] response in
            commentsResponse = response
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        userLoader.load { [weak self] response in
            userResponse = response
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            do {
                guard let post = try postResponse?.get(),
                      let comments = try commentsResponse?.get(),
                      let user = try userResponse?.get()
                else {
                    throw NSError(domain: "Data not found", code: 404)
                }
                
                completion(.success((post, comments, user)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
