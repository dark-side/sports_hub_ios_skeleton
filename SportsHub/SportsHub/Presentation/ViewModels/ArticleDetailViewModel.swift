//
//  ArticleDetailViewModel.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import SwiftUI

@MainActor
class ArticleDetailViewModel: ObservableObject {
    @Published private(set) var article: Article?
    @Published private(set) var loadingState: LoadingState = .idle
    
    private let getArticleDetailUseCase: GetArticleDetailUseCaseProtocol
    
    init(getArticleDetailUseCase: GetArticleDetailUseCaseProtocol) {
        self.getArticleDetailUseCase = getArticleDetailUseCase
    }
    
    func loadArticle(id: Int) async {
        loadingState = .loading
        
        do {
            article = try await getArticleDetailUseCase.execute(id: id)
            loadingState = article != nil ? .success : .failure("Article not found")
        } catch {
            loadingState = .failure(error.localizedDescription)
        }
    }
}
