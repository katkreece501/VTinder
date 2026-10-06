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
        let response = try JSONDecoder().decode(ProfileResponse.self, from: data)
        
        return response.results
    }
    
    func fetchUser(userID: String) async throws -> User {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/users/\(userID)")!
        // Step 2: make request
        let (data, _) = try await URLSession.shared.data(from: url)
        // Step 3: decode JSON into our model
        let response = try JSONDecoder().decode(UserResponse.self, from: data)
        
        return response.results
    }
}
