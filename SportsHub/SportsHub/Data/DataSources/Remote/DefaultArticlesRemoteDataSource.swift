//
//  DefaultArticlesRemoteDataSource.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

class DefaultArticlesRemoteDataSource: ArticlesRemoteDataSource {
    private var apiPath: String = "api/articles"
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL = ApiConfig.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func fetchArticles() async throws -> [ArticleDTO] {
        let url = baseURL.appendingPathComponent(apiPath) 
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode([ArticleDTO].self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchArticleById(_ id: Int) async throws -> ArticleDTO {
        let url = baseURL.appendingPathComponent(apiPath).appendingPathComponent("\(id)")
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(ArticleDTO.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
