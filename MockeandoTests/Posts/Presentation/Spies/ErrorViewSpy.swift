//
//  ErrorViewSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Mockeando

class ErrorViewSpy: ErrorView {
    var receivedMessages = [ErrorViewModel]()

    func display(_ viewModel: ErrorViewModel) {
        receivedMessages.append(viewModel)
    }
}
