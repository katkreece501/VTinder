//
//  DaterHomeView.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/8/26.
//

import SwiftUI

struct DaterHomeView: View {
    let apiService = APIService()
    @State private var user: User?
    @State private var profile: Profile?
    let currUserID: String
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user, let profile {
                    NavigationLink {
                        ProfileView(profile: profile, currUserID: currUserID, name: user.name)
                    } label: {
                        Label(
                            "My Profile",
                            systemImage: "person.crop.artframe"
                        )
                    }
                    NavigationLink {
                        ProfileSwiper(currUserID: currUserID)
                    } label: {
                        Label(
                            "Find Matches",
                            systemImage: "person.crop.square.on.square.angled"
                        )
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
            await loadProfileData()
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
