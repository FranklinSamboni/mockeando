//
//  PostLoader.swift
//  Mockeando
//
//  Created by Franklin Samboni on 15/12/22.
//

import Foundation

public protocol PostsLoader {
    typealias Response = Result<[Post], Error>
    
    func load(completion: @escaping (Response) -> Void)
}
