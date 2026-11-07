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
    
    var body: some View {
        // Tapping a match opens the chat with them
        NavigationLink(destination: { () -> ChatView in
            return ChatView(profile: profile, currentUserID: currentUserID)
        }, label: { () -> Text in
            return Text(profile.name)
        })
    }
}
