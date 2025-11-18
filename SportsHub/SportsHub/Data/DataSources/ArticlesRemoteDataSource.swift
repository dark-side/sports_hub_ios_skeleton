//
//  ArticlesRemoteDataSource.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

protocol ArticlesRemoteDataSource {
    func fetchArticles() async throws -> [ArticleDTO]
    func fetchArticleById(_ id: Int) async throws -> ArticleDTO
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
}
