//
//  APIServices.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/2/26.
//

import SwiftUI
import Foundation

class APIService {
    private static var jwt: String? // Set once the user logs in
    
    // Fetch a single profile by user ID
    func fetchProfile(userID: String) async throws -> Profile {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/profiles/\(userID)")!
        // Step 2: make request
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, _) = try await URLSession.shared.data(for: request)
        // Step 3: decode JSON into our model
        let profile = try JSONDecoder().decode(Profile.self, from: data)
        
        return profile
    }
    
    func fetchUser(userID: String) async throws -> User {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/accounts/\(userID)")!
        // Step 2: make request
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, _) = try await URLSession.shared.data(for: request)
        let user = try JSONDecoder().decode(User.self, from: data)

        return user
    }
    
    // Fetch just the name of any user (used to label profiles in the swiper)
    func fetchName(userID: String) async throws -> String {
        let url = URL(string: "http://localhost:8080/names/\(userID)")!
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return String(data: data, encoding: .utf8) ?? ""
    }

    func fetchProfiles(userID: String) async throws -> [Profile] {
        let url = URL(string: "http://localhost:8080/feed/\(userID)")!
        // Step 2: make request
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let profiles = try JSONDecoder().decode([Profile].self, from: data)

        return profiles
    }
    
    func sendLikeOrDislike(swiperID: String, swipeeID: String, isLike: Bool) async throws {
        let url: URL
        if isLike {
            url = URL(string: "http://localhost:8080/feed/like/\(swiperID)/\(swipeeID)")!
        }
        else {
            url = URL(string: "http://localhost:8080/feed/dislike/\(swiperID)/\(swipeeID)")!
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if isLike {
            request.httpBody = try JSONEncoder().encode(Like(liker: swiperID, liked: swipeeID))
        }
        else {
            request.httpBody = try JSONEncoder().encode(Dislike(disliker: swiperID, disliked: swipeeID))
        }
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code:", httpResponse.statusCode)
            print("Response:", String(data: data, encoding: .utf8) ?? "No response body")

            guard 200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
        }
    }
    
    func updateProfile(profile: Profile) async throws {
            let url = URL(
                string: "http://localhost:8080/profiles"
            )!

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )

            request.httpBody = try JSONEncoder().encode(profile)
        
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
                print("Response:", String(data: data, encoding: .utf8) ?? "No response body")

                guard 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
            }
        }

    // Log in with email and password; returns the user's ID
    func login(email: String, password: String) async throws -> String {
        let url = URL(string: "http://localhost:8080/auth/\(email)/\(password)")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.userAuthenticationRequired)
        }
        storeToken(from: httpResponse)

        return String(data: data, encoding: .utf8) ?? ""
    }

    // Create a new account; the user is logged in right after
    func register(uuid: String, name: String, email: String, password: String) async throws {
        let url = URL(string: "http://localhost:8080/accounts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(Registration(uuid: uuid, name: name, email: email, password: password))

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        storeToken(from: httpResponse)
    }

    // Save the JWT the server sent back in the Authorization header
    private func storeToken(from response: HTTPURLResponse) {
        if let header = response.value(forHTTPHeaderField: "Authorization") {
            APIService.jwt = header.replacingOccurrences(of: "Bearer ", with: "")
        }
    }

    // Attach the JWT as a Bearer token if we have one
    private func authorize(_ request: inout URLRequest) {
        if let jwt = APIService.jwt {
            request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        }
    }
}

struct Like: Codable {
    let liker: String
    let liked: String
}

struct Dislike: Codable {
    let disliker: String
    let disliked: String
}

struct Registration: Codable {
    let uuid: String
    let name: String
    let email: String
    let password: String
}
