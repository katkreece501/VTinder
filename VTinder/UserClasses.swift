//
//  UserClasses.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/25/26.
//

/*
 Contains the User struct, which holds basic data about a user.
 */

import SwiftUI
import Foundation

/*
 Holds basic data about a user, including their name, email, ID, and moderator status.
 This is an example of an Object-oriented paradigm.
 */
struct User: Codable {
    var name: String // The name of the user
    var uuid: String // The unique ID of the user
    var email: String // The email of the user - used when they log in
    var isModerator: Bool // True if this user is a Moderator, False if they are a data
    
    /*
     Creates a new user.
     */
    init(name: String, email: String, isModerator: Bool) {
        self.name = name
        self.uuid = UUID().uuidString // Generated as a UUID, but stored as String to make it convenient on the backend.
        self.email = email
        self.isModerator = isModerator
    }
}

/*
struct UserResponse: Codable {
    let results: User
}
 */
