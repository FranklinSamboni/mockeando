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
        httpClient.get(from: url) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case let .success(data):
                do {
                    let decoded = try JSONDecoder().decode([Payload].self, from: data)
                    let posts = self.map(payload: decoded)
                    completion(.success(posts))
                } catch {
                    completion(.failure(LoaderError.invalidData))
                }
            case let .failure(error):
                completion(.failure(error))
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
