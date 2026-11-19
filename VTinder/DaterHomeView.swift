//
//  DaterHomeView.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/8/26.
//

/*
 Holds the view that the Daters see when they log in to the app. The exact view lay changes based on device (iPhone vs iPad), but from this
 view users can:
 - View/Edit their own profile
 - Swipe on other profiles
 - Chat with matches
 */

import SwiftUI

/*
 Serves as the central "navigation view" for daters, allowing them to easily switch between viewing their own profile, swiping on
 other profiles, and chatting with matches. iPhone and iPad users have a slightly different layout for switching between activities.
 In our opinion, this is mainly Object-Oriented programming, due to the use of the Profile struct and various other SwiftUI classes.
 However, the use of the loadProfileData() function to get latest profile version is an example of Procedural programming.
 */
struct DaterHomeView: View {
    let apiService = APIService()
    @State private var profile: Profile? // Fetched from API
    let currUserID: String // Passed in as a parameter
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    // Whether we're showing the various pop-up info boxes or not
    @State private var showProfileInfo = false
    @State private var showSwipeInfo = false
    @State private var showMatchesInfo = false
    
    var body: some View {
        // If you're on an iPhone
        if horizontalSizeClass == .compact {
            TabView { // Switch between activities by clicking between different tabs at the bottom
                // Viewing your own profile
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
                                    // Instructions for viewing your own profile
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
                // Swiping on other Daters
                Tab("Swipe", systemImage: "person.crop.square.on.square.angled") {
                    NavigationStack {
                        ProfileSwiper(currUserID: currUserID)
                            .toolbar {
                                // Instructions for swiping
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        showSwipeInfo = true
                                    } label: {
                                        Image(systemName: "questionmark")
                                    }
                                    .popover(isPresented: $showSwipeInfo) {
                                        Text("If you are interested in dating a user, swipe to the right on their profile to like them. If not, swipe to the left to dislike them. If you and another user both swipe on each other, you'll match!")
                                            .padding()
                                            .frame(width: 250)
                                            .presentationCompactAdaptation(.popover)
                                    }
                                }
                            }
                    }
                }
                // Viewing and chatting with matches
                Tab("My Matches", systemImage: "heart") {
                    NavigationStack {
                        MatchList(currentUserID: currUserID)
                            .toolbar {
                                // Instructions for chatting with matches.
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
        // If you're on an iPad
        else {
            NavigationSplitView {
                List {
                    if let profile {
                        NavigationLink("My Profile", destination: ProfileView(profile: profile, currUserID: currUserID))
                    }
                    NavigationLink("Swipe", destination: ProfileSwiper(currUserID: currUserID))
                    NavigationLink("My Matches", destination: MatchList(currentUserID: currUserID))
                    /*
                     For iPad users, the instruction popups are located in the respective destination views.
                     */
                }
            } detail: {
                Text("Select something to do!")
            }
            .task {
                await loadProfileData()
            }
        }
    }
    /*
     Fetches the user's profile from the API.
     */
    func loadProfileData() async {
        do {
            profile = try await apiService.fetchProfile(userID: currUserID)
        } catch {
            print("Error: \(error)")
        }
    }
}
