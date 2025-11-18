//
//  Article.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

struct Article: Identifiable, Equatable {
    let id: Int
    let title: String
    let shortDescription: String
    let description: String
    let imageUrl: URL?
    let likes: Int
    let dislikes: Int
    let commentsCount: Int
    let comments: [String]
    let createdAt: Date
    let updatedAt: Date
}
