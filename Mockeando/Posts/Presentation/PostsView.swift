//
//  PostsView.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public protocol PostsView: AnyObject {
    func display(_ viewModel: PostsViewModel)
}

public struct PostsViewModel: Equatable {
    public let favorites: [PostViewModel]
    public let lists: [PostViewModel]
    
    public init(favorites: [PostViewModel], lists: [PostViewModel]) {
        self.favorites = favorites
        self.lists = lists
    }
}

public struct PostViewModel: Equatable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let isFavorite: Bool
    
    public init(id: Int, userId: Int, title: String, isFavorite: Bool) {
        self.id = id
        self.userId = userId
        self.title = title
        self.isFavorite = isFavorite
    }
}
