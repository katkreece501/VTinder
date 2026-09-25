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
    @State private var name: String
    @State private var selectedYear: SchoolYear
    @State private var bio: String
    @State private var selectedMajor: Major
    @State private var interests: String
    @State private var selectedGradDate: GradDate
    @State private var selectedNextSteps: NextSteps
    @State private var age: Int?
    @State private var heightFeet: Int?
    @State private var heightInches: Int?
    @State private var selectedGender = Gender.female
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    init(profile: Profile?) {
        self.profile = profile
        _name = State(initialValue: profile?.name ?? "")
        _selectedYear = State(initialValue: profile?.stringToEnumYear() ?? .freshman)
        _bio = State(initialValue: profile?.bio ?? "")
        _selectedMajor = State(initialValue: profile?.stringToEnumMajor() ?? .accounting)
        _interests = State(initialValue: profile?.interests ?? "")
        _selectedGradDate = State(initialValue: profile?.stringToEnumGradDate() ?? .fall26)
        _selectedNextSteps = State(initialValue: profile?.stringToEnumNextSteps() ?? .gradSchool)
        _age = State(initialValue: profile?.age)
        _heightFeet = State(initialValue: profile?.heightFeet)
        _heightInches = State(initialValue: profile?.heightInches)
        _selectedGender = State(initialValue: profile?.stringToEnumGender() ?? .female)
        _selectedImageData = State(initialValue: profile?.imageData)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("School Year", selection: $selectedYear) {
                    ForEach(SchoolYear.allCases) { year in Text(year.rawValue) }
                }
                TextField("About You", text: $bio, axis: .vertical).lineLimit(1...5)
                Picker("Major", selection: $selectedMajor) {
                    ForEach(Major.allCases) { major in Text(major.rawValue) }
                }
                TextField("List your interests", text: $interests, axis: .vertical).lineLimit(1...3)
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
                    Text("Choose Profile Image")
                }
                // Displays the selected image
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage).resizable().scaledToFit().frame(height: 50)
                }
            }
            .onChange(of: selectedPhoto) {
                guard let selectedPhoto else { return }
                Task {
                    selectedImageData = try? await selectedPhoto.loadTransferable(type: Data.self)
                }
            }
            .navigationTitle(editorTitle)
        }
    }
}

#Preview {
    ProfileEditor(profile: Profile.sample1)
}
