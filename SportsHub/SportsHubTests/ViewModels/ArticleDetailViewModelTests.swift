//
//  ArticleDetailViewModelTests.swift
//  SportsHubTests
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

@MainActor
struct ArticleDetailViewModelTests {
    
    @Test func initialState() async {
        let mockUseCase = MockGetArticleDetailUseCase()
        let viewModel = ArticleDetailViewModel(getArticleDetailUseCase: mockUseCase)
        
        #expect(viewModel.article == nil)
        #expect(viewModel.loadingState == .idle)
    }
    
    @Test func loadArticleSuccess() async {
        let mockArticle = Article(
            id: 1,
            title: "Test Article",
            shortDescription: "Short",
            description: "Full description of the article",
            imageUrl: URL(string: "https://example.com/image.jpg"),
            likes: 100,
            dislikes: 5,
            commentsCount: 10,
            comments: ["Great article!", "Very informative"],
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let mockUseCase = MockGetArticleDetailUseCase()
        mockUseCase.mockArticle = mockArticle
        
        let viewModel = ArticleDetailViewModel(getArticleDetailUseCase: mockUseCase)
        
        await viewModel.loadArticle(id: 1)
        
        #expect(viewModel.loadingState == .success)
        #expect(viewModel.article != nil)
        #expect(viewModel.article?.id == 1)
        #expect(viewModel.article?.title == "Test Article")
        #expect(mockUseCase.executeCallCount == 1)
        #expect(mockUseCase.lastRequestedId == 1)
    }
    
    @Test func loadArticleNotFound() async {
        let mockUseCase = MockGetArticleDetailUseCase()
        mockUseCase.mockArticle = nil
        
        let viewModel = ArticleDetailViewModel(getArticleDetailUseCase: mockUseCase)
        
        await viewModel.loadArticle(id: 999)
        
        if case .failure(let error) = viewModel.loadingState {
            #expect(error == "Article not found")
        } else {
            #expect(false, "Expected failure state with 'Article not found' message")
        }
        #expect(viewModel.article == nil)
    }
    
    @Test func loadArticleFailure() async {
        let mockUseCase = MockGetArticleDetailUseCase()
        mockUseCase.shouldThrowError = true
        
        let viewModel = ArticleDetailViewModel(getArticleDetailUseCase: mockUseCase)
        
        await viewModel.loadArticle(id: 1)
        
        if case .failure(let error) = viewModel.loadingState {
            #expect(!error.isEmpty)
        } else {
            #expect(false, "Expected failure state")
        }
        #expect(viewModel.article == nil)
    }
    
    @Test func loadArticleWithComments() async {
        let mockArticle = Article(
            id: 5,
            title: "Article with Comments",
            shortDescription: "Short",
            description: "Description",
            imageUrl: nil,
            likes: 50,
            dislikes: 3,
            commentsCount: 3,
            comments: ["Comment 1", "Comment 2", "Comment 3"],
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let mockUseCase = MockGetArticleDetailUseCase()
        mockUseCase.mockArticle = mockArticle
        
        let viewModel = ArticleDetailViewModel(getArticleDetailUseCase: mockUseCase)
        
        await viewModel.loadArticle(id: 5)
        
        #expect(viewModel.article?.comments.count == 3)
        #expect(viewModel.article?.commentsCount == 3)
    }
    
    @Test func loadDifferentArticles() async {
        let mockUseCase = MockGetArticleDetailUseCase()
        let viewModel = ArticleDetailViewModel(getArticleDetailUseCase: mockUseCase)
        
        // Load first article
        mockUseCase.mockArticle = Article(id: 1, title: "First", shortDescription: "S", description: "D", imageUrl: nil, likes: 1, dislikes: 0, commentsCount: 0, comments: [], createdAt: Date(), updatedAt: Date())
        await viewModel.loadArticle(id: 1)
        #expect(viewModel.article?.id == 1)
        
        // Load second article
        mockUseCase.mockArticle = Article(id: 2, title: "Second", shortDescription: "S", description: "D", imageUrl: nil, likes: 2, dislikes: 0, commentsCount: 0, comments: [], createdAt: Date(), updatedAt: Date())
        await viewModel.loadArticle(id: 2)
        #expect(viewModel.article?.id == 2)
        #expect(mockUseCase.executeCallCount == 2)
    }
}

@MainActor
final class MockGetArticleDetailUseCase: GetArticleDetailUseCaseProtocol {
    var shouldThrowError = false
    var mockArticle: Article?
    var executeCallCount = 0
    var lastRequestedId: Int?

    func execute(id: Int) async throws -> Article? {
        executeCallCount += 1
        lastRequestedId = id

        if shouldThrowError {
            throw NetworkError.invalidStatusCode(404)
        }
        return mockArticle
    }
}
