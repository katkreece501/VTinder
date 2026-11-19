//
//  ModeratorUserView.swift
//  VTinder
//

/*
 Holds the views Moderators use to look at a user's profile and take action on that user.
 */

import SwiftUI

/*
 Displays a user's profile as a Moderator sees it, with buttons to message or ban that user.
 The profile itself is shown using the same ProfileView that Daters use.
 In our opinion, this is mainly Object-Oriented programming, due to the use of the Profile struct and various other SwiftUI classes.
 However, the use of the banUser() function to ban the user through the API is an example of Procedural programming.
 */
struct ModeratorUserView: View {
    let apiService = APIService()
    let profile: Profile // Passed in as a parameter
    let currUserID: String // Passed in as a parameter
    @State private var isBanned = false // Whether this user was banned on this screen. Users banned earlier aren't marked
    @State private var isShowingBanConfirmation = false // Whether we're showing the ban confirmation pop-up
    @State private var errorMessage: String = "" // Shown if the ban didn't go through

    var body: some View {
        ProfileView(profile: profile, currUserID: currUserID)
            // Shows what went wrong, if anything
            .safeAreaInset(edge: .bottom) {
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                        .padding()
                }
            }
            .toolbar {
                // Button to go and chat with this user
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Message") {
                        ChatView(profile: profile, currentUserID: currUserID)
                    }
                }
                // Button to ban this user. Once they're banned, it's replaced with a "Banned" label
                ToolbarItem(placement: .topBarTrailing) {
                    if isBanned {
                        Text("Banned")
                            .foregroundStyle(.secondary)
                    }
                    else {
                        Button("Ban", role: .destructive) {
                            isShowingBanConfirmation = true
                        }
                        // Ban confirmation message, so Moderators don't ban someone by accident
                        .confirmationDialog("Ban \(profile.name)?", isPresented: $isShowingBanConfirmation) {
                            Button("Ban \(profile.name)!", role: .destructive) {
                                Task {
                                    await banUser()
                                }
                            }
                        }
                    }
                }
            }
    }
    /*
     Tells the API to ban this user.
     Note that the backend refuses to ban other Moderators, which is the most likely reason for this to fail.
     */
    func banUser() async {
        do {
            try await apiService.banUser(uuid: profile.uuid)
        } catch {
            errorMessage = "Couldn't ban this user. Moderators can't be banned."
            return
        }
        errorMessage = ""
        isBanned = true
    }
}

/*
 Gets a user's profile from the API using their ID, then shows it with the Moderator actions.
 Used when a Moderator clicks on a report, since reports only hold the ID of the reported user.
 In our opinion, this is mainly Object-Oriented programming, due to the use of the Profile struct and various other SwiftUI classes.
 However, the use of the loadProfile() function to get the user's profile from the API is an example of Procedural programming.
 */
struct ReportedUserView: View {
    let apiService = APIService()
    let uuid: String // Passed in as a parameter
    let currUserID: String // Passed in as a parameter
    @State private var profile: Profile? // Fetched from the API
    @State var isLoading = true // If we are still fetching the profile from the API

    var body: some View {
        Group(content: {
            // If we have the profile, show it
            if let profile {
                ModeratorUserView(profile: profile, currUserID: currUserID)
            }
            else if isLoading {
                ProgressView("Loading user...")
            }
            // If the profile couldn't be loaded
            else {
                ContentUnavailableView {
                    Label("Couldn't Load User", systemImage: "person.crop.circle.badge.exclamationmark")
                } description: {
                    Text("This user may no longer exist.")
                }
            }
        })
        .task {
            await loadProfile()
        }
    }
    /*
     Goes to the API to get the profile of the reported user.
     Note that Moderators can still see the profiles of banned users.
     */
    func loadProfile() async {
        do {
            profile = try await apiService.fetchProfile(userID: uuid)
            isLoading = false
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
}
