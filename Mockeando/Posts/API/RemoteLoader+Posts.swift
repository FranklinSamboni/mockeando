//
//  RemoteLoader+Posts.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

extension RemoteLoader: PostsLoader {
    public func load(completion: @escaping (PostsLoader.Response) -> Void) {
        load(tryMap: PostAPIMapper.mapPosts(_:), completion: completion)
    }
}

extension RemoteLoader: PostLoader {
    public func load(completion: @escaping (PostLoader.Response) -> Void) {
        load(tryMap: PostAPIMapper.mapPost(_:), completion: completion)
    }
}
