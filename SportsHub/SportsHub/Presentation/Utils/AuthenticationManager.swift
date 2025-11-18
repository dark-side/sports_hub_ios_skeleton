//
//  AuthenticationManager.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Combine

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.currentUser = authRepository.getCurrentUser()
        self.isAuthenticated = currentUser != nil
    }
    
    func signIn(email: String, password: String) async throws {
        let user = try await authRepository.signIn(email: email, password: password)
        currentUser = user
        isAuthenticated = true
    }
    
    func signOut() async throws {
        try await authRepository.signOut()
        currentUser = nil
        isAuthenticated = false
    }
}
