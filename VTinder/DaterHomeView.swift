//
//  DaterHomeView.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/8/26.
//

import SwiftUI

struct DaterHomeView: View {
    let apiService = APIService()
    @State private var profile: Profile?
    let currUserID: String
    
    var body: some View {
        TabView {
            Tab("My Profile", systemImage: "person.crop.artframe") {
                NavigationStack {
                    if let profile {
                        ProfileView(profile: profile, currUserID: currUserID)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    NavigationLink("Edit") {
                                        ProfileEditor(profile: profile)
                                    }
                                }
                            }
                            .navigationTitle("My Profile")
                    }
                    else {
                        ProgressView("Loading...")
                    }
                }
            }
            Tab("Swipe", systemImage: "person.crop.square.on.square.angled") {
                NavigationStack {
                    ProfileSwiper(currUserID: currUserID)
                }
            }
            Tab("My Matches", systemImage: "heart") {
                NavigationStack {
                    MatchList(currentUserID: currUserID)
                }
            }
        }
        .task {
            await loadProfileData()
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
