//
//  AuthRemoteDataSource.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

protocol AuthRemoteDataSource {
    func signIn(email: String, password: String) async throws -> UserDTO
    func signOut() async throws
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case networkError
    case unauthorized
    case decodingError(Error)
    case serverError(statusCode: Int, message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error occurred"
        case .unauthorized:
            return "Unauthorized access"
        case .decodingError(let underlying):
            return "Failed to parse response: \(underlying.localizedDescription)"
        case .serverError(let status, let message):
            return "Server error (\(status)): \(message)"
        }
    }
}
