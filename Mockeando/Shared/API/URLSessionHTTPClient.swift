//
//  URLSessionHTTPClient.swift
//  Mockeando
//
//  Created by Franklin Samboni on 16/12/22.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (Response) -> Void) {
        let dataTask = session.dataTask(with: URLRequest(url: url)) { data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, urlResponse != nil {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "Unexpected Error", code: -1)))
            }
        }
        
        dataTask.resume()
    }
}
