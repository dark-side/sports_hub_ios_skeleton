//
//  DefaultAuthRepository.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

class DefaultAuthRepository: AuthRepository {
    private let remoteDataSource: AuthRemoteDataSource
    private var currentUser: User?
    
    init(remoteDataSource: AuthRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let userDTO = try await remoteDataSource.signIn(email: email, password: password)
        let user = userDTO.toDomain()
        currentUser = user
        return user
    }
    
    func signOut() async throws {
        try await remoteDataSource.signOut()
        currentUser = nil
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
}
