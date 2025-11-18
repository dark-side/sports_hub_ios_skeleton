//
//  AuthRepository.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

protocol AuthRepository {
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    func getCurrentUser() -> User?
}
