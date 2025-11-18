//
//  GetArticleDetailUseCaseTests.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

struct GetArticleDetailUseCaseTests {
    
    @Test func executeSuccess() async throws {
        let mockArticle = Article(
            id: 1,
            title: "Detail Article",
            shortDescription: "Short",
            description: "Full description",
            imageUrl: URL(string: "https://example.com/image.jpg"),
            likes: 100,
            dislikes: 10,
            commentsCount: 20,
            comments: ["Comment 1", "Comment 2"],
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let mockRepo = MockArticlesRepositoryForUseCase()
        mockRepo.mockArticle = mockArticle
        
        let useCase = GetArticleDetailUseCase(repository: mockRepo)
        let result = try await useCase.execute(id: 1)
        
        #expect(result != nil)
        #expect(result?.id == 1)
        #expect(result?.title == "Detail Article")
        #expect(mockRepo.getArticleCallCount == 1)
        #expect(mockRepo.lastRequestedId == 1)
    }
    
    @Test func executeNotFound() async throws {
        let mockRepo = MockArticlesRepositoryForUseCase()
        mockRepo.mockArticle = nil
        
        let useCase = GetArticleDetailUseCase(repository: mockRepo)
        let result = try await useCase.execute(id: 999)
        
        #expect(result == nil)
    }
    
    @Test func executeFailure() async throws {
        let mockRepo = MockArticlesRepositoryForUseCase()
        mockRepo.shouldThrowError = true
        
        let useCase = GetArticleDetailUseCase(repository: mockRepo)
        
        do {
            _ = try await useCase.execute(id: 1)
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is NetworkError)
        }
    }
    
    @Test func executeDifferentIds() async throws {
        let mockRepo = MockArticlesRepositoryForUseCase()
        let useCase = GetArticleDetailUseCase(repository: mockRepo)
        
        mockRepo.mockArticle = Article(id: 5, title: "Article 5", shortDescription: "S", description: "D", imageUrl: nil, likes: 1, dislikes: 0, commentsCount: 0, comments: [], createdAt: Date(), updatedAt: Date())
        _ = try await useCase.execute(id: 5)
        #expect(mockRepo.lastRequestedId == 5)
        
        mockRepo.mockArticle = Article(id: 10, title: "Article 10", shortDescription: "S", description: "D", imageUrl: nil, likes: 1, dislikes: 0, commentsCount: 0, comments: [], createdAt: Date(), updatedAt: Date())
        _ = try await useCase.execute(id: 10)
        #expect(mockRepo.lastRequestedId == 10)
    }
}
