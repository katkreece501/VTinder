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
    @State private var names: [String] = []
    @State private var swipeAmount: CGSize = .zero
    @State var isLoading = true
    
    var body: some View {
        VStack {
            //profiles = removeCurrentUser(profiles: profiles, currUserID: currUserID)
            //var names = getNames(profiles: profiles)
            if isLoading {
                ProgressView("Loading profiles...")
            }
            else if profilesIndex < profiles.count && profilesIndex < names.count {
                ProfileView(profile: profiles[profilesIndex], currUserID: currUserID, name: names[profilesIndex])
                    .offset(swipeAmount)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                swipeAmount = value.translation
                            })
                            .onEnded({ value in
                                if swipeAmount.width > 0 {
                                    Task {
                                        do {
                                            try await apiService.sendLikeOrDislike(swiperID: currUserID, swipeeID: profiles[profilesIndex].uuid, isLike: true)
                                        }
                                        catch {
                                            print("Error: \(error)")
                                        }
                                    }
                                }
                                else {
                                    Task {
                                        do {
                                            try await apiService.sendLikeOrDislike(swiperID: currUserID, swipeeID: profiles[profilesIndex].uuid, isLike: false)
                                        }
                                        catch {
                                            print("Error: \(error)")
                                        }
                                    }
                                }
                                if profilesIndex + 1 < profiles.count {
                                    profilesIndex += 1
                                }
                                swipeAmount = .zero
                            })
                    )
            }
            else {
                Text("No more profiles")
            }
        }
        .task {
            await loadProfiles()
        }
    }
    func loadProfiles() async {
        do {
            profiles = try await apiService.fetchProfiles(userID: currUserID)
            profiles = profiles.filter { profile in
                        profile.uuid != currUserID
                    }
            names = await getNames(profiles: profiles)
            isLoading = false
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
    func getNames(profiles: [Profile]) async -> [String] {
        var names: [String] = []

        for profile in profiles {
            do {
                let user = try await apiService.fetchUser(userID: profile.uuid)
                names.append(user.name)
            } catch {
                print("Error: \(error)")
            }
        }

        return names
    }
}
