//
//  ProfileEditor.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/22/26.
//

/*
 Holds the Profile Editor view, which allows a user to edit the content displayed on their own profile.
 */

import SwiftUI
//import SwiftData
import PhotosUI

/*
 View for editing your own profile. A user is able to edit all parts of their profile except their name.
 This view is also used for new users to create their profile.
 In our opinion, this is mainly Object-Oriented programming, due to the heavy use of the Profile struct and various other SwiftUI classes.
 However, the use of the saveProfile() function to send the updated profile to the API is an example of Procedural programming.
 */
struct ProfileEditor: View {
    let apiService = APIService()
    let profile: Profile? // Passed as a parameter
    private var editorTitle: String = "Edit Profile"
    @State private var selectedYear: SchoolYear // The currently selected school year
    @State private var bio: String // The currently writtten bio
    @State private var selectedMajor: Major // Currently selected major
    @State private var interests: String // Currently written interests
    @State private var selectedGradDate: GradDate // Currently selected graduation date
    @State private var selectedNextSteps: NextSteps // Currently selected next steps
    @State private var age: Int? // Current age input
    @State private var heightFeet: Int? // Current input for the feet part of the height
    @State private var heightInches: Int? // Current input for the inches part of height
    @State private var selectedGender: Gender // Current selected gender
    @State private var selectedPhoto: PhotosPickerItem? // Current selected profile picture
    @State private var selectedImageData: Data? // Current selected profile picture image data
    
    @Environment(\.dismiss) private var dismiss // Whether we are dismissinhg this view
    
    /*
     Initializes the state variables
     */
    init(profile: Profile?) {
        self.profile = profile
        _selectedYear = State(initialValue: profile?.stringToEnumYear() ?? .freshman)
        _bio = State(initialValue: profile?.bio ?? "")
        _selectedMajor = State(initialValue: profile?.stringToEnumMajor() ?? .accounting)
        _interests = State(initialValue: profile?.interests ?? "")
        _selectedGradDate = State(initialValue: profile?.stringToEnumGradDate() ?? .fall26)
        _selectedNextSteps = State(initialValue: profile?.stringToEnumNextSteps() ?? .gradSchool)
        _age = State(initialValue: profile?.age)
        _heightFeet = State(initialValue: profile?.heightFeetPart())
        _heightInches = State(initialValue: profile?.heightInchesPart())
        _selectedGender = State(initialValue: profile?.stringToEnumGender() ?? .female)
        _selectedImageData = State(initialValue: profile?.image)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("School Year", selection: $selectedYear) { // Drop-down selection of school year
                    ForEach(SchoolYear.allCases) { year in Text(year.rawValue) }
                }
                TextField("About You", text: $bio, axis: .vertical).lineLimit(1...5) // Free response bio entry
                Picker("Major", selection: $selectedMajor) {
                    ForEach(Major.allCases) { major in Text(major.rawValue) }
                }
                TextField("List your interests", text: $interests, axis: .vertical).lineLimit(1...3) // Free response interests entry
                Picker("Graduation Date", selection: $selectedGradDate) {
                    ForEach(GradDate.allCases) { date in Text(date.rawValue) }
                }
                Picker("Next Steps", selection: $selectedNextSteps) { // Drop-down selection of next steps after graduation
                    ForEach(NextSteps.allCases) { steps in Text(steps.rawValue) }
                }
                Text("Age")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                TextField("Age", value: $age, format: .number) // Enter age as number
                Text("Height (Feet)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                TextField("Height (Feet)", value: $heightFeet, format: .number) // Enter feet part of height
                Text("Height (Inches)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                TextField("Height (Inches)", value: $heightInches, format: .number) // Enter inches part of height
                Picker("Gender", selection: $selectedGender) {
                    ForEach(Gender.allCases) { gend in Text(gend.rawValue) } // Drop-down selection of gender
                }
                // Select an image from photos library
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("Choose Profile Image")
                }
                // Displays the selected image
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage).resizable().scaledToFit().frame(height: 50)
                }
            }
            // Handle the user selecting a new photo
            .onChange(of: selectedPhoto) {
                guard let selectedPhoto else { return }
                Task {
                    selectedImageData = try? await selectedPhoto.loadTransferable(type: Data.self)
                }
            }
            .navigationTitle(editorTitle)
            // Save button for when you're done editing
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            do {
                                try await saveProfile()
                                dismiss()
                            } catch {
                                print("Failed to save profile: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    /*
     Sends the profile data to the API server for storage
     */
    func saveProfile() async throws {
        guard let profile else {
            return
        }
        // Combine feet and inches parts
        let totalHeightInches = (heightFeet ?? 0) * 12 + (heightInches ?? 0)
        
        // Make a new profile with the new inputs
        // All enum values are converted to Strings for ease of storage
        let updatedProfile = Profile(
            name: profile.name,
            uuid: profile.uuid,
            year: selectedYear.rawValue,
            bio: bio,
            major: selectedMajor.rawValue,
            interests: interests,
            gradDate: selectedGradDate.rawValue,
            nextSteps: selectedNextSteps.rawValue,
            age: age ?? 0,
            heightInches: totalHeightInches,
            gender: selectedGender.rawValue,
            image: selectedImageData
        )
        // Send profile data to the API
        try await apiService.updateProfile(profile: updatedProfile)
    }
}
