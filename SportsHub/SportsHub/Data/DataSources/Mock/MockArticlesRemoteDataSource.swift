//
//  MockArticlesRemoteDataSource.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

class MockArticlesRemoteDataSource: ArticlesRemoteDataSource {

    let articles = [
        ArticleDTO(
            id: 1,
            title: "The Art of Scoring Goals",
            short_description: "Learn how to score goals like a pro with this comprehensive guide to the art of goal-scoring.",
            description: "This is the description of the article with title: The Art of Scoring Goals",
            image_url: "http://127.0.0.1:3002/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--068f058c623d882b86c3be1f83f02d9e5cf2554d/1.jpg",
            article_likes: 71,
            article_dislikes: 98,
            comments_count: 2,
            comments_content: [
                "This article was very informative and helpful.",
                "Great insights on goal-scoring!"
            ],
            created_at: "2025-02-06T20:41:01.530Z",
            updated_at: "2025-02-06T20:41:01.585Z"
        ),
        ArticleDTO(
            id: 2,
            title: "Nutrition for Athletes",
            short_description: "Discover the optimal nutrition strategies for peak athletic performance.",
            description: "Proper nutrition is essential for athletes. This article covers macronutrients, micronutrients, meal timing, and hydration strategies to maximize your athletic potential.",
            image_url: nil,
            article_likes: 120,
            article_dislikes: 15,
            comments_count: 3,
            comments_content: [
                "Changed my diet based on this and saw immediate improvements!",
                "I'd add that individual needs vary greatly.",
                "Could you do a follow-up on pre-competition meals?"
            ],
            created_at: "2025-02-05T14:22:30.000Z",
            updated_at: "2025-02-05T14:22:30.000Z"
        ),
        ArticleDTO(
            id: 3,
            title: "Mental Training for Sports Excellence",
            short_description: "The mind is as important as the body. Learn key mental strategies for sports performance.",
            description: "This comprehensive guide covers visualization techniques, focus training, stress management, and developing a growth mindset for athletic excellence.",
            image_url: nil,
            article_likes: 85,
            article_dislikes: 10,
            comments_count: 1,
            comments_content: [
                "The visualization techniques have totally transformed my game!"
            ],
            created_at: "2025-02-04T09:15:45.000Z",
            updated_at: "2025-02-04T09:15:45.000Z"
        )
    ]

    func fetchArticles() async throws -> [ArticleDTO] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Return mock data
        return articles
    }
    
    func fetchArticleById(_ id: Int) async throws -> ArticleDTO {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Find the article with matching ID
        guard let article = articles.first(where: { $0.id == id }) else {
            throw NetworkError.invalidStatusCode(404) // Not found
        }
        
        return article
    }
}
