//
//  UseCasesTests.swift
//  SportsHubTests
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

final class MockArticlesRepositoryForUseCase: ArticlesRepository {
    var mockArticles: [Article] = []
    var mockArticle: Article?
    var shouldThrowError = false
    var fetchArticlesCallCount = 0
    var getArticleCallCount = 0
    var lastRequestedId: Int?
    
    func fetchArticles() async throws -> [Article] {
        fetchArticlesCallCount += 1
        if shouldThrowError {
            throw NetworkError.invalidResponse
        }
        return mockArticles
    }
    
    func getArticle(by id: Int) async throws -> Article? {
        getArticleCallCount += 1
        lastRequestedId = id
        if shouldThrowError {
            throw NetworkError.invalidStatusCode(404)
        }
        return mockArticle
    }
}

final class MockAuthRepositoryForUseCase: AuthRepository {
    var mockUser: User?
    var shouldThrowError = false
    var signInCallCount = 0
    var signOutCallCount = 0
    var lastEmail: String?
    var lastPassword: String?
    
    func signIn(email: String, password: String) async throws -> User {
        signInCallCount += 1
        lastEmail = email
        lastPassword = password
        
        if shouldThrowError {
            throw AuthError.invalidCredentials
        }
        
        return mockUser ?? User(id: 1, email: email, name: "Test User", token: "test_token")
    }
    
    func signOut() async throws {
        signOutCallCount += 1
        if shouldThrowError {
            throw AuthError.networkError
        }
    }
    
    func getCurrentUser() -> User? {
        return mockUser
    }
}
