//
//  GetArticleDetailUseCase.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

protocol GetArticleDetailUseCaseProtocol {
    func execute(id: Int) async throws -> Article?
}

final class GetArticleDetailUseCase: GetArticleDetailUseCaseProtocol {
    private let repository: ArticlesRepository
    
    init(repository: ArticlesRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> Article? {
        return try await repository.getArticle(by: id)
    }
}
