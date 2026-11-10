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
    //let name:String
    @State private var latestProfile: Profile? // Refetched each time your own profile appears
    private var shown: Profile { latestProfile ?? profile }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showProfileInfo = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("\(shown.name), \(shown.year)").font(.title).bold()
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
                            if horizontalSizeClass != .compact {
                                ToolbarItem(placement: .topBarTrailing) {
                                    NavigationLink("Edit") {
                                        ProfileEditor(profile: shown)
                                    }
                                }
                            }
                            ToolbarItem(placement: .bottomBar) {
                                Button {
                                    showProfileInfo = true
                                } label: {
                                    Image(systemName: "questionmark")
                                }
                                .popover(isPresented: $showProfileInfo) {
                                    Text("This is what your profile looks like to other users. Make changes by clicking Edit.")
                                        .padding()
                                        .frame(width: 250)
                                        .presentationCompactAdaptation(.popover)
                                }
                            }
                        }
                    }
                    .navigationTitle("My Profile")
            }
            .task {
                // Only your own profile can change while you're looking at it
                if profile.uuid == currUserID {
                    await loadLatestProfile()
                }
            }
    }
    func loadLatestProfile() async {
        do {
            latestProfile = try await apiService.fetchProfile(userID: currUserID)
        } catch {
            print("Error: \(error)")
        }
    }
}
