//
//  VTinderApp.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/15/26.
//

import SwiftUI

/*
 Puts up the login screen at first, and then routs the user to the appropriate home screen when they sucessfully log in.
 This is an example of Procedural Programing
 */
@main
struct VTinderApp: App {
    @State private var currUserID: String? // Set once the user logs in or registers
    @State private var isModerator = false // Set once the user logs in. Moderators see a different home screen with no dating functions
    @State private var newProfile: Profile? // Only set right after registering
    @State private var newName = ""
    @State private var showEditor = false
    
    var body: some Scene {
        WindowGroup {
            // If a Moderator logged in
            if let currUserID, isModerator {
                ModeratorHomeView(currUserID: currUserID)
            // If a Dater logged in
            } else if let currUserID {
                DaterHomeView(currUserID: currUserID)
                    // New users fill out their profile before seeing the home page
                    .fullScreenCover(isPresented: $showEditor) {
                        if let newProfile {
                            ProfileEditor(profile: newProfile)
                        }
                    }
            } else {
                LoginView(onLoggedIn: { id, moderator in
                              isModerator = moderator
                              currUserID = id
                          },
                          onRegistered: { profile, name in
                              newProfile = profile
                              newName = name
                              showEditor = true
                              currUserID = profile.uuid
                          })
            }
        }
    }
}
