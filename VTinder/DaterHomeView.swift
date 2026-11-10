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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showProfileInfo = false
    @State private var showSwipeInfo = false
    @State private var showMatchesInfo = false
    
    var body: some View {
        if horizontalSizeClass == .compact {
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
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button {
                                            showProfileInfo = true
                                        } label: {
                                            Image(systemName: "questionmark")
                                        }
                                        .popover(isPresented: $showProfileInfo) {
                                            Text("This is what your profile looks like to other users. Make changes by clicking Edit.")
                                                .padding()
                                                .frame(width: 250)
                                                .presentationCompactAdaptation(.popover)
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
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        showSwipeInfo = true
                                    } label: {
                                        Image(systemName: "questionmark")
                                    }
                                    .popover(isPresented: $showSwipeInfo) {
                                        Text("If you are interested in dating a user, swipe to the right on their profile. If not, swipe to the left.")
                                            .padding()
                                            .frame(width: 250)
                                            .presentationCompactAdaptation(.popover)
                                    }
                                }
                            }
                    }
                }
                Tab("My Matches", systemImage: "heart") {
                    NavigationStack {
                        MatchList(currentUserID: currUserID)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        showMatchesInfo = true
                                    } label: {
                                        Image(systemName: "questionmark")
                                    }
                                    .popover(isPresented: $showMatchesInfo) {
                                        Text("If a user shows up here, you've liked them and they've liked you! Click on their name to chat with them.")
                                            .padding()
                                            .frame(width: 250)
                                            .presentationCompactAdaptation(.popover)
                                    }
                                }
                            }
                    }
                }
            }
            .task {
                await loadProfileData()
            }
        }
        else {
            NavigationSplitView {
                List {
                    if let profile {
                        NavigationLink("My Profile", destination: ProfileView(profile: profile, currUserID: currUserID))
                    }
                    NavigationLink("Swipe", destination: ProfileSwiper(currUserID: currUserID))
                    NavigationLink("My Matches", destination: MatchList(currentUserID: currUserID))
                }
            } detail: {
                Text("Select a something to do!")
            }
            .task {
                await loadProfileData()
            }
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
