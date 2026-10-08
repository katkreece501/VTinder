//
//  APIServices.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/2/26.
//

import SwiftUI
import Foundation

class APIService {
    // Fetch a single profile by user ID
    func fetchProfile(userID: String) async throws -> Profile {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/profiles/\(userID)")!
        // Step 2: make request
        let (data, _) = try await URLSession.shared.data(from: url)
        // Step 3: decode JSON into our model
        let profile = try JSONDecoder().decode(Profile.self, from: data)
        
        return profile
    }
    
    func fetchUser(userID: String) async throws -> User {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/accounts/\(userID)")!
        // Step 2: make request
        let (data, _) = try await URLSession.shared.data(from: url)
        let user = try JSONDecoder().decode(User.self, from: data)

        return user
    }
    
    func fetchProfiles(userID: String) async throws -> [Profile] {
        let url = URL(string: "http://localhost:8080/feed/\(userID)")!
        // Step 2: make request
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let profiles = try JSONDecoder().decode([Profile].self, from: data)

        return profiles
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
        /*
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
         */
        let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
                print("Response:", String(data: data, encoding: .utf8) ?? "No response body")

                guard 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
            }
        }
}
