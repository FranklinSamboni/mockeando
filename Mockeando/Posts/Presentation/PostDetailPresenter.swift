//
//  PostDetailPresenter.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public class PostDetailPresenter {
    private let adapter: PostDetailsPresenderAdater
    private weak var detailView: PostDetailView?
    private weak var errorView: ErrorView?
    private weak var loadingView: LoadingView?
    
    public init(detailView: PostDetailView, loadingView: LoadingView, errorView: ErrorView, adapter: PostDetailsPresenderAdater) {
        self.detailView = detailView
        self.errorView = errorView
        self.loadingView = loadingView
        self.adapter = adapter
    }
    
    public func load() {
        loadingView?.display(LoadingViewModel(isLoading: true))
        
        adapter.load { [weak self] response in
            guard let self = self else { return }
            
            self.loadingView?.display(LoadingViewModel(isLoading: false))
            
            switch response {
            case let .success((post, comments, user)):
                let commentsViewModel = comments.map { PostCommentViewModel(author: $0.email,
                                                                            title: $0.name,
                                                                            description: $0.body) }
                let viewModel = PostDetailViewModel(title: post.title,
                                                    body: post.body,
                                                    author: user.username,
                                                    location: user.city,
                                                    website: user.website,
                                                    comments: commentsViewModel)
                self.detailView?.display(viewModel)
            case .failure:
                let error = ErrorViewModel(message: "Ups, something went wrong")
                self.errorView?.display(error)
            }
        }
    }
}
