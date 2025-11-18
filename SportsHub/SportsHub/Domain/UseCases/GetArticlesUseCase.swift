//
//  GetArticlesUseCase.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

protocol GetArticlesUseCaseProtocol {
    func execute() async throws -> [Article]
}

final class GetArticlesUseCase: GetArticlesUseCaseProtocol {
    private let repository: ArticlesRepository
    
    init(repository: ArticlesRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Article] {
        return try await repository.fetchArticles()
    }
}
