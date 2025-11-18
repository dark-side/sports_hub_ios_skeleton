//
//  MockAuthRemoteDataSource.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//


class MockAuthRemoteDataSource: AuthRemoteDataSource {
    func signIn(email: String, password: String) async throws -> UserDTO {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock validation
        if email.isEmpty || password.isEmpty {
            throw AuthError.invalidCredentials
        }
        
        // Return mock user
        return UserDTO(
            id: 1,
            email: email,
            name: "John Doe",
            token: "mock_token_12345"
        )
    }
    
    func signOut() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
