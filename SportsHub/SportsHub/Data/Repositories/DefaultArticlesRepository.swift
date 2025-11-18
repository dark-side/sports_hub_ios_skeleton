//
//  DefaultArticlesRepository.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

class DefaultArticlesRepository: ArticlesRepository {
    private let remoteDataSource: ArticlesRemoteDataSource
    
    init(remoteDataSource: ArticlesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchArticles() async throws -> [Article] {
        let articleDTOs = try await remoteDataSource.fetchArticles()
        return articleDTOs.map { $0.toDomain() }
    }
    
    func getArticle(by id: Int) async throws -> Article? {
        let articleDTO = try await remoteDataSource.fetchArticleById(id)
        return articleDTO.toDomain()
    }
}
