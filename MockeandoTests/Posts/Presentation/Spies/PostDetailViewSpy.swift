//
//  PostDetailViewSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Mockeando

class PostDetailViewSpy: PostDetailView {
    var receivedMessages = [PostDetailViewModel]()
    
    func display(_ viewModel: PostDetailViewModel) {
        receivedMessages.append(viewModel)
    }
}
