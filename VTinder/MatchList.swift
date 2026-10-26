//
//  MatchList.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/26/26.
//

import SwiftUI

struct MatchList: View {
    private var matches: [Profile]
    private var names: [String]
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

struct MatchRow: View {
    private var profile: Profile
    private var name: String
    private var currentUserID: String
    
    var body: some View {
        HStack {
            Text(name)
            Button() {
                ProfileView(profile: profile, currUserID: currentUserID, name: name)
            } label: {
                Text("View Profile")
            }
            .foregroundStyle(.blue)
            .buttonStyle(.borderless)
            /*
             Spacer()
             Link to chat with this match here...
             */
        }
    }
}
