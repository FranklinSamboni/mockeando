//
//  ErrorView.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public protocol ErrorView: AnyObject {
    func display(_ viewModel: ErrorViewModel)
}

public struct ErrorViewModel: Equatable {
    public let message: String
    public let title: String
    public let buttonTitle: String
    
    init(message: String, title: String, buttonTitle: String) {
        self.message = message
        self.title = title
        self.buttonTitle = buttonTitle
    }
}
