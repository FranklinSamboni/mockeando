//
//  PostsPresenter.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public class PostsPresenter {
    
    private let loader: PostsLoader
    private weak var postsView: PostsView?
    private weak var loadingView: LoadingView?
    private weak var errorView: ErrorView?
    
    public init(postsView: PostsView, loadingView: LoadingView, errorView: ErrorView, loader: PostsLoader) {
        self.postsView = postsView
        self.errorView = errorView
        self.loadingView = loadingView
        self.loader = loader
    }
    
    public func load() {
        loadingView?.display(LoadingViewModel(isLoading: true))
        
        loader.load { [weak self] response in
            guard let self = self else { return }
            
            self.loadingView?.display(LoadingViewModel(isLoading: false))
            
            switch response {
            case let .success(posts):
                let items = posts.map { PostViewModel(title: $0.title, isFavorite: $0.isFavorite) }
                let viewModel = PostsViewModel(items: items)
                self.postsView?.display(viewModel)
            case .failure:
                let error = ErrorViewModel(message: "Ups, something went wrong")
                self.errorView?.display(error)
            }
        }
    }
}

extension PostsPresenter {
    static let title = "Posts"
    static let lists = "Lists"
    static let errorTitle = "Error"
    static let ok = "OK"
    static let favorite = "Favorite"
    static let unfavorite = "Unfavorite"
    static let edit = "Edit"
    static let cancel = "Cancel"
    static let selectAll = "Select All"
}
