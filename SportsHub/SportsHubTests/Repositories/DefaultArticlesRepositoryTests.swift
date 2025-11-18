//
//  DefaultArticlesRepositoryTests.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

struct DefaultArticlesRepositoryTests {

    @Test func fetchArticlesSuccess() async throws {
        let mockDTOs = [
            ArticleDTO(
                id: 1,
                title: "Article 1",
                short_description: "Short 1",
                description: "Description 1",
                image_url: nil,
                article_likes: 10,
                article_dislikes: 2,
                comments_count: 5,
                comments_content: ["Comment 1"],
                created_at: "2025-02-06T20:41:01.530Z",
                updated_at: "2025-02-06T20:41:01.585Z"
            ),
            ArticleDTO(
                id: 2,
                title: "Article 2",
                short_description: "Short 2",
                description: "Description 2",
                image_url: "https://example.com/image.jpg",
                article_likes: 20,
                article_dislikes: 3,
                comments_count: 10,
                comments_content: ["Comment 1", "Comment 2"],
                created_at: "2025-02-05T14:22:30.000Z",
                updated_at: "2025-02-05T14:22:30.000Z"
            )
        ]

        let mockDataSource = MockArticlesRemoteDataSourceForRepo()
        mockDataSource.mockArticleDTOs = mockDTOs

        let repository = DefaultArticlesRepository(remoteDataSource: mockDataSource)
        let articles = try await repository.fetchArticles()

        #expect(articles.count == 2)
        #expect(articles[0].id == 1)
        #expect(articles[0].title == "Article 1")
        #expect(articles[1].id == 2)
        #expect(articles[1].title == "Article 2")
        #expect(mockDataSource.fetchArticlesCallCount == 1)
    }

    @Test func fetchArticlesEmpty() async throws {
        let mockDataSource = MockArticlesRemoteDataSourceForRepo()
        mockDataSource.mockArticleDTOs = []

        let repository = DefaultArticlesRepository(remoteDataSource: mockDataSource)
        let articles = try await repository.fetchArticles()

        #expect(articles.isEmpty)
    }

    @Test func fetchArticlesFailure() async throws {
        let mockDataSource = MockArticlesRemoteDataSourceForRepo()
        mockDataSource.shouldThrowError = true

        let repository = DefaultArticlesRepository(remoteDataSource: mockDataSource)

        do {
            _ = try await repository.fetchArticles()
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is NetworkError)
        }
    }

    @Test func getArticleByIdSuccess() async throws {
        let mockDTO = ArticleDTO(
            id: 5,
            title: "Article 5",
            short_description: "Short",
            description: "Full description",
            image_url: "https://example.com/image.jpg",
            article_likes: 50,
            article_dislikes: 5,
            comments_count: 15,
            comments_content: ["Great!", "Nice article"],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )

        let mockDataSource = MockArticlesRemoteDataSourceForRepo()
        mockDataSource.mockArticleDTO = mockDTO

        let repository = DefaultArticlesRepository(remoteDataSource: mockDataSource)
        let article = try await repository.getArticle(by: 5)

        #expect(article != nil)
        #expect(article?.id == 5)
        #expect(article?.title == "Article 5")
        #expect(article?.comments.count == 2)
        #expect(mockDataSource.fetchArticleByIdCallCount == 1)
        #expect(mockDataSource.lastRequestedId == 5)
    }

    @Test func getArticleByIdFailure() async throws {
        let mockDataSource = MockArticlesRemoteDataSourceForRepo()
        mockDataSource.shouldThrowError = true

        let repository = DefaultArticlesRepository(remoteDataSource: mockDataSource)

        do {
            _ = try await repository.getArticle(by: 999)
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is NetworkError)
        }
    }

    @Test func articleDTOToDomainMapping() async throws {
        let mockDTO = ArticleDTO(
            id: 10,
            title: "Mapping Test",
            short_description: "Short desc",
            description: "Full desc",
            image_url: "https://example.com/test.jpg",
            article_likes: 100,
            article_dislikes: 10,
            comments_count: 5,
            comments_content: ["A", "B", "C"],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )

        let mockDataSource = MockArticlesRemoteDataSourceForRepo()
        mockDataSource.mockArticleDTO = mockDTO

        let repository = DefaultArticlesRepository(remoteDataSource: mockDataSource)
        let article = try await repository.getArticle(by: 10)

        #expect(article?.shortDescription == "Short desc")
        #expect(article?.description == "Full desc")
        #expect(article?.likes == 100)
        #expect(article?.dislikes == 10)
        #expect(article?.commentsCount == 5)
        #expect(article?.imageUrl?.absoluteString == "https://example.com/test.jpg")
    }
}

final class MockArticlesRemoteDataSourceForRepo: ArticlesRemoteDataSource {
    var mockArticleDTOs: [ArticleDTO] = []
    var mockArticleDTO: ArticleDTO?
    var shouldThrowError = false
    var fetchArticlesCallCount = 0
    var fetchArticleByIdCallCount = 0
    var lastRequestedId: Int?
    
    func fetchArticles() async throws -> [ArticleDTO] {
        fetchArticlesCallCount += 1
        if shouldThrowError {
            throw NetworkError.invalidResponse
        }
        return mockArticleDTOs
    }
    
    func fetchArticleById(_ id: Int) async throws -> ArticleDTO {
        fetchArticleByIdCallCount += 1
        lastRequestedId = id
        if shouldThrowError {
            throw NetworkError.invalidStatusCode(404)
        }
        guard let dto = mockArticleDTO else {
            throw NetworkError.invalidStatusCode(404)
        }
        return dto
    }
}
