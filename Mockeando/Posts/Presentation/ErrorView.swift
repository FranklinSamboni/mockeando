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
    
    public init(message: String) {
        self.message = message
    }
}
