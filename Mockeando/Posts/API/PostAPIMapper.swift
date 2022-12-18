//
//  PostAPIMapper.swift
//  Mockeando
//
//  Created by Franklin Samboni on 18/12/22.
//

import Foundation

enum PostAPIMapper {
    static func mapPosts(_ data: Data) throws -> [Post] {
        let decoded = try JSONDecoder().decode([Payload].self, from: data)
        let posts = Self.map(items: decoded)
        return posts
    }
    
    static func mapPost(_ data: Data) throws -> Post {
        let decoded = try JSONDecoder().decode(Payload.self, from: data)
        let posts = Self.map(item: decoded)
        return posts
    }
    
    private static func map(items: [Payload]) -> [Post] {
        items.map { Self.map(item: $0) }
    }
    
    private static func map(item: Payload) -> Post {
        Post(userId: item.userId,
             id: item.id,
             title: item.title,
             body: item.body,
             isFavorite: false)
    }
    
    private struct Payload: Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
}
