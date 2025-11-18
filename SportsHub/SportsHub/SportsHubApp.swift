//
//  SportsHubApp.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

@main
struct SportsHubApp: App {
    @StateObject private var authManager: AuthenticationManager
    
    init() {
        // Initialize auth dependencies
        let authRemoteDataSource: AuthRemoteDataSource = DefaultAuthRemoteDataSource()
        let authRepository = DefaultAuthRepository(remoteDataSource: authRemoteDataSource)
        _authManager = StateObject(wrappedValue: AuthenticationManager(authRepository: authRepository))
    }
    
    var body: some Scene {
        WindowGroup {
            // For development, use the mock data source
            let articlesRemoteDataSource = DefaultArticlesRemoteDataSource()
            let articlesRepository = DefaultArticlesRepository(remoteDataSource: articlesRemoteDataSource)
            let getArticlesUseCase = GetArticlesUseCase(repository: articlesRepository)
            let articlesViewModel = ArticlesViewModel(getArticlesUseCase: getArticlesUseCase)

            ArticlesListView(viewModel: articlesViewModel)
                .tint(Color.appPrimary)
                .environmentObject(authManager)
        }
    }
}
