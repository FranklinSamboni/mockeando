//
//  PostDetailView.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public protocol PostDetailView: AnyObject {
    func display(_ viewModel: PostDetailViewModel)
}

public struct PostDetailViewModel: Equatable {
    public let title: String
    public let body: String
    public let authorInfo: String
    public let comments: [PostCommentViewModel]
    
    public init(title: String, body: String, authorInfo: String, comments: [PostCommentViewModel]) {
        self.title = title
        self.body = body
        self.authorInfo = authorInfo
        self.comments = comments
    }
}

public struct PostCommentViewModel: Equatable {
    public let author: String
    public let title: String
    public let description: String
    
    public init(author: String, title: String, description: String) {
        self.author = author
        self.title = title
        self.description = description
    }
}
