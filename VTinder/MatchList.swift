//
//  MatchList.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/26/26.
//

import SwiftUI

struct MatchList: View {
    @State var matches: [Profile] = []
    var currentUserID: String
    @State var isLoading = true
    let apiService = APIService()
    @State private var showMatchesInfo = false
    
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
