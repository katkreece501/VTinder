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
    var uuid: String
    var email: String
    var isModerator: Bool
    
    init(name: String, email: String, isModerator: Bool) {
        self.name = name
        self.uuid = UUID().uuidString
        self.email = email
        self.isModerator = isModerator
    }
}

struct UserResponse: Codable {
    let results: User
}
