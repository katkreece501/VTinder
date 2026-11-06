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
        NavigationStack {
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
        }
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
        HStack {
            Text(profile.name)
            Button() {
                ProfileView(profile: profile, currUserID: currentUserID)
            } label: {
                Text("View Profile")
            }
            .foregroundStyle(.blue)
            .buttonStyle(.borderless)
        }
    }
}
