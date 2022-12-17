//
//  PostComment.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public struct PostComment: Equatable {
    public let id: Int
    public let postId: Int
    public let name: String
    public let email: String
    public let body: String
    
    init(id: Int, postId: Int, name: String, email: String, body: String) {
        self.id = id
        self.postId = postId
        self.name = name
        self.email = email
        self.body = body
    }
}
