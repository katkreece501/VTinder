//
//  UserList.swift
//  VTinder
//

/*
 Holds the UserList view, allowing Moderators to see every user of the app.
 */

import SwiftUI

/*
 Lists out every user of the app, including banned users and other Moderators.
 Moderators can click each line in the list to go to that user's profile, where they can message or ban them.
 In our opinion, this is mainly Object-Oriented programming, due to the heavy use of the Profile struct and various other SwiftUI classes.
 However, the use of the loadUsers() function to get all users from the API is an example of Procedural programming.
 */
struct UserList: View {
    @State var users: [Profile] = [] // Fetched from the API
    var currUserID: String // Passed in as a parameter
    @State var isLoading = true // If we are still fetching the users from the API
    let apiService = APIService()
    @State private var showUsersInfo = false // Are we showing the instructions pop up or not.

    var body: some View {
        // No NavigationStack here; this screen is pushed onto the home screen's stack
        Group(content: {
            if isLoading {
                ProgressView("Loading users...")
            }
            // If there aren't any users to show
            else if users.isEmpty {
                ContentUnavailableView {
                    Label("No Users Yet...", systemImage: "person.3")
                } description: {
                    Text("Users will show up here once they register.")
                }
            }
            else {
                List {
                    ForEach(users, id: \.uuid) { user in
                        // Clicking a user opens their profile, along with the Moderator actions
                        NavigationLink(user.name) {
                            ModeratorUserView(profile: user, currUserID: currUserID)
                        }
                    }
                }
            }
        })
        .task {
            await loadUsers()
        }
        // For iPad users - their instructions button
        // On an iPhone, this will be hidden by the bottom tabs, and their instructions button is in ModeratorHomeView
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showUsersInfo = true
                } label: {
                    Image(systemName: "questionmark")
                }
                .popover(isPresented: $showUsersInfo) {
                    Text("Every user of the app is listed here. Click on a name to see their profile, message them, or ban them.")
                        .padding()
                        .frame(width: 250)
                        .presentationCompactAdaptation(.popover)
                }
            }
        }
    }
    /*
     Goes to the API to get every user's profile.
     Note that only Moderators are allowed to do this, the backend refuses everyone else.
     */
    func loadUsers() async {
        do {
            users = try await apiService.fetchAllProfiles()
            isLoading = false
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
}
