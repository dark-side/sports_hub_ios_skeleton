//
//  UserDTOMappingTests.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

struct UserDTOMappingTests {
    
    @Test func toDomainBasicMapping() {
        let dto = UserDTO(
            id: 1,
            email: "test@example.com",
            name: "Test User",
            token: "abc123"
        )
        
        let user = dto.toDomain()
        
        #expect(user.id == 1)
        #expect(user.email == "test@example.com")
        #expect(user.name == "Test User")
        #expect(user.token == "abc123")
    }
    
    @Test func toDomainWithNilToken() {
        let dto = UserDTO(
            id: 2,
            email: "notoken@example.com",
            name: "No Token User",
            token: nil
        )
        
        let user = dto.toDomain()
        
        #expect(user.id == 2)
        #expect(user.email == "notoken@example.com")
        #expect(user.name == "No Token User")
        #expect(user.token == nil)
    }
    
    @Test func toDomainWithLongToken() {
        let longToken = String(repeating: "a", count: 256)
        let dto = UserDTO(
            id: 3,
            email: "longtoken@example.com",
            name: "Long Token User",
            token: longToken
        )
        
        let user = dto.toDomain()
        
        #expect(user.token == longToken)
        #expect(user.token?.count == 256)
    }
    
    @Test func toDomainWithSpecialCharacters() {
        let dto = UserDTO(
            id: 4,
            email: "special+chars@example.com",
            name: "John O'Doe",
            token: "token-with_special.chars123"
        )
        
        let user = dto.toDomain()
        
        #expect(user.email == "special+chars@example.com")
        #expect(user.name == "John O'Doe")
        #expect(user.token == "token-with_special.chars123")
    }
    
    @Test func toDomainWithDifferentIds() {
        let dto1 = UserDTO(id: 1, email: "user1@example.com", name: "User 1", token: "token1")
        let dto2 = UserDTO(id: 999, email: "user999@example.com", name: "User 999", token: "token999")
        
        let user1 = dto1.toDomain()
        let user2 = dto2.toDomain()
        
        #expect(user1.id == 1)
        #expect(user2.id == 999)
        #expect(user1.id != user2.id)
    }
}
