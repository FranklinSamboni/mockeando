//
//  RemoteLoader+Posts.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

extension RemoteLoader: PostLoader {
    public func load(completion: @escaping (Response) -> Void) {
        load(tryMap: PostAPIMapper.map(_:), completion: completion)
    }
    
    private enum PostAPIMapper {
        static func map(_ data: Data) throws -> [Post] {
            let decoded = try JSONDecoder().decode([Payload].self, from: data)
            let posts = Self.map(payload: decoded)
            return posts
        }
        
        private static func map(payload: [Payload]) -> [Post] {
            payload.map { Post(userId: $0.userId,
                               id: $0.id,
                               title: $0.title,
                               body: $0.body) }
        }
        
        private struct Payload: Codable {
            let userId: Int
            let id: Int
            let title: String
            let body: String
        }
    }
}
