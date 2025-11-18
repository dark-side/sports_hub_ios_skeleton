//
//  DefaultAuthRepositoryTests.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

struct DefaultAuthRepositoryTests {
    
    @Test func signInSuccess() async throws {
        let mockDTO = UserDTO(id: 1, email: "test@example.com", name: "Test User", token: "abc123")
        
        let mockDataSource = MockAuthRemoteDataSourceForRepo()
        mockDataSource.mockUserDTO = mockDTO
        
        let repository = DefaultAuthRepository(remoteDataSource: mockDataSource)
        let user = try await repository.signIn(email: "test@example.com", password: "password")
        
        #expect(user.id == 1)
        #expect(user.email == "test@example.com")
        #expect(user.name == "Test User")
        #expect(user.token == "abc123")
        #expect(mockDataSource.signInCallCount == 1)
        #expect(mockDataSource.lastEmail == "test@example.com")
        #expect(mockDataSource.lastPassword == "password")
    }
    
    @Test func signInFailure() async throws {
        let mockDataSource = MockAuthRemoteDataSourceForRepo()
        mockDataSource.shouldThrowError = true
        
        let repository = DefaultAuthRepository(remoteDataSource: mockDataSource)
        
        do {
            _ = try await repository.signIn(email: "wrong@example.com", password: "wrong")
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is AuthError)
        }
    }
    
    @Test func signInStoresCurrentUser() async throws {
        let mockDTO = UserDTO(id: 2, email: "stored@example.com", name: "Stored User", token: "token123")
        
        let mockDataSource = MockAuthRemoteDataSourceForRepo()
        mockDataSource.mockUserDTO = mockDTO
        
        let repository = DefaultAuthRepository(remoteDataSource: mockDataSource)
        
        #expect(repository.getCurrentUser() == nil)
        
        _ = try await repository.signIn(email: "stored@example.com", password: "password")
        
        let currentUser = repository.getCurrentUser()
        #expect(currentUser != nil)
        #expect(currentUser?.email == "stored@example.com")
    }
    
    @Test func signOutSuccess() async throws {
        let mockDataSource = MockAuthRemoteDataSourceForRepo()
        let repository = DefaultAuthRepository(remoteDataSource: mockDataSource)
        
        // Sign in first
        _ = try await repository.signIn(email: "test@example.com", password: "password")
        #expect(repository.getCurrentUser() != nil)
        
        // Sign out
        try await repository.signOut()
        
        #expect(repository.getCurrentUser() == nil)
        #expect(mockDataSource.signOutCallCount == 1)
    }
    
    @Test func signOutFailure() async throws {
        let mockDataSource = MockAuthRemoteDataSourceForRepo()
        mockDataSource.shouldThrowError = true
        
        let repository = DefaultAuthRepository(remoteDataSource: mockDataSource)
        
        do {
            try await repository.signOut()
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is AuthError)
        }
    }
    
    @Test func getCurrentUserInitiallyNil() async {
        let mockDataSource = MockAuthRemoteDataSourceForRepo()
        let repository = DefaultAuthRepository(remoteDataSource: mockDataSource)
        
        #expect(repository.getCurrentUser() == nil)
    }
    
    @Test func userDTOToDomainMapping() async throws {
        let mockDTO = UserDTO(id: 5, email: "mapper@example.com", name: "Mapper User", token: "token_xyz")
        
        let mockDataSource = MockAuthRemoteDataSourceForRepo()
        mockDataSource.mockUserDTO = mockDTO
        
        let repository = DefaultAuthRepository(remoteDataSource: mockDataSource)
        let user = try await repository.signIn(email: "mapper@example.com", password: "password")
        
        #expect(user.id == 5)
        #expect(user.email == "mapper@example.com")
        #expect(user.name == "Mapper User")
        #expect(user.token == "token_xyz")
    }
}

final class MockAuthRemoteDataSourceForRepo: AuthRemoteDataSource {
    var mockUserDTO: UserDTO?
    var shouldThrowError = false
    var signInCallCount = 0
    var signOutCallCount = 0
    var lastEmail: String?
    var lastPassword: String?

    func signIn(email: String, password: String) async throws -> UserDTO {
        signInCallCount += 1
        lastEmail = email
        lastPassword = password

        if shouldThrowError {
            throw AuthError.invalidCredentials
        }

        return mockUserDTO ?? UserDTO(id: 1, email: email, name: "Test User", token: "test_token")
    }

    func signOut() async throws {
        signOutCallCount += 1
        if shouldThrowError {
            throw AuthError.networkError
        }
    }
}
