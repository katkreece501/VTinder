//
//  UserClasses.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/25/26.
//

import SwiftUI

class User: Identifiable {
    var name: String
    var userID: UUID
    var email: String
    var password: String
    var isModerator: Bool
    var profile: Profile?
    
    init(name: String, email: String, password: String, isModerator: Bool) {
        self.name = name
        self.userID = UUID()
        self.email = email
        self.password = password
        self.isModerator = isModerator
    }
}

struct UserHomeView: View {
    let user: User
    
    var body: some View {
        NavigationStack {
            // TBD
        }
        .navigationTitle("Welcome to VTinder, \(user.name)!")
    }
}
