//
//  ProfileSwiper.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/8/26.
//

import SwiftUI

struct ProfileSwiper: View {
    let apiService = APIService()
    let currUserID: String
    
    @State private var profiles: [Profile] = []
    @State private var profilesIndex = 0
    @State private var swipeAmount: CGSize = .zero
    @State var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading profiles...")
            }
            else if profilesIndex < profiles.count {
                ProfileView(profile: profiles[profilesIndex], currUserID: currUserID)
                    .offset(swipeAmount)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                swipeAmount = value.translation
                            })
                            .onEnded({ value in
                                let isLike = value.translation.width > 0
                                let swipeeID = profiles[profilesIndex].uuid

                                Task {
                                    do {
                                        try await apiService.sendLikeOrDislike(
                                            swiperID: currUserID,
                                            swipeeID: swipeeID,
                                            isLike: isLike
                                        )

                                        // Advance only after the API succeeds
                                        profilesIndex += 1
                                        swipeAmount = .zero
                                    } catch {
                                        print("Error: \(error)")
                                        swipeAmount = .zero
                                    }
                                }
                            })
                    )
            }
            else {
                Text("No more profiles!")
            }
        }
        .task {
            await loadProfiles()
        }
    }
    func loadProfiles() async {
        do {
            profiles = try await apiService.fetchProfiles(userID: currUserID)
            isLoading = false
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
}
