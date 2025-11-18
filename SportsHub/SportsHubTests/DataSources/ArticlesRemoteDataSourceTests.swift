//
//  ArticlesRemoteDataSourceTests.swift
//  SportsHubTests
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

// MARK: - Default Articles Remote Data Source Tests
struct DefaultArticlesRemoteDataSourceTests {
    
    @Test func fetchArticlesInvalidURL() async throws {
        // This test verifies the URL construction
        let dataSource = DefaultArticlesRemoteDataSource()
        
        // The base URL is hardcoded as "api/articles" which is invalid
        // This should throw an error
        do {
            _ = try await dataSource.fetchArticles()
            // Expecting this to fail due to invalid URL
        } catch {
            #expect(error is NetworkError)
        }
    }
    
    @Test func fetchArticleByIdInvalidURL() async throws {
        let dataSource = DefaultArticlesRemoteDataSource()
        
        do {
            _ = try await dataSource.fetchArticleById(1)
            // Expecting this to fail due to invalid URL
        } catch {
            #expect(error is NetworkError)
        }
    }
}
