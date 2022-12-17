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
    public let items: [PostViewModel]
    
    public init(items: [PostViewModel]) {
        self.items = items
    }
}

public struct PostViewModel: Equatable {
    public let title: String
    public let isFavorite: Bool
    
    public init(title: String, isFavorite: Bool) {
        self.title = title
        self.isFavorite = isFavorite
    }
}
