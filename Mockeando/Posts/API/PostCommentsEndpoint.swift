//
//  PostCommentEndpoint.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public enum PostCommentsEndpoint {
    case get(id: String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/posts/\(id)/comments")
        }
    }
}
