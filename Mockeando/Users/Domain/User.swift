//
//  User.swift
//  Mockeando
//
//  Created by Franklin Samboni on 17/12/22.
//

import Foundation

public struct User: Equatable {
    public let id: Int
    public let name: String
    public let username: String
    public let email: String
    public let city: String
    public let website: String
    public let company: String
    
    public init(id: Int, name: String, username: String, email: String, city: String, website: String, company: String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.city = city
        self.website = website
        self.company = company
    }
}


