//
//  PostsViewSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Mockeando

class PostsViewSpy: PostsView {
    var receivedMessages = [PostsViewModel]()
    
    func display(_ viewModel: PostsViewModel) {
        receivedMessages.append(viewModel)
    }
}
