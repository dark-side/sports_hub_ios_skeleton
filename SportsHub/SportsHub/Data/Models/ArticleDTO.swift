//
//  ArticleDTO.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

struct ArticleDTO: Codable {
    let id: Int
    let title: String
    let short_description: String
    let description: String
    let image_url: String?
    let article_likes: Int
    let article_dislikes: Int
    let comments_count: Int
    let comments_content: [String]
    let created_at: String
    let updated_at: String
    
    func toDomain() -> Article {
        let imageURL = URL(string: image_url ?? "")
        let dateFormatter = ISO8601DateFormatter()
        
        return Article(
            id: id,
            title: title,
            shortDescription: short_description,
            description: description,
            imageUrl: imageURL,
            likes: article_likes,
            dislikes: article_dislikes,
            commentsCount: comments_count,
            comments: comments_content,
            createdAt: dateFormatter.date(from: created_at) ?? Date(),
            updatedAt: dateFormatter.date(from: updated_at) ?? Date()
        )
    }
}
