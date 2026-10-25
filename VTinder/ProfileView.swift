//
//  ProfileView.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/23/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    let apiService = APIService()
    var profile: Profile
    //@State private var profileUser: User?
    let currUserID: String
    //let profileUserID: String
    let name:String
    @State private var latestProfile: Profile? // Refetched each time your own profile appears
    private var shown: Profile { latestProfile ?? profile }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("\(name), \(shown.year)").font(.title).bold()
                if let data = shown.image, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "person.circle") // Fallback placeholder
                        }
                Text("About Me: \(shown.bio)").font(.title3)
                Text("Major: \(shown.major)").font(.title3)
                Text("Interests: \(shown.interests)").font(.title3)
                Text("Graduation Date: \(shown.gradDate)").font(.title3)
                Text("Next Steps: \(shown.nextSteps)").font(.title3)
                Text("Age: \(shown.age)").font(.title3)
                Text("Height: \(shown.heightFeetPart()) ft \(shown.heightInchesPart()) in").font(.title3)
                Text("Gender: \(shown.gender)").font(.title3)
                    }
                    .padding()
                    .toolbar {
                        if shown.uuid == currUserID {
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink("Edit") {
                                    ProfileEditor(profile: shown, name: name)
                                }
                            }
                        }
                    }
            /*
            if let profile {
                VStack(spacing: 20) {
                    Text("\(name), \(profile.year)").font(.title).bold()
                    if let data = profile.image, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                Image(systemName: "person.circle") // Fallback placeholder
                            }
                    Text("About Me: \(profile.bio)").font(.title3)
                    Text("Major: \(profile.major)").font(.title3)
                    Text("Interests: \(profile.interests)").font(.title3)
                    Text("Graduation Date: \(profile.gradDate)").font(.title3)
                    Text("Next Steps: \(profile.nextSteps)").font(.title3)
                    Text("Age: \(profile.age)").font(.title3)
                    Text("Height: \(profile.heightFeetPart()) ft \(profile.heightInchesPart()) in").font(.title3)
                    Text("Gender: \(profile.gender)").font(.title3)
                        }
                        .padding()
                        .toolbar {
                            if profile.uuid == currUserID {
                                ToolbarItem(placement: .topBarTrailing) {
                                    NavigationLink("Edit") {
                                        ProfileEditor(profile: profile, name: name)
                                    }
                                }
                            }
                        }
            }
            else {
                ProgressView("Loading...")
                    .navigationTitle("Loading...")
            }
            */
            }
            .navigationTitle("Profile")
            .task {
                // Only your own profile can change while you're looking at it
                if profile.uuid == currUserID {
                    await loadLatestProfile()
                }
            }
        /*
            .task {
                await loadData()
            }
         */
    }
    /*
    func loadData() async {
        do {
            profile = try await apiService.fetchProfile(userID: profileUserID)
        } catch {
            print("Error: \(error)")
        }
    }
     */
    func loadLatestProfile() async {
        do {
            latestProfile = try await apiService.fetchProfile(userID: currUserID)
        } catch {
            print("Error: \(error)")
        }
    }
}
