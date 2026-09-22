//
//  ProfileEditor.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/22/26.
//

import SwiftUI
import SwiftData
import PhotosUI


struct ProfileEditor: View {
    let profile: Profile?
    private var editorTitle: String {profile == nil ? "Create Profile" : "Edit Profile"}
    @State private var name = ""
    @State private var selectedYear = SchoolYear.freshman.rawValue
    @State private var bio = ""
    @State private var selectedMajor = Major.accounting.rawValue
    @State private var interests = ""
    @State private var selectedGradDate = GradDate.fall26.rawValue
    @State private var selectedNextSteps = NextSteps.gradSchool.rawValue
    @State private var age: Int?
    @State private var heightFeet: Int?
    @State private var heightInches: Int?
    @State private var selectedGender = Gender.female.rawValue
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: Image?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("School Year", selection: $selectedYear) {
                    ForEach(SchoolYear.allCases) { year in Text(year.rawValue) }
                }
                TextField("About You", text: $bio)
                Picker("Major", selection: $selectedMajor) {
                    ForEach(Major.allCases) { major in Text(major.rawValue) }
                }
                TextField("List your interests", text: $interests)
                Picker("Graduation Date", selection: $selectedGradDate) {
                    ForEach(GradDate.allCases) { date in Text(date.rawValue) }
                }
                Picker("Next Steps", selection: $selectedNextSteps) {
                    ForEach(NextSteps.allCases) { steps in Text(steps.rawValue) }
                }
                TextField("Age", value: $age, format: .number)
                TextField("Height (Feet)", value: $heightFeet, format: .number)
                TextField("Height (Inches)", value: $heightInches, format: .number)
                Picker("Gender", selection: $selectedGender) {
                    ForEach(Gender.allCases) { gend in Text(gend.rawValue) }
                }
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Choose Profile Photo")
                    }
                    if let selectedImage {
                        selectedImage.resizable().scaledToFit().frame(height: 50)
                    }
                }.onChange(of: selectedPhoto) {
                    Task {
                        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
            }
        }
    }
}

#Preview {
    ProfileEditor(profile: nil)
}
