//
//  PostCache.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public protocol PostCache {
    func save(posts: [Post], completion: @escaping (Bool) -> Void)
    func delete(postIds: [Int], completion: @escaping (Bool) -> Void)
    func favorite(postId: Int)
    func unfavorite(postId: Int)
}
