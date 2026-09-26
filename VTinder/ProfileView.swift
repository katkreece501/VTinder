//
//  ProfileView.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/23/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    let user: User
    let currUserID: UUID
    
    var isCurrUserProfile: Bool {
        user.userID == currUserID
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("\(user.profile!.name), \(user.profile!.year)").font(.title).bold()
                if let data = user.profile!.imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "person.circle") // Fallback placeholder
                        }
                Text("About Me: \(user.profile!.bio)").font(.title3)
                Text("Major: \(user.profile!.major)").font(.title3)
                Text("Interests: \(user.profile!.interests)").font(.title3)
                Text("Graduation Date: \(user.profile!.gradDate)").font(.title3)
                Text("Next Steps: \(user.profile!.nextSteps)").font(.title3)
                Text("Age: \(user.profile!.age)").font(.title3)
                Text("Height: \(user.profile!.heightFeet) ft \(user.profile!.heightInches) in").font(.title3)
                Text("Gender: \(user.profile!.gender)").font(.title3)
                    }
                    .padding()
                    .toolbar {
                                if isCurrUserProfile {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button("Edit") {
                                            ProfileEditor(profile: user.profile, name: user.name)
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
