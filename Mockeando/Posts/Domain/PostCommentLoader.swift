//
//  PostCommentLoader.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public protocol PostCommentLoader {
    typealias Response = Result<[PostComment], Error>
    
    func load(completion: @escaping (Response) -> Void)
}
