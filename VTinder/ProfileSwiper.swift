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
    //@State private var profileUser: User
    /*
    var cleanedProfiles: [Profile] {
        profiles.filter { profile in
                profile.uuid != currUserID
            }
    }
     */
    
    var body: some View {
        VStack {
            //profiles = removeCurrentUser(profiles: profiles, currUserID: currUserID)
            //var names = getNames(profiles: profiles)
            if profiles.isEmpty {
                ProgressView("Loading profiles...")
            }
            else if profilesIndex < profiles.count && profilesIndex < names.count {
                ProfileView(profile: profiles[profilesIndex], currUserID: currUserID, name: names[profilesIndex])
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
        } catch {
            print("Error: \(error)")
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
