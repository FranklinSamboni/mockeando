//
//  PostDetailCache.swift
//  Mockeando
//
//  Created by Franklin Samboni on 18/12/22.
//

import Foundation

public protocol PostDetailCache {
    func save(post: Post, user: User, comments: [PostComment], completion: @escaping (Bool) -> Void)
    func retrive(postId: Int) -> (Post, User, [PostComment])
}
