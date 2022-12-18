//
//  PostsPresenterAdapter.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

open class PostsPresenterAdapter {
    private let remoteLoader: PostsLoader
    private let localLoader: PostsLoader
    private let cache: PostCache

    public init(remoteLoader: PostsLoader, localLoader: PostsLoader, postCache: PostCache) {
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
        self.cache = postCache
    }

    open func load(completion: @escaping (PostsLoader.Response) -> Void) {
        remoteLoader.load { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case let .success(posts):
                self.cache.save(posts: posts, completion: { _ in
                    self.localLoader.load { localResponse in
                        DispatchQueue.main.async {
                            completion(localResponse)
                        }
                    }
                })
                
            case .failure:
                self.localLoader.load { localResponse in
                    DispatchQueue.main.async {
                        completion(localResponse)
                    }
                }
            }
        }
    }

    func loadFromLocal(completion: @escaping (PostsLoader.Response) -> Void) {
        localLoader.load { localResponse in
            DispatchQueue.main.async {
                completion(localResponse)
            }
        }
    }
    
    func onFavorite(item: PostViewModel) {
        cache.favorite(postId: item.id)
    }
    
    func onUnfavorite(item: PostViewModel) {
        cache.unfavorite(postId: item.id)
    }
    
    func onDelete(items: [PostViewModel], completion: @escaping (Bool) -> Void) {
        let posts = items.map { $0.id }
        cache.delete(postIds: posts) { completed in
            DispatchQueue.main.async {
                completion(completed)
            }
        }
    }
}
