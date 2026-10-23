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
    
    var body: some View {
        ScrollView {
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
}
