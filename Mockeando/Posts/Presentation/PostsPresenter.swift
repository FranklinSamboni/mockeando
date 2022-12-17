//
//  PostsPresenter.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public class PostsPresenter {
    static let title = "Posts"
    
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
                let items = posts.map { PostViewModel(title: $0.title) }
                let viewModel = PostsViewModel(items: items)
                self.postsView?.display(viewModel)
            case .failure:
                let error = ErrorViewModel(message: "Ups, something went wrong")
                self.errorView?.display(error)
            }
        }
    }
}
