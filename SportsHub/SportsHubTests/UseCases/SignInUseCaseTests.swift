//
//  SignInUseCaseTests.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

struct SignInUseCaseTests {
    
    @Test func executeSuccess() async throws {
        let mockRepo = MockAuthRepositoryForUseCase()
        let useCase = SignInUseCase(repository: mockRepo)
        
        let result = try await useCase.execute(email: "test@example.com", password: "password123")
        
        #expect(result.email == "test@example.com")
        #expect(result.token == "test_token")
        #expect(mockRepo.signInCallCount == 1)
        #expect(mockRepo.lastEmail == "test@example.com")
        #expect(mockRepo.lastPassword == "password123")
    }
    
    @Test func executeFailureInvalidCredentials() async throws {
        let mockRepo = MockAuthRepositoryForUseCase()
        mockRepo.shouldThrowError = true
        
        let useCase = SignInUseCase(repository: mockRepo)
        
        do {
            _ = try await useCase.execute(email: "wrong@example.com", password: "wrongpass")
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is AuthError)
            if let authError = error as? AuthError {
                switch authError {
                case .invalidCredentials:
                    #expect(true)
                default:
                    #expect(false, "Expected invalidCredentials error")
                }
            }
        }
    }
    
    @Test func executeWithDifferentCredentials() async throws {
        let mockRepo = MockAuthRepositoryForUseCase()
        let useCase = SignInUseCase(repository: mockRepo)
        
        _ = try await useCase.execute(email: "user1@example.com", password: "pass1")
        #expect(mockRepo.lastEmail == "user1@example.com")
        #expect(mockRepo.lastPassword == "pass1")
        
        _ = try await useCase.execute(email: "user2@example.com", password: "pass2")
        #expect(mockRepo.lastEmail == "user2@example.com")
        #expect(mockRepo.lastPassword == "pass2")
        #expect(mockRepo.signInCallCount == 2)
    }
}
