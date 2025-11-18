//
//  SignInViewModel.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Combine

@MainActor
class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authManager: AuthenticationManager?
    private let signInUseCase: SignInUseCase
    var onSignInSuccess: (() -> Void)?
    
    init(signInUseCase: SignInUseCase, authManager: AuthenticationManager? = nil, onSignInSuccess: (() -> Void)? = nil) {
        self.signInUseCase = signInUseCase
        self.authManager = authManager
        self.onSignInSuccess = onSignInSuccess
    }
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && email.contains("@")
    }
    
    func signIn() async {
        guard isFormValid else {
            errorMessage = "Please enter a valid email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            if let authManager = authManager {
                try await authManager.signIn(email: email, password: password)
            } else {
                _ = try await signInUseCase.execute(email: email, password: password)
            }
            onSignInSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
