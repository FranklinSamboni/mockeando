//
//  PostsEndpoint.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public enum PostsEndpoint {
    case get
    case getBy(id: String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/posts")
        case let .getBy(id):
            return baseURL.appendingPathComponent("/posts/\(id)")
        }
    }
}
