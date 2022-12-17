//
//  HTTPClient.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import Foundation

public protocol HTTPClient {
    typealias Response = Result<Data, Error>
    
    func get(from url: URL, completion: @escaping (Response) -> Void)
}
