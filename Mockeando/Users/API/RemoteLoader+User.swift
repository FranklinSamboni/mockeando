//
//  RemoteLodaer+User.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

extension RemoteLoader: UserLoader {
    public func load(completion: @escaping (UserLoader.Response) -> Void) {
        load(tryMap: UserAPIMapper.map(_:), completion: completion)
    }
}
