//
//  VTinderApp.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/15/26.
//

import SwiftUI

@main
struct VTinderApp: App {
    @State private var currUserID: String? // Set once the user logs in or registers
    @State private var newProfile: Profile? // Only set right after registering
    @State private var newName = ""
    @State private var showEditor = false
    
    var body: some Scene {
        WindowGroup {
            //ProfileSwiper(currUserID: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa")
            // 99999999-9999-4999-8999-999999999999
            //DaterHomeView(currUserID: "99999999-9999-4999-8999-999999999999")
            if let currUserID {
                DaterHomeView(currUserID: currUserID)
                    // New users fill out their profile before seeing the home page
                    .fullScreenCover(isPresented: $showEditor) {
                        if let newProfile {
                            ProfileEditor(profile: newProfile, name: newName)
                        }
                    }
            } else {
                LoginView(onLoggedIn: { id in
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
