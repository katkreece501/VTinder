//
//  UserClasses.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/25/26.
//

import SwiftUI
import Foundation

struct User: Codable {
    var name: String
    var uuid: String
    var email: String
    var isModerator: Bool
    
    init(name: String, email: String, isModerator: Bool) {
        self.name = name
        self.uuid = UUID().uuidString
        self.email = email
        self.isModerator = isModerator
    }
}

struct UserResponse: Codable {
    let results: User
}

struct UserHomeView: View {
    let apiService = APIService()
    @State private var user: User?
    @State private var profile: Profile?
    let currUserID: String
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user {
                    if let profile {
                        NavigationLink {
                            ProfileView(profile: profile, currUserID: currUserID, name: user.name)
                        } label: {
                            Label(
                                "My Profile",
                                systemImage: "person.crop.artframe"
                            )
                        }
                        .task {
                            await loadProfileData()
                        }
                    }
                } else {
                    ProgressView("Loading...")
                        .navigationTitle("Loading...")
                }
            }
            .navigationTitle("Welcome to VTinder!")
        }
        .task {
            await loadUserData()
        }
    }
func loadUserData() async {
    do {
        user = try await apiService.fetchUser(userID: currUserID)
    } catch {
        print("Error: \(error)")
    }
}
    func loadProfileData() async {
        do {
            profile = try await apiService.fetchProfile(userID: currUserID)
        } catch {
            print("Error: \(error)")
        }
    }
}
