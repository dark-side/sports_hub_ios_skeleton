//
//  ArticlesViewModel.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import SwiftUI

enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success):
            return true
        case let (.failure(lhsError), .failure(rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

@MainActor
class ArticlesViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var loadingState: LoadingState = .idle
    
    private let getArticlesUseCase: GetArticlesUseCaseProtocol
    
    init(getArticlesUseCase: GetArticlesUseCaseProtocol) {
        self.getArticlesUseCase = getArticlesUseCase
    }
    
    func loadArticles() async {
        loadingState = .loading
        
        do {
            articles = try await getArticlesUseCase.execute()
            loadingState = .success
        } catch {
            loadingState = .failure(error.localizedDescription)
        }
    }
}
