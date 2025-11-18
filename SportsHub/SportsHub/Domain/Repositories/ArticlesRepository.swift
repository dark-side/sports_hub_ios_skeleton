//
//  ArticlesRepository.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

protocol ArticlesRepository {
    func fetchArticles() async throws -> [Article]
    func getArticle(by id: Int) async throws -> Article?
}
