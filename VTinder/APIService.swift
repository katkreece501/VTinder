//
//  APIServices.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/2/26.
//

import SwiftUI
import Foundation

class APIService {
    func fetchProfile() async throws -> Profile {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/profiles")!
        // Step 2: make request
        let (data, _) = try await URLSession.shared.data(from: url)
        // Step 3: decode JSON into our model
        let response = try JSONDecoder().decode(ProfileResponse.self, from: data)
        
        return response.results
    }
}
