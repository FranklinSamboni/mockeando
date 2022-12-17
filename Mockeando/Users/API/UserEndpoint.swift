//
//  UserEndpoint.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public enum UserEndpoint {
    case get(id: String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/users/\(id)")
        }
    }
}
