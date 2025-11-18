//
//  SignInUseCase.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

class SignInUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws -> User {
        return try await repository.signIn(email: email, password: password)
    }
}
