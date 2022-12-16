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
                do {
                    let decoded = try JSONDecoder().decode([Payload].self, from: data ?? Data())
                    completion(.success(self.map(payload: decoded)))
                } catch {
                    completion(.failure(LoaderError.invalidData))
                }
            }
        }
    }
    
    private func map(payload: [Payload]) -> [Post] {
        payload.map { Post(userId: $0.userId,
                           id: $0.id,
                           title: $0.title,
                           body: $0.body) }
    }
    
    private struct Payload: Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
    
    public enum LoaderError: Error {
        case invalidData
    }
}
