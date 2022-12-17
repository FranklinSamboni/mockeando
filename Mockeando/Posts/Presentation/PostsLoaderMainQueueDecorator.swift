//
//  PostsLoaderMainQueueDecorator.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

class PostsLoaderMainQueueDecorator: PostsLoader {
    private let decorator: PostsLoader
    
    init(decorator: PostsLoader) {
        self.decorator = decorator
    }
    
    func load(completion: @escaping (Response) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.decorator.load(completion: completion)
        }
    }
}
