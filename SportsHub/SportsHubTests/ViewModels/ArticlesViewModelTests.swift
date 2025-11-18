//
//  ArticlesViewModelTests.swift
//  SportsHubTests
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

@MainActor
struct ArticlesViewModelTests {
    
    @Test func initialState() async {
        let mockUseCase = MockGetArticlesUseCase()
        let viewModel = ArticlesViewModel(getArticlesUseCase: mockUseCase)
        
        #expect(viewModel.articles.isEmpty)
        #expect(viewModel.loadingState == .idle)
    }
    
    @Test func loadArticlesSuccess() async {
        let mockArticles = [
            Article(
                id: 1,
                title: "Test Article",
                shortDescription: "Short",
                description: "Long description",
                imageUrl: nil,
                likes: 10,
                dislikes: 2,
                commentsCount: 5,
                comments: ["Great!"],
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
        
        let mockUseCase = MockGetArticlesUseCase()
        mockUseCase.mockArticles = mockArticles
        
        let viewModel = ArticlesViewModel(getArticlesUseCase: mockUseCase)
        
        await viewModel.loadArticles()
        
        #expect(viewModel.loadingState == .success)
        #expect(viewModel.articles.count == 1)
        #expect(viewModel.articles.first?.title == "Test Article")
        #expect(mockUseCase.executeCallCount == 1)
    }
    
    @Test func loadArticlesFailure() async {
        let mockUseCase = MockGetArticlesUseCase()
        mockUseCase.shouldThrowError = true
        
        let viewModel = ArticlesViewModel(getArticlesUseCase: mockUseCase)
        
        await viewModel.loadArticles()
        
        if case .failure(let error) = viewModel.loadingState {
            #expect(!error.isEmpty)
        } else {
            #expect(false, "Expected failure state")
        }
        #expect(viewModel.articles.isEmpty)
    }
    
    @Test func loadArticlesEmptyResult() async {
        let mockUseCase = MockGetArticlesUseCase()
        mockUseCase.mockArticles = []
        
        let viewModel = ArticlesViewModel(getArticlesUseCase: mockUseCase)
        
        await viewModel.loadArticles()
        
        #expect(viewModel.loadingState == .success)
        #expect(viewModel.articles.isEmpty)
    }
    
    @Test func loadArticlesMultiple() async {
        let mockArticles = [
            Article(id: 1, title: "Article 1", shortDescription: "Desc1", description: "Long1", imageUrl: nil, likes: 5, dislikes: 1, commentsCount: 3, comments: [], createdAt: Date(), updatedAt: Date()),
            Article(id: 2, title: "Article 2", shortDescription: "Desc2", description: "Long2", imageUrl: nil, likes: 10, dislikes: 2, commentsCount: 7, comments: [], createdAt: Date(), updatedAt: Date()),
            Article(id: 3, title: "Article 3", shortDescription: "Desc3", description: "Long3", imageUrl: nil, likes: 15, dislikes: 3, commentsCount: 10, comments: [], createdAt: Date(), updatedAt: Date())
        ]
        
        let mockUseCase = MockGetArticlesUseCase()
        mockUseCase.mockArticles = mockArticles
        
        let viewModel = ArticlesViewModel(getArticlesUseCase: mockUseCase)
        
        await viewModel.loadArticles()
        
        #expect(viewModel.articles.count == 3)
        #expect(viewModel.articles[0].id == 1)
        #expect(viewModel.articles[1].id == 2)
        #expect(viewModel.articles[2].id == 3)
    }
}

@MainActor
final class MockGetArticlesUseCase: GetArticlesUseCaseProtocol {
    var shouldThrowError = false
    var mockArticles: [Article] = []
    var executeCallCount = 0

    func execute() async throws -> [Article] {
        executeCallCount += 1
        if shouldThrowError {
            throw NetworkError.invalidResponse
        }
        return mockArticles
    }
}
