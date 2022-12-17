//
//  Post.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import Foundation

public struct Post: Equatable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String
    public let isFavorite: Bool
    
    public init(userId: Int, id: Int, title: String, body: String, isFavorite: Bool) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
    }
}
