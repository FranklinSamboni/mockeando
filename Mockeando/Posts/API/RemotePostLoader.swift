//
//  RemotePostLoader.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import Foundation

public class RemotePostLoader: PostLoader {
    private let httpClient: HTTPClient
    private let url: URL
    
    public init(httpClient: HTTPClient, url: URL) {
        self.httpClient = httpClient
        self.url = url
    }
    
    public func load(completion: @escaping (Result<[Post], Error>) -> Void) {
        httpClient.get(from: url) { data, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success([]))
            }
        }
    }
}
