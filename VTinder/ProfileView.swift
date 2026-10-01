//
//  ProfileView.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/23/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    let profile: Profile
    let currUserID: UUID
    
    var isOwnProfile: Bool {
        profile.userID == currUserID
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("\(profile.name), \(profile.year)").font(.title).bold()
                if let data = profile.imageData, let uiImage = UIImage(data: data) {
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
                Text("Height: \(profile.heightFeet) ft \(profile.heightInches) in").font(.title3)
                Text("Gender: \(profile.gender)").font(.title3)
                    }
                    .padding()
                    .toolbar {
                                if isOwnProfile {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button("Edit") {
                                            ProfileEditor(profile: profile, name: profile.name)
                                        }
                                    }
                                } else {
                                    // TBD
                                }
                            }
            }
            .navigationTitle("Profile")
    }
}

#Preview {
    //ProfileView(profile: .sample1)
}
