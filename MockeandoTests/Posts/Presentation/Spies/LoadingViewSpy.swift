//
//  LoadingViewSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Mockeando

class LoadingViewSpy: LoadingView {
    var receivedMessages = [LoadingViewModel]()

    func display(_ viewModel: LoadingViewModel) {
        receivedMessages.append(viewModel)
    }
}
