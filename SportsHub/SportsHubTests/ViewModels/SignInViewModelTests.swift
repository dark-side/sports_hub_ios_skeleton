//
//  SignInViewModelTests.swift
//  SportsHubTests
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

@MainActor
struct SignInViewModelTests {
    
    @Test func initialState() async {
        let mockRepo = MockAuthRepository()
        let useCase = SignInUseCase(repository: mockRepo)
        let viewModel = SignInViewModel(signInUseCase: useCase)
        
        #expect(viewModel.email.isEmpty)
        #expect(viewModel.password.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(!viewModel.isFormValid)
    }
    
    @Test func formValidationValidEmail() async {
        let mockRepo = MockAuthRepository()
        let useCase = SignInUseCase(repository: mockRepo)
        let viewModel = SignInViewModel(signInUseCase: useCase)
        
        viewModel.email = "user@example.com"
        viewModel.password = "password123"
        
        #expect(viewModel.isFormValid)
    }
    
    @Test func formValidationInvalidEmail() async {
        let mockRepo = MockAuthRepository()
        let useCase = SignInUseCase(repository: mockRepo)
        let viewModel = SignInViewModel(signInUseCase: useCase)
        
        viewModel.email = "invalid-email"
        viewModel.password = "password123"
        
        #expect(!viewModel.isFormValid)
    }
    
    @Test func formValidationEmptyFields() async {
        let mockRepo = MockAuthRepository()
        let useCase = SignInUseCase(repository: mockRepo)
        let viewModel = SignInViewModel(signInUseCase: useCase)
        
        viewModel.email = ""
        viewModel.password = ""
        
        #expect(!viewModel.isFormValid)
    }
    
    @Test func formValidationEmptyPassword() async {
        let mockRepo = MockAuthRepository()
        let useCase = SignInUseCase(repository: mockRepo)
        let viewModel = SignInViewModel(signInUseCase: useCase)
        
        viewModel.email = "user@example.com"
        viewModel.password = ""
        
        #expect(!viewModel.isFormValid)
    }
    
    @Test func signInSuccess() async {
        let mockRepo = MockAuthRepository()
        let useCase = SignInUseCase(repository: mockRepo)
        var successCalled = false
        let viewModel = SignInViewModel(
            signInUseCase: useCase,
            onSignInSuccess: { successCalled = true }
        )
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        await viewModel.signIn()
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(successCalled)
        #expect(mockRepo.signInCallCount == 1)
    }
    
    @Test func signInFailureInvalidCredentials() async {
        let mockRepo = MockAuthRepository()
        mockRepo.shouldThrowError = true
        let useCase = SignInUseCase(repository: mockRepo)
        
        let viewModel = SignInViewModel(signInUseCase: useCase)
        viewModel.email = "wrong@example.com"
        viewModel.password = "wrongpass"
        
        await viewModel.signIn()
        
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage == "Invalid email or password")
    }
    
    @Test func signInWithInvalidForm() async {
        let mockRepo = MockAuthRepository()
        let useCase = SignInUseCase(repository: mockRepo)
        let viewModel = SignInViewModel(signInUseCase: useCase)
        
        viewModel.email = "invalid-email"
        viewModel.password = "pass"
        
        await viewModel.signIn()
        
        #expect(viewModel.errorMessage == "Please enter a valid email and password")
        #expect(mockRepo.signInCallCount == 0)
    }
    
    @Test func signInWithAuthManager() async {
        let mockRepo = MockAuthRepository()
        let authManager = AuthenticationManager(authRepository: mockRepo)
        let useCase = SignInUseCase(repository: mockRepo)
        
        var successCalled = false
        let viewModel = SignInViewModel(
            signInUseCase: useCase,
            authManager: authManager,
            onSignInSuccess: { successCalled = true }
        )
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        await viewModel.signIn()
        
        #expect(authManager.isAuthenticated)
        #expect(authManager.currentUser != nil)
        #expect(successCalled)
    }
    
    @Test func clearError() async {
        let mockRepo = MockAuthRepository()
        mockRepo.shouldThrowError = true
        let useCase = SignInUseCase(repository: mockRepo)
        let viewModel = SignInViewModel(signInUseCase: useCase)
        
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        
        await viewModel.signIn()
        #expect(viewModel.errorMessage != nil)
        
        viewModel.clearError()
        #expect(viewModel.errorMessage == nil)
    }
}

@MainActor
final class MockSignInUseCase: SignInUseCase {
    var shouldThrowError = false
    var mockUser: User?
    var executeCallCount = 0
    var lastEmail: String?
    var lastPassword: String?

    override func execute(email: String, password: String) async throws -> User {
        executeCallCount += 1
        lastEmail = email
        lastPassword = password

        if shouldThrowError {
            throw AuthError.invalidCredentials
        }

        return mockUser ?? User(id: 1, email: email, name: "Mock User", token: "mock_token")
    }
}

@MainActor
final class MockAuthRepository: AuthRepository {
    var mockUser: User?
    var shouldThrowError = false
    var signInCallCount = 0
    var signOutCallCount = 0

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
        mockUser = nil
    }

    func getCurrentUser() -> User? {
        return mockUser
    }
}
