//
//  RemoteLoader+PostComment.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

extension RemoteLoader: PostCommentLoader {
    public func load(completion: @escaping (PostCommentLoader.Response) -> Void) {
        load(tryMap: PostCommentAPIMapper.map(_:), completion: completion)
    }
    
    private enum PostCommentAPIMapper {
        static func map(_ data: Data) throws -> [PostComment] {
            let decoded = try JSONDecoder().decode([Payload].self, from: data)
            let comments = Self.map(payload: decoded)
            return comments
        }
        
        private static func map(payload: [Payload]) -> [PostComment] {
            payload.map { PostComment(id: $0.id,
                                      postId: $0.postId,
                                      name: $0.name,
                                      email: $0.email,
                                      body: $0.body) }
        }
        
        private struct Payload: Codable {
            let id: Int
            let postId: Int
            let name: String
            let email: String
            let body: String
        }
    }
}
