//
//  PostsPresenter.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public class PostsPresenter {
    
    private let adapter: PostsPresenterAdapter
    private weak var postsView: PostsView?
    private weak var loadingView: LoadingView?
    private weak var errorView: ErrorView?
    
    public init(postsView: PostsView, loadingView: LoadingView, errorView: ErrorView, adapter: PostsPresenterAdapter) {
        self.postsView = postsView
        self.errorView = errorView
        self.loadingView = loadingView
        self.adapter = adapter
    }
    
    private func map(posts: [Post]) -> PostsViewModel {
        let favorites = posts.filter{ $0.isFavorite }.map { PostViewModel(id: $0.id, title: $0.title, isFavorite: $0.isFavorite) }
        let lists = posts.filter{ !$0.isFavorite }.map { PostViewModel(id: $0.id, title: $0.title, isFavorite: $0.isFavorite) }
        return PostsViewModel(favorites: favorites, lists: lists)
    }
    
    public func load() {
        loadingView?.display(LoadingViewModel(isLoading: true))
        
        adapter.load { [weak self] response in
            guard let self = self else { return }
            
            self.loadingView?.display(LoadingViewModel(isLoading: false))
            
            switch response {
            case let .success(posts):
                let viewModel = self.map(posts: posts)
                self.postsView?.display(viewModel)
            case .failure:
                let error = ErrorViewModel(message: "Ups, something went wrong")
                self.errorView?.display(error)
            }
        }
    }
    
    public func onFavorite(item: PostViewModel) {
        adapter.onFavorite(item: item)
        refreshFromLocal()
    }
    
    public func onUnfavorite(item: PostViewModel) {
        adapter.onUnfavorite(item: item)
        refreshFromLocal()
    }
    
    public func onDelete(items: [PostViewModel]) {
        adapter.onDelete(items: items) { [weak self] response in
            self?.refreshFromLocal()
        }
    }
    
    private func refreshFromLocal() {
        adapter.loadFromLocal { [weak self] response in
            guard let self = self,
                  let posts = try? response.get() else { return }
            let viewModel = self.map(posts: posts)
            self.postsView?.display(viewModel)
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
    static let favorites = "★ Favorites"
}
