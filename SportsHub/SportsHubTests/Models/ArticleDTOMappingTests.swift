//
//  ArticleDTOMappingTests.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

struct ArticleDTOMappingTests {
    
    @Test func toDomainBasicMapping() {
        let dto = ArticleDTO(
            id: 1,
            title: "Test Article",
            short_description: "Short description",
            description: "Full description",
            image_url: "https://example.com/image.jpg",
            article_likes: 100,
            article_dislikes: 10,
            comments_count: 5,
            comments_content: ["Comment 1", "Comment 2"],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )
        
        let article = dto.toDomain()
        
        #expect(article.id == 1)
        #expect(article.title == "Test Article")
        #expect(article.shortDescription == "Short description")
        #expect(article.description == "Full description")
        #expect(article.likes == 100)
        #expect(article.dislikes == 10)
        #expect(article.commentsCount == 5)
        #expect(article.comments.count == 2)
        #expect(article.comments[0] == "Comment 1")
    }
    
    @Test func toDomainWithValidImageURL() {
        let dto = ArticleDTO(
            id: 2,
            title: "Image Test",
            short_description: "Short",
            description: "Full",
            image_url: "https://example.com/test.jpg",
            article_likes: 50,
            article_dislikes: 5,
            comments_count: 3,
            comments_content: [],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )
        
        let article = dto.toDomain()
        
        #expect(article.imageUrl != nil)
        #expect(article.imageUrl?.absoluteString == "https://example.com/test.jpg")
    }
    
    @Test func toDomainWithNilImageURL() {
        let dto = ArticleDTO(
            id: 3,
            title: "No Image",
            short_description: "Short",
            description: "Full",
            image_url: nil,
            article_likes: 20,
            article_dislikes: 2,
            comments_count: 1,
            comments_content: [],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )
        
        let article = dto.toDomain()
        
        #expect(article.imageUrl == nil)
    }
    
    @Test func toDomainWithInvalidImageURL() {
        let dto = ArticleDTO(
            id: 4,
            title: "Invalid Image",
            short_description: "Short",
            description: "Full",
            image_url: "",
            article_likes: 30,
            article_dislikes: 3,
            comments_count: 2,
            comments_content: [],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )
        
        let article = dto.toDomain()
        
        #expect(article.imageUrl == nil)
    }
    
    @Test func toDomainWithEmptyComments() {
        let dto = ArticleDTO(
            id: 5,
            title: "No Comments",
            short_description: "Short",
            description: "Full",
            image_url: nil,
            article_likes: 15,
            article_dislikes: 1,
            comments_count: 0,
            comments_content: [],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )
        
        let article = dto.toDomain()
        
        #expect(article.comments.isEmpty)
        #expect(article.commentsCount == 0)
    }
    
    @Test func toDomainWithMultipleComments() {
        let comments = ["Comment 1", "Comment 2", "Comment 3", "Comment 4", "Comment 5"]
        let dto = ArticleDTO(
            id: 6,
            title: "Many Comments",
            short_description: "Short",
            description: "Full",
            image_url: nil,
            article_likes: 200,
            article_dislikes: 20,
            comments_count: 5,
            comments_content: comments,
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )
        
        let article = dto.toDomain()
        
        #expect(article.comments.count == 5)
        #expect(article.commentsCount == 5)
    }
    
    @Test func toDomainDateParsing() {
        let dto = ArticleDTO(
            id: 7,
            title: "Date Test",
            short_description: "Short",
            description: "Full",
            image_url: nil,
            article_likes: 10,
            article_dislikes: 1,
            comments_count: 0,
            comments_content: [],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T21:00:00.000Z"
        )
        
        let article = dto.toDomain()
        
        // Dates should be parsed successfully
        #expect(article.createdAt != Date())
        #expect(article.updatedAt != Date())
    }
    
    @Test func toDomainWithZeroLikesAndDislikes() {
        let dto = ArticleDTO(
            id: 8,
            title: "No Engagement",
            short_description: "Short",
            description: "Full",
            image_url: nil,
            article_likes: 0,
            article_dislikes: 0,
            comments_count: 0,
            comments_content: [],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        )
        
        let article = dto.toDomain()
        
        #expect(article.likes == 0)
        #expect(article.dislikes == 0)
    }
}
