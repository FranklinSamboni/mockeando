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
            guard self != nil else { return }
            
            switch response {
            case let .success(data):
                do {
                    let posts = try PostAPIMapper.map(data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(LoaderError.invalidData))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public enum LoaderError: Error {
        case invalidData
    }
}

class PostAPIMapper {
    static func map(_ data: Data) throws -> [Post] {
        let decoded = try JSONDecoder().decode([Payload].self, from: data)
        let posts = Self.map(payload: decoded)
        return posts
    }
    
    private static func map(payload: [Payload]) -> [Post] {
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
}
