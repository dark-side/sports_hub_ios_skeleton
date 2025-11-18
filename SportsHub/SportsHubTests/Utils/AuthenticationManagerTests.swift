//
//  AuthenticationManagerTests.swift
//  SportsHubTests
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

@MainActor
struct AuthenticationManagerTests {
    
    @Test func initialStateNoUser() async {
        let mockRepo = MockAuthRepositoryForManager()
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        #expect(manager.currentUser == nil)
        #expect(!manager.isAuthenticated)
        #expect(mockRepo.getCurrentUserCallCount == 1)
    }
    
    @Test func initialStateWithUser() async {
        let mockUser = User(id: 1, email: "existing@example.com", name: "Existing User", token: "existing_token")
        let mockRepo = MockAuthRepositoryForManager()
        mockRepo.mockUser = mockUser
        
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        #expect(manager.currentUser != nil)
        #expect(manager.isAuthenticated)
        #expect(manager.currentUser?.email == "existing@example.com")
    }
    
    @Test func signInSuccess() async throws {
        let mockRepo = MockAuthRepositoryForManager()
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        #expect(!manager.isAuthenticated)
        
        try await manager.signIn(email: "test@example.com", password: "password123")
        
        #expect(manager.isAuthenticated)
        #expect(manager.currentUser != nil)
        #expect(manager.currentUser?.email == "test@example.com")
        #expect(manager.currentUser?.token == "test_token")
        #expect(mockRepo.signInCallCount == 1)
    }
    
    @Test func signInFailure() async throws {
        let mockRepo = MockAuthRepositoryForManager()
        mockRepo.shouldThrowError = true
        
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        do {
            try await manager.signIn(email: "wrong@example.com", password: "wrongpass")
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is AuthError)
            #expect(!manager.isAuthenticated)
            #expect(manager.currentUser == nil)
        }
    }
    
    @Test func signOutSuccess() async throws {
        let mockUser = User(id: 1, email: "signout@example.com", name: "Sign Out User", token: "token")
        let mockRepo = MockAuthRepositoryForManager()
        mockRepo.mockUser = mockUser
        
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        #expect(manager.isAuthenticated)
        
        try await manager.signOut()
        
        #expect(!manager.isAuthenticated)
        #expect(manager.currentUser == nil)
        #expect(mockRepo.signOutCallCount == 1)
    }
    
    @Test func signOutFailure() async throws {
        let mockUser = User(id: 1, email: "test@example.com", name: "Test", token: "token")
        let mockRepo = MockAuthRepositoryForManager()
        mockRepo.mockUser = mockUser
        mockRepo.shouldThrowError = true
        
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        #expect(manager.isAuthenticated)
        
        do {
            try await manager.signOut()
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is AuthError)
        }
    }
    
    @Test func signInThenSignOut() async throws {
        let mockRepo = MockAuthRepositoryForManager()
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        // Initial state
        #expect(!manager.isAuthenticated)
        
        // Sign in
        try await manager.signIn(email: "cycle@example.com", password: "password")
        #expect(manager.isAuthenticated)
        #expect(manager.currentUser?.email == "cycle@example.com")
        
        // Sign out
        try await manager.signOut()
        #expect(!manager.isAuthenticated)
        #expect(manager.currentUser == nil)
    }
    
    @Test func multipleSignIns() async throws {
        let mockRepo = MockAuthRepositoryForManager()
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        // First sign in
        try await manager.signIn(email: "user1@example.com", password: "pass1")
        #expect(manager.currentUser?.email == "user1@example.com")
        
        // Second sign in (replace user)
        try await manager.signIn(email: "user2@example.com", password: "pass2")
        #expect(manager.currentUser?.email == "user2@example.com")
        #expect(mockRepo.signInCallCount == 2)
    }
    
    @Test func isAuthenticatedReflectsCurrentUser() async {
        let mockRepo = MockAuthRepositoryForManager()
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        #expect(!manager.isAuthenticated)
        #expect(manager.currentUser == nil)
        
        // Manually update (simulating what happens during sign in)
        manager.currentUser = User(id: 1, email: "manual@example.com", name: "Manual", token: "token")
        manager.isAuthenticated = true
        
        #expect(manager.isAuthenticated)
        #expect(manager.currentUser != nil)
    }
    
    @Test func repositoryReference() async {
        let mockRepo = MockAuthRepositoryForManager()
        let manager = AuthenticationManager(authRepository: mockRepo)
        
        // Verify the manager holds the correct repository reference
        #expect(manager.authRepository is MockAuthRepositoryForManager)
    }
}

@MainActor
final class MockAuthRepositoryForManager: AuthRepository {
    var mockUser: User?
    var shouldThrowError = false
    var signInCallCount = 0
    var signOutCallCount = 0
    var getCurrentUserCallCount = 0

    func signIn(email: String, password: String) async throws -> User {
        signInCallCount += 1
        if shouldThrowError {
            throw AuthError.invalidCredentials
        }
        let user = User(id: 1, email: email, name: "Test User", token: "test_token")
        mockUser = user
        return user
    }

    func signOut() async throws {
        signOutCallCount += 1
        if shouldThrowError {
            throw AuthError.networkError
        }
        mockUser = nil
    }

    func getCurrentUser() -> User? {
        getCurrentUserCallCount += 1
        return mockUser
    }
}
