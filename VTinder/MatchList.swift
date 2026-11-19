//
//  MatchList.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/26/26.
//

/*
 Holds the MatchList view, allowing users to see and chat with their matches.
 */

import SwiftUI

/*
 Lists out each Dater the user has matched with (i.e., the Daters that have liked the user and that the user has liked back).
 Users can click each line in the list to go and message that match.
 In our opinion, this is mainly Object-Oriented programming, due to the heavy use of the Profile struct and various other SwiftUI classes.
 However, the use of the loadMatches() function to get all the user's matches from the API is an example of Procedural programming.
 */
struct MatchList: View {
    @State var matches: [Profile] = [] // Fetched from the API
    var currentUserID: String // Passed in as a parameter
    @State var isLoading = true
    let apiService = APIService()
    @State private var showMatchesInfo = false // Are we showing the instructions pop up or not.
    
    var body: some View {
        // No NavigationStack here; this screen is pushed onto the home screen's stack
        Group(content: {
            if isLoading {
                ProgressView("Loading matches...")
            }
            else if matches.isEmpty {
                ContentUnavailableView {
                    Label("No Matches Yet...", systemImage: "tortoise")
                } description: {
                    Text("Keep swiping to find matches!")
                }
            }
            else {
                List {
                    ForEach(matches, id: \.uuid) { match in
                        MatchRow(profile: match, currentUserID: currentUserID)
                    }
                }
            }
        })
        .task {
            await loadMatches()
        }
        // For iPad users - their instructions button
        // On an iPhone, this will be hidden by the bottom tabs, and their instructions button is in DaterHomeView
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
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
    /*
     Goes to the API to get all matches for this user
     */
    func loadMatches() async {
        do {
            matches = try await apiService.fetchMatches()
            isLoading = false
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
}

/*
 Displays the name of the matched Dater and provides a link to message them
 Also has a flag button that lets the user report the match
 */
struct MatchRow: View {
    var profile: Profile
    var currentUserID: String
    @State private var showReportForm = false // Whether we're showing the report form or not

    var body: some View {
        HStack {
            // Tapping a match opens the chat with them
            NavigationLink(destination: { () -> ChatView in
                return ChatView(profile: profile, currentUserID: currentUserID)
            }, label: { () -> Text in
                return Text(profile.name)
            })
            // Button to report this match
            // The borderless style keeps a tap on the flag from also opening the chat
            Button {
                showReportForm = true
            } label: {
                Image(systemName: "flag")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        // Pops up the report form when the flag is clicked
        .sheet(isPresented: $showReportForm) {
            ChatReportForm(reportedProfile: profile)
        }
    }
}
