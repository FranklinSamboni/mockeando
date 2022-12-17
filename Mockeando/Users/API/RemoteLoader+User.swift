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
    
    private enum UserAPIMapper {
        static func map(_ data: Data) throws -> User {
            let decoded = try JSONDecoder().decode(Payload.self, from: data)
            let users = Self.map(payload: decoded)
            return users
        }
        
        private static func map(payload: Payload) -> User {
            User(id: payload.id,
                 name: payload.name,
                 username: payload.username,
                 email: payload.email,
                 city: payload.address.city,
                 website: payload.website,
                 company: payload.company.name)
        }
        
        // MARK: - User
        struct Payload: Codable {
            let id: Int
            let name, username, email: String
            let address: Address
            let phone, website: String
            let company: Company
            
            struct Address: Codable {
                let street, suite, city, zipcode: String
                let geo: Geo
            }
            
            struct Geo: Codable {
                let lat, lng: String
            }
            
            struct Company: Codable {
                let name, catchPhrase, bs: String
            }
        }
    }
}
