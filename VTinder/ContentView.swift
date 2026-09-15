//
//  ContentView.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/15/26.
//

import SwiftUI

struct ProfileInfo {
    let name:String
    let year:String
    let major:String
    var interests:Set<String> = Set<String>()
    let next_steps:String
    let age:Int
    let height:Int
    let gender:String
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
