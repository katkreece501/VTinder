//
//  ProfileSwiper.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/8/26.
//

/*
 Holds the ProfileSwiper, allowing users to like or dislike other Daters.
 */

import SwiftUI

/*
 View for swiping on other profiles, similar to other conventional dating apps.
 In our opinion, this is mainly Object-Oriented programming, due to the heavy use of the Profile structs and various other SwiftUI objects.
 However, the use of the loadProfiles() function to get profiles the user can swipe through is an example of Procedural programming.
 */
struct ProfileSwiper: View {
    let apiService = APIService()
    let currUserID: String // Passed in as a parameter
    @State private var showSwipeInfo = false // Whether we're showing the instructions pop-up
    @State private var profiles: [Profile] = [] // The profiles that the user can swipe through
    @State private var profilesIndex = 0 // Where we are at in the profiles list
    @State private var swipeAmount: CGSize = .zero // How far to left/right the user has swiped.
    @State var isLoading = true // If we are still fetching the profiles from the API
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading profiles...")
            }
            // If we still have profiles to swipe through
            else if profilesIndex < profiles.count {
                ProfileView(profile: profiles[profilesIndex], currUserID: currUserID)
                    .offset(swipeAmount)
                    .gesture(
                        DragGesture()
                            // When the user starts swiping, measure the swipe amount
                            .onChanged({ value in
                                swipeAmount = value.translation
                            })
                            .onEnded({ value in
                                // If the user swipes to the right, then it's a like, otherwise a dislike
                                let isLike = value.translation.width > 0
                                let swipeeID = profiles[profilesIndex].uuid
                                
                                // Send like to the API
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
        .toolbar {
            // Instructions button for the iPad users
            // Will be hidden by the TabView tabs for iPhone users - their button is handled in DaterHomeView
            ToolbarItem(placement: .bottomBar) {
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
        .task {
            await loadProfiles()
        }
    }
    /*
     Gets profiles from the API the user can swipe on.
     Note that the user's own profile, along with Daters the users has already swiped through,
     are filtered out on the backend
     */
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
