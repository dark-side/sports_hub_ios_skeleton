//
//  ArticleDetailView.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct ArticleDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: ArticleDetailViewModel
    private let articleId: Int

    init(viewModel: ArticleDetailViewModel, articleId: Int) {
        self.viewModel = viewModel
        self.articleId = articleId
    }

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                loadingView
            case .success:
                if let article = viewModel.article {
                    ArticleDetailContent(article: article)
                } else {
                    Text("Article not found")
                        .font(.cardTitle)
                        .foregroundColor(.appError)
                }
            case .failure(let error):
                failureView(error: error)
            }
        }
        .navigationTitle(viewModel.article?.title ?? "Article Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }

    private var loadingView: some View {
        ProgressView("Loading article details...")
            .onAppear {
                Task {
                    await viewModel.loadArticle(id: articleId)
                }
            }
    }

    @ViewBuilder
    func failureView(error: String) -> some View {
        VStack(spacing: .spacingMedium) {
            Image(systemName: "exclamationmark.triangle")
                .font(.iconLarge)
                .foregroundColor(.appError)

            Text("Error loading article")
                .font(.cardTitle)

            Text(error)
                .font(.subtitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()

            Button("Try Again") {
                Task {
                    await viewModel.loadArticle(id: articleId)
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
