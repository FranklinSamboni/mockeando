//
//  UserLoader.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public protocol UserLoader {
    typealias Response = Result<User, Error>
    
    func load(completion: @escaping (Response) -> Void)
}
