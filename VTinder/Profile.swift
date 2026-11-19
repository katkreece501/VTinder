//
//  The class for the profile information.
//
//  Created by Kathleen Reece on 9/21/26.
//

/*
 Holds the Profile struct to store user profile data.
 */

import SwiftUI
import Foundation
import UIKit

/*
 Holds the profile data of a user. Note that while several of these fields correspond to enums,
 they are stored as Strings for ease on the backend API.
 */
struct Profile: Codable {
    let name:String // Name of the user
    let uuid: String // Unique ID of the user
    var year:String // Year in school; chosen from a drop down
    var bio:String // Whatever the user wants to put about themself
    var major:String // User's primary major; chosen from a drop down
    var interests:String // Whatever the user wants to put their interests as
    var gradDate:String // User's projected graduation date; chosen from drop down
    var nextSteps:String // What the user wants to do after college; chosen from drop down
    var age:Int // Age of the user
    var heightInches:Int // User's height in inches
    var gender:String // Gender of the user; chosen from a drop down
    var image: Data? // Data of the image to be displayed on the user profile
    
    /*
     Creates a new Profile object.
     */
    init(name: String, uuid: String, year: String, bio: String, major: String, interests: String, gradDate: String, nextSteps: String, age: Int, heightInches: Int, gender: String, image: Data? = nil) {
        self.name = name
        self.uuid = uuid
        self.year = year
        self.bio = bio
        self.major = major
        self.interests = interests
        self.gradDate = gradDate
        self.nextSteps = nextSteps
        self.age = age
        self.heightInches = heightInches
        self.gender = gender
        self.image = image
    }
    
    /*
     Gets the feet part of the height.
     Example: If heightInches = 63, this function returns 5, as 63 inches is equivalent to 5 ft and 3 in.
     */
    func heightFeetPart() -> Int {
        return heightInches / 12
    }
    
    /*
     Gets the inches part of the height.
     Example: If heightInches = 63, this function returns 3, as 63 inches is equivalent to 5 feet and 3 inches.
     */
    func heightInchesPart() -> Int {
        return heightInches % 12
    }
    
    /*
     Converts the String form of the year in school to the corresponding enum case.
     */
    func stringToEnumYear() -> SchoolYear {
            return SchoolYear(rawValue: self.year) ?? .freshman
    }
    
    /*
     Converts the String form of the major to the corresponding enum case.
     */
    func stringToEnumMajor() -> Major {
        return Major(rawValue: self.major) ?? .accounting
    }
    
    /*
     Converts the String form of the graduation year to the corresponding enum case.
     */
    func stringToEnumGradDate() -> GradDate {
        return GradDate(rawValue: self.gradDate) ?? .fall26
    }
    
    /*
     Converts the String form of the planned next steps after graduation to the corresponding enum case.
     */
    func stringToEnumNextSteps() -> NextSteps {
        return NextSteps(rawValue: self.nextSteps) ?? .gradSchool
    }
    
    /*
     Converts the String form of gender to the corresponding enum case.
     */
    func stringToEnumGender() -> Gender {
        return Gender(rawValue: self.gender) ?? .female
    }
    
    
}
