//
//  RemotePostLoader.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import Foundation

public class RemoteLoader {
    private let httpClient: HTTPClient
    private let url: URL
    
    public init(httpClient: HTTPClient, url: URL) {
        self.httpClient = httpClient
        self.url = url
    }
    
    func load<T>(tryMap mapper:  @escaping (Data) throws -> T, completion: @escaping (Result<T, Error>) -> Void) {
        httpClient.get(from: url) { [weak self] response in
            guard self != nil else { return }
            
            switch response {
            case let .success(data):
                do {
                    let posts = try mapper(data)
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
