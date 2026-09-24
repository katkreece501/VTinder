//
//  The class for the profile information.
//
//  Created by Kathleen Reece on 9/21/26.
//

import SwiftUI
import SwiftData
import UIKit

@Model
class Profile {
    var name:String // Name of the user
    var year:String // Year in school; chosen from a drop down
    var bio:String // Whatever the user wants to put about themself
    var major:String // User's primary major; chosen from a drop down
    var interests:String // Whatever the user wants to put their interests as
    var gradDate:String // User's projected graduation date; chosen from drop down
    var nextSteps:String // What the user wants to do after college; chosen from drop down
    var age:Int // Age of the user
    var heightFeet:Int // Feet part of user's height
    var heightInches:Int // Inches part of user's height
    var gender:String // Gender of the user; chosen from a drop down
    var imageData: Data? // Data of the image to be displayed on the user profile
    
    init(name: String, year: String, bio: String, major: String, interests: String, gradDate: String, nextSteps: String, age: Int, heightFeet: Int, heightInches: Int, gender: String, imageData: Data? = nil) {
        self.name = name
        self.year = year
        self.bio = bio
        self.major = major
        self.interests = interests
        self.gradDate = gradDate
        self.nextSteps = nextSteps
        self.age = age
        self.heightFeet = heightFeet
        self.heightInches = heightInches
        self.gender = gender
        self.imageData = imageData
    }
    // Convert image data into the actual image
    /*
    var profileImage: UIImage? {
        imageData.flatMap {
            UIImage(data: $0)
        }
    }
     */
}

extension Profile {
    static var sample1: Profile {
        Profile(name: "Kathleen",
                year: "Senior",
                bio: "Hi, I'm Kathleen! I'm looking for a long-term boyfriend who likes quiet nights in and is heading to the DC area after graduation. Knowing what you want out of life is a huge plus!",
                major: "Computational Modeling and Data Analytics (CMDA)",
                interests: "Reading, Running, TV, Movies, Music, Spending Time with Family",
                gradDate: "Fall 2026",
                nextSteps: "Working",
                age: 21,
                heightFeet: 5,
                heightInches: 3,
                gender: "Female",
                imageData: UIImage(named: "SampleProfileImage1")?.jpegData(compressionQuality: 0.8))
    }
}
