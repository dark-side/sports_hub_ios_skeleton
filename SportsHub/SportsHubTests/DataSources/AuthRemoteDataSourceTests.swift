//
//  AuthRemoteDataSourceTests.swift
//  SportsHubTests
//
//  Created by Anton Poluboiarynov
//

import Foundation
import Testing
@testable import SportsHub

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: AuthError.networkError)
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    override func stopLoading() {}
}

@MainActor
@Suite(.serialized)
struct AuthRemoteDataSourceTests {
    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    @Test func signInSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            let json: [String: Any] = [
                "id": 10,
                "email": "tester@example.com",
                "name": "Tester",
                "authentication_token": "abc123"
            ]
            let data = try JSONSerialization.data(withJSONObject: json)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let session = makeSession()
        let ds = DefaultAuthRemoteDataSource(baseURL: URL(string: "http://example.com")!, urlSession: session)
        let dto = try await ds.signIn(email: "tester@example.com", password: "password")
        #expect(dto.email == "tester@example.com")
        #expect(dto.token == "abc123")
        #expect(dto.name == "Tester")
        #expect(dto.id == 10)
    }
    
    @Test func signInInvalidCredentials() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = Data("Unauthorized".utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let session = makeSession()
        let ds = DefaultAuthRemoteDataSource(baseURL: URL(string: "http://example.com")!, urlSession: session)
        do {
            _ = try await ds.signIn(email: "bad@example.com", password: "wrong")
            #expect(false, "Expected invalidCredentials error")
        } catch let error as AuthError {
            switch error {
            case .invalidCredentials:
                #expect(true)
            default:
                #expect(false, "Unexpected error: \(error)")
            }
        }
    }
    
    @Test func signInBadRequest() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = Data("Bad Request".utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let session = makeSession()
        let ds = DefaultAuthRemoteDataSource(baseURL: URL(string: "http://example.com")!, urlSession: session)
        do {
            _ = try await ds.signIn(email: "bad@example.com", password: "")
            #expect(false, "Expected invalidCredentials error")
        } catch let error as AuthError {
            switch error {
            case .invalidCredentials:
                #expect(true)
            default:
                #expect(false, "Unexpected error: \(error)")
            }
        }
    }
    
    @Test func signInServerError() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = Data("Internal Server Error".utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let session = makeSession()
        let ds = DefaultAuthRemoteDataSource(baseURL: URL(string: "http://example.com")!, urlSession: session)
        do {
            _ = try await ds.signIn(email: "test@example.com", password: "password")
            #expect(false, "Expected serverError")
        } catch let error as AuthError {
            switch error {
            case .serverError(let statusCode, let message):
                #expect(statusCode == 500)
                #expect(message == "Internal Server Error")
            default:
                #expect(false, "Unexpected error: \(error)")
            }
        }
    }
    
    @Test func signInDecodingError() async throws {
        MockURLProtocol.requestHandler = { request in
            let invalidJSON = Data("{ invalid json }".utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJSON)
        }
        let session = makeSession()
        let ds = DefaultAuthRemoteDataSource(baseURL: URL(string: "http://example.com")!, urlSession: session)
        do {
            _ = try await ds.signIn(email: "test@example.com", password: "password")
            #expect(false, "Expected decodingError")
        } catch let error as AuthError {
            switch error {
            case .decodingError:
                #expect(true)
            default:
                #expect(false, "Unexpected error: \(error)")
            }
        }
    }
    
    @Test func signInNetworkError() async throws {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        let session = makeSession()
        let ds = DefaultAuthRemoteDataSource(baseURL: URL(string: "http://example.com")!, urlSession: session)
        do {
            _ = try await ds.signIn(email: "test@example.com", password: "password")
            #expect(false, "Expected networkError")
        } catch let error as AuthError {
            switch error {
            case .networkError:
                #expect(true)
            default:
                #expect(false, "Unexpected error: \(error)")
            }
        }
    }
    
    @Test func signOutThrowsUnauthorized() async throws {
        let session = makeSession()
        let ds = DefaultAuthRemoteDataSource(baseURL: URL(string: "http://example.com")!, urlSession: session)
        do {
            try await ds.signOut()
            #expect(false, "Expected unauthorized error")
        } catch let error as AuthError {
            switch error {
            case .unauthorized:
                #expect(true)
            default:
                #expect(false, "Unexpected error: \(error)")
            }
        }
    }
}
