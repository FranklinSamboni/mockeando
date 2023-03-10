//
//  PostLoader.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public protocol PostLoader {
    typealias Response = Result<Post, Error>
    
    func load(completion: @escaping (Response) -> Void)
}
