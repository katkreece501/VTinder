//
//  APIServices.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/2/26.
//

import SwiftUI
import Foundation

/*
 Holds all the methods that communicate with the API. This is a Functional paradigm. Although it is stored in a
 class, its focus is more on storing a bunch of functions then being a meaningful object.
 */
class APIService {
    private static var jwt: String? // Set once the user logs in
    
    /*
     Fetch a single profile by user ID.
     Note that Moderators can also see the profiles of banned users, but Daters can't.
     */
    func fetchProfile(userID: String) async throws -> Profile {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/profiles/\(userID)")!
        // Step 2: make request
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)
        /*
        if let responseString = String(data: data, encoding: .utf8) {
            print("Raw Response: \(responseString)")
        }
         */
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.userAuthenticationRequired)
        }
        // Step 3: decode JSON into our model
        let profile = try JSONDecoder().decode(Profile.self, from: data)
        
        return profile
    }
    
    /*
     Fetches a single user by their ID.
     */
    func fetchUser(userID: String) async throws -> User {
        // Step 1: create URL
        let url = URL(string: "http://localhost:8080/accounts/\(userID)")!
        // Step 2: make request
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let user = try JSONDecoder().decode(User.self, from: data)
        
        return user
    }
    
    /*
     Fetches all profiles that a specified user has not already swiped on. Also filters out the user's own profile.
     */
    func fetchProfiles(userID: String) async throws -> [Profile] {
        let url = URL(string: "http://localhost:8080/feed/\(userID)")!
        // Step 2: make request
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.userAuthenticationRequired)
        }
        let profiles = try JSONDecoder().decode([Profile].self, from: data)

        return profiles
    }
    
    /*
     Fetches all the profiles of the Daters that the user has matched with
     (i.e., the user has liked the Dater and the Dater has liked the user).
     Uses authentication token instead of passing in a single ID.
     */
    func fetchMatches() async throws -> [Profile] {
        let url = URL(string: "http://localhost:8080/chat")!
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.userAuthenticationRequired)
        }
        let matches = try JSONDecoder().decode([Profile].self, from: data)

        return matches
    }

    // Gets messages with a match (newest 20, 20 before beforeId, or everything after afterId)
    func fetchMessages(with uuid: String, beforeId: Int?, afterId: Int?) async throws -> [Message] {
        // Only add the id that was given
        var urlString: String = "http://localhost:8080/chat/\(uuid)"
        if let id: Int = beforeId {
            urlString += "?beforeId=\(id)"
        } else if let id: Int = afterId {
            urlString += "?afterId=\(id)"
        }
        let url: URL = URL(string: urlString)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        // timeout after 15 seconds
        request.timeoutInterval = 15
        authorize(&request)

        let result: (Data, URLResponse) = try await URLSession.shared.data(for: request)
        let data: Data = result.0
        let response: URLResponse = result.1

        // 403 here means the two users aren't matched
        guard let http: HTTPURLResponse = response as? HTTPURLResponse else {
            throw URLError(URLError.Code.badServerResponse)
        }
        if http.statusCode < 200 || http.statusCode > 299 {
            throw URLError(URLError.Code.badServerResponse)
        }

        // Turn the JSON into a list of messages
        let messages: [Message] = try JSONDecoder().decode([Message].self, from: data)
        return messages
    }

    // Sends a text message to a match
    func sendMessage(to uuid: String, text: String) async throws {
        let url: URL = URL(string: "http://localhost:8080/chat/\(uuid)")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        // timeout after 15 seconds
        request.timeoutInterval = 15
        // The server takes the message as plain text, not JSON
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(text.utf8)
        authorize(&request)

        let result: (Data, URLResponse) = try await URLSession.shared.data(for: request)
        let response: URLResponse = result.1

        guard let http: HTTPURLResponse = response as? HTTPURLResponse else {
            throw URLError(URLError.Code.badServerResponse)
        }
        if http.statusCode < 200 || http.statusCode > 299 {
            throw URLError(URLError.Code.badServerResponse)
        }
    }
    
    /*
     Sends a like or a dislike to the API, using a Boolean parameter to tell if its a like or dislike.
     */
    func sendLikeOrDislike(swiperID: String, swipeeID: String, isLike: Bool) async throws {
        let url: URL
        // Different URL based on whether this is a like or dislike
        if isLike {
            url = URL(string: "http://localhost:8080/feed/like/\(swiperID)/\(swipeeID)")!
        }
        else {
            url = URL(string: "http://localhost:8080/feed/dislike/\(swiperID)/\(swipeeID)")!
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Different encoding based on whether this is a like or dislike
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
    
    /*
     Rewrites profile data after an edit.
     */
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

    /*
     Sends a report about another user to the API.
     Note that we don't send who is reporting; the backend figures that out from the user's login.
     */
    func reportUser(uuid: String, reason: String) async throws {
        let url: URL = URL(string: "http://localhost:8080/reports/\(uuid)")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        // timeout after 15 seconds
        request.timeoutInterval = 15
        // The server takes the reason as plain text, not JSON
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(reason.utf8)
        authorize(&request)

        let result: (Data, URLResponse) = try await URLSession.shared.data(for: request)
        let response: URLResponse = result.1

        guard let http: HTTPURLResponse = response as? HTTPURLResponse else {
            throw URLError(URLError.Code.badServerResponse)
        }
        if http.statusCode < 200 || http.statusCode > 299 {
            throw URLError(URLError.Code.badServerResponse)
        }
    }

    /*
     Gets the profile of every user of the app. Only Moderators are allowed to do this.
     */
    func fetchAllProfiles() async throws -> [Profile] {
        let url = URL(string: "http://localhost:8080/profiles")!
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.userAuthenticationRequired)
        }
        let profiles = try JSONDecoder().decode([Profile].self, from: data)

        return profiles
    }

    /*
     Gets every report sent in by Daters, from newest to oldest. Only Moderators are allowed to do this.
     */
    func fetchReports() async throws -> [ReportRecord] {
        let url = URL(string: "http://localhost:8080/reports")!
        var request = URLRequest(url: url)
        authorize(&request)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.userAuthenticationRequired)
        }
        // The API sends dates in a format like 2026-11-16T06:52:06Z, so we have to tell the decoder how to read them
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let reports = try decoder.decode([ReportRecord].self, from: data)

        return reports
    }

    /*
     Deletes a report once it's been dealt with. Only Moderators are allowed to do this.
     */
    func deleteReport(id: Int) async throws {
        let url: URL = URL(string: "http://localhost:8080/reports/\(id)")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "DELETE"
        // timeout after 15 seconds
        request.timeoutInterval = 15
        authorize(&request)

        let result: (Data, URLResponse) = try await URLSession.shared.data(for: request)
        let response: URLResponse = result.1

        guard let http: HTTPURLResponse = response as? HTTPURLResponse else {
            throw URLError(URLError.Code.badServerResponse)
        }
        if http.statusCode < 200 || http.statusCode > 299 {
            throw URLError(URLError.Code.badServerResponse)
        }
    }

    /*
     Bans a user. Only Moderators are allowed to do this.
     Note that the backend refuses to ban other Moderators.
     */
    func banUser(uuid: String) async throws {
        let url: URL = URL(string: "http://localhost:8080/ban/\(uuid)")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        // timeout after 15 seconds
        request.timeoutInterval = 15
        authorize(&request)

        let result: (Data, URLResponse) = try await URLSession.shared.data(for: request)
        let response: URLResponse = result.1

        guard let http: HTTPURLResponse = response as? HTTPURLResponse else {
            throw URLError(URLError.Code.badServerResponse)
        }
        if http.statusCode < 200 || http.statusCode > 299 {
            throw URLError(URLError.Code.badServerResponse)
        }
    }

    /*
     Logs in with an email and password.
     Returns the user's ID and whether they're a Moderator, which decides which home screen they see.
     */
    func login(email: String, password: String) async throws -> LoginResult {
        let url = URL(string: "http://localhost:8080/auth/\(email)/\(password)")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        // The API sends back a 403 when the email and password are right but the user has been banned
        if httpResponse.statusCode == 403 {
            throw LoginError.banned
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw LoginError.invalidCredentials
        }
        storeToken(from: httpResponse)

        return try JSONDecoder().decode(LoginResult.self, from: data)
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

/*
 Below are various objects used to code data and errors. They are all examples of the Object-Orientated paradigm.
 */

/*
 What data is sent when a user likes another profile.
 */
struct Like: Codable {
    let liker: String
    let liked: String
}

/*
 What data is sent when a user dislikes another profile.
 */
struct Dislike: Codable {
    let disliker: String
    let disliked: String
}

/*
 Holds what the API sends back when a user logs in.
 */
struct LoginResult: Codable {
    let uuid: String // The unique ID of the user
    let isModerator: Bool // Whether the user is a Moderator or a Dater
}

/*
 The different reasons a login can fail, so the login screen can show the right message.
 */
enum LoginError: Error {
    case invalidCredentials // The email or password is wrong
    case banned // The email and password are right, but the user has been banned
}

/*
 What data is sent when a new user registers.
 */
struct Registration: Codable {
    let uuid: String
    let name: String
    let email: String
    let password: String
}
