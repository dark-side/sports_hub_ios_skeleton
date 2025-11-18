//
//  ArticlesListView.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import SwiftUI

struct ArticlesListView: View {
    @ObservedObject private var viewModel: ArticlesViewModel
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var navigationPath = NavigationPath()
    @State private var showingProfileMenu = false
    @State private var showingSignIn = false

    init(viewModel: ArticlesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                switch viewModel.loadingState {
                case .idle, .loading:
                    loadingView
                case .success:
                    contentView
                case .failure(let error):
                    failureView(error: error)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Sports Hub")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfileMenu = true
                    } label: {
                        Image(systemName: authManager.isAuthenticated ? "person.fill" : "person")
                            .font(.sectionTitle)
                    }
                    .popover(isPresented: $showingProfileMenu) {
                        if authManager.isAuthenticated {
                            profileMenu
                        } else {
                            signInMenu
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSignIn) {
                SignInView(
                    viewModel: SignInViewModel(
                        signInUseCase: SignInUseCase(repository: authManager.authRepository),
                        authManager: authManager,
                        onSignInSuccess: {
                            showingProfileMenu = false
                            showingSignIn = false
                        }
                    )
                )
            }
            .navigationDestination(for: Int.self) { articleId in
                if let article = viewModel.articles.first(where: { $0.id == articleId }) {
                    ArticleDetailView(
                        viewModel: ArticleDetailViewModel(
                            getArticleDetailUseCase: GetArticleDetailUseCase(
                                repository: DefaultArticlesRepository(
                                    remoteDataSource: MockArticlesRemoteDataSource()
                                )
                            )
                        ), articleId: article.id)
                }
            }
        }
    }

    var contentView: some View {
        List(viewModel.articles, id: \.id) { article in
            Button {
                navigationPath.append(article.id)
            } label: {
                ArticleRowView(article: article)
            }
            .buttonStyle(.plain)
        }
        .listStyle(PlainListStyle())
        .environment(\.defaultMinListRowHeight, 0)
        .listRowSeparator(.hidden)
    }

    var loadingView: some View {
        ProgressView("Loading articles...")
            .onAppear {
                Task {
                    await viewModel.loadArticles()
                }
            }
    }

    var profileMenu: some View {
        ProfileMenu(
            user: authManager.currentUser,
            onSignOut: {
                showingProfileMenu = false
                Task {
                    try? await authManager.signOut()
                }
            }
        )
        .presentationCompactAdaptation(.popover)
    }

    var signInMenu: some View {
        SignInMenu(
            onSignIn: {
                showingProfileMenu = false
                showingSignIn = true
            }
        )
        .presentationCompactAdaptation(.popover)
    }

    @ViewBuilder
    func failureView(error: String) -> some View {
        VStack(spacing: .spacingMedium) {
            Image(systemName: "exclamationmark.triangle")
                .font(.iconLarge)
                .foregroundColor(.appError)

            Text("Error loading articles")
                .font(.cardTitle)

            Text(error)
                .font(.subtitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()

            Button("Try Again") {
                Task {
                    await viewModel.loadArticles()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
