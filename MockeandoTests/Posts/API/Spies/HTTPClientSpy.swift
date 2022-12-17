//
//  HTTPClientSpy.swift
//  MockeandoTests
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation
import Mockeando

class HTTPClientSpy: HTTPClient {

    var receivedURLs: [URL] = []
    var completions: [(HTTPClient.Response) -> Void] = []

    func get(from url: URL, completion: @escaping (Response) -> Void) {
        receivedURLs.append(url)
        completions.append(completion)
    }
    
    // MARK: Helpers
    func completeLoad(with error: NSError, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func completeLoad(with data: Data, at index: Int = 0) {
        completions[index](.success(data))
    }
}
