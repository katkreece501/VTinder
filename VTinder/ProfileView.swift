//
//  ProfileView.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/23/26.
//

/*
 Defines the view where a user can view a profile.
 Note that this view can handle a user's own profile or another user's profile, depending on what is passed in.
 */

import SwiftUI

/*
 Displays the a user's profile information.
 In our opinion, this is mainly Object-Oriented programming, due to the heavy use of the Profile struct and various other SwiftUI objects.
 However, the use of the loadLatestProfile() function to get lateset profile version is an example of Procedural programming.
 */
struct ProfileView: View {
    let apiService = APIService() // Used to
    var profile: Profile // Passed in as a parameter
    let currUserID: String // Passed in as a parameter
    @State private var latestProfile: Profile? // Refetched each time your own profile appears
    private var shown: Profile { latestProfile ?? profile }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showProfileInfo = false
    
    var body: some View {
        /*
         Main part of the view that displays the data.
         */
        ScrollView {
            VStack(spacing: 20) {
                Text("\(shown.name), \(shown.year)").font(.title).bold() // Show the name and school year at the very top
                if let data = shown.image, let uiImage = UIImage(data: data) { // Show profile image
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "person.circle") // Fallback placeholder
                        }
                Text("About Me: \(shown.bio)").font(.title3) // Show bio
                Text("Major: \(shown.major)").font(.title3) // Show major
                Text("Interests: \(shown.interests)").font(.title3) // Show interests
                Text("Graduation Date: \(shown.gradDate)").font(.title3) // Show graduation date
                Text("Next Steps: \(shown.nextSteps)").font(.title3) // Show planned next steps after graduation
                Text("Age: \(shown.age)").font(.title3) // Show age
                Text("Height: \(shown.heightFeetPart()) ft \(shown.heightInchesPart()) in").font(.title3) // Show height
                Text("Gender: \(shown.gender)").font(.title3) // Show gender
                    }
                    .padding()
                    .toolbar {
                        // Certain items only shown if a user is viewing their own profile.
                        if shown.uuid == currUserID {
                            // If the user is on an iPad, show the edit button
                            // If the user is on an iPhone, this is handled in the DaterHomeView class
                            if horizontalSizeClass != .compact {
                                ToolbarItem(placement: .topBarTrailing) {
                                    NavigationLink("Edit") {
                                        ProfileEditor(profile: shown)
                                    }
                                }
                            }
                            // Provides a button to click to give some brief instructions on what to do on your profile
                            // Note that this is handled in the DaterHomeView class on the iPhone - the tab view automatically covers this code up
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
                    .navigationTitle(shown.uuid == currUserID ? "My Profile" : shown.name) // Title is "My Profile" for your own profile, otherwise the user's name
            }
            .task {
                // Only your own profile can change while you're looking at it
                if profile.uuid == currUserID {
                    await loadLatestProfile()
                }
            }
    }
    /*
     Fetches the lasted version of a profile from the API
     Used when a user edits their own profile and goes back to this view.
     */
    func loadLatestProfile() async {
        do {
            latestProfile = try await apiService.fetchProfile(userID: currUserID)
        } catch {
            print("Error: \(error)")
        }
    }
}
