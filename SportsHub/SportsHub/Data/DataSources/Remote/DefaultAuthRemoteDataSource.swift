//
//  DefaultAuthRemoteDataSource.swift
//  SportsHub
//
//  Created by Anton Poluboiarynov
//

import Foundation

final class DefaultAuthRemoteDataSource: AuthRemoteDataSource {
	private let baseURL: URL
	private let urlSession: URLSession
	private let jsonDecoder: JSONDecoder
    
	init(
        baseURL: URL = ApiConfig.baseURL,
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = JSONDecoder()) {
		self.baseURL = baseURL
		self.urlSession = urlSession
		self.jsonDecoder = jsonDecoder
	}
    
	func signIn(email: String, password: String) async throws -> UserDTO {
		let url = baseURL.appendingPathComponent("api/auth/sign_in")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
		let payload = SignInPayload(user: SignInUser(email: email, password: password))
		request.httpBody = try JSONEncoder().encode(payload)
        
		let (data, response): (Data, URLResponse)
		do {
			(data, response) = try await urlSession.data(for: request)
		} catch {
			throw AuthError.networkError
		}
		
		guard let http = response as? HTTPURLResponse else { throw AuthError.networkError }
		switch http.statusCode {
		case 200, 201:
			do {
				return try jsonDecoder.decode(UserDTO.self, from: data)
			} catch {
				throw AuthError.decodingError(error)
			}
		case 400, 401:
			throw AuthError.invalidCredentials
		default:
			let message = String(data: data, encoding: .utf8) ?? "Unknown server error"
			throw AuthError.serverError(statusCode: http.statusCode, message: message)
		}
	}
    
	// Sign out path not documented yet; placeholder implementation until docs available.
	func signOut() async throws {
		throw AuthError.unauthorized
	}
}

// MARK: - Request Body Models
private struct SignInPayload: Encodable { let user: SignInUser }
private struct SignInUser: Encodable { let email: String; let password: String }
