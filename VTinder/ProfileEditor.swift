//
//  ProfileEditor.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/22/26.
//

import SwiftUI
import SwiftData

/*
struct ProfileEditor: View {
    let profile: Profile?
    
    private var editorTitle: String {
            profile == nil ? "Create Profile" : "Edit Profile"
        }
    
    @State private var name = ""
    @State private var selectedYear = GradDate.freshman
    @State private var bio = ""
    @State private var major = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Category", selection: $selectedCategory) {
                    Text("Select a category").tag(nil as AnimalCategory?)
                    ForEach(categories) { category in
                        Text(category.name).tag(category as AnimalCategory?)
                    }
                }
                
                Picker("Diet", selection: $selectedDiet) {
                    ForEach(Animal.Diet.allCases, id: \.self) { diet in
                        Text(diet.rawValue).tag(diet)
                    }
                }
            }
        }
    }
}
 */
