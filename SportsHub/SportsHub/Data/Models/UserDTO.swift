//
//  UserDTO.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

struct UserDTO: Codable {
    let id: Int
    let email: String
    let name: String
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case token = "authentication_token"
    }
}

extension UserDTO {
    func toDomain() -> User {
        return User(
            id: id,
            email: email,
            name: name,
            token: token
        )
    }
}
