//
//  GetArticlesUseCaseTests.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

struct GetArticlesUseCaseTests {
    
    @Test func executeSuccess() async throws {
        let mockArticles = [
            Article(id: 1, title: "Article 1", shortDescription: "Desc", description: "Long", imageUrl: nil, likes: 5, dislikes: 1, commentsCount: 2, comments: [], createdAt: Date(), updatedAt: Date()),
            Article(id: 2, title: "Article 2", shortDescription: "Desc", description: "Long", imageUrl: nil, likes: 10, dislikes: 2, commentsCount: 5, comments: [], createdAt: Date(), updatedAt: Date())
        ]
        
        let mockRepo = MockArticlesRepositoryForUseCase()
        mockRepo.mockArticles = mockArticles
        
        let useCase = GetArticlesUseCase(repository: mockRepo)
        let result = try await useCase.execute()
        
        #expect(result.count == 2)
        #expect(result[0].id == 1)
        #expect(result[1].id == 2)
        #expect(mockRepo.fetchArticlesCallCount == 1)
    }
    
    @Test func executeFailure() async throws {
        let mockRepo = MockArticlesRepositoryForUseCase()
        mockRepo.shouldThrowError = true
        
        let useCase = GetArticlesUseCase(repository: mockRepo)
        
        do {
            _ = try await useCase.execute()
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is NetworkError)
        }
    }
    
    @Test func executeEmptyResult() async throws {
        let mockRepo = MockArticlesRepositoryForUseCase()
        mockRepo.mockArticles = []
        
        let useCase = GetArticlesUseCase(repository: mockRepo)
        let result = try await useCase.execute()
        
        #expect(result.isEmpty)
    }
}
