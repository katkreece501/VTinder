//
//  UserClasses.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/25/26.
//

import SwiftUI
import Foundation

struct User: Codable {
    var name: String
    var userID: String
    var email: String
    var password: String
    var isModerator: Bool
    
    init(name: String, email: String, password: String, isModerator: Bool) {
        self.name = name
        self.userID = UUID().uuidString
        self.email = email
        self.password = password
        self.isModerator = isModerator
    }
}

struct UserHomeView: View {
    let user: User
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    ProfileView(currUserID: user.userID)
                } label: {
                    Label("My Profile", systemImage: "person.crop.artframe")
                }

            }
        }
        .navigationTitle("Welcome to VTinder, \(user.name)!")
    }
}
