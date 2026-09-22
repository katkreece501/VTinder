//
//  Profile.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/21/26.
//

import SwiftUI
import SwiftData

@Model
class Profile {
    var name:String
    var year:SchoolYear
    var bio:String
    var major:Major
    var interests:Set<String> = Set<String>()
    var gradDate:GradDate
    var nextSteps:NextSteps
    var age:Int
    var heightFeet:Int
    var heightInches:Int
    var gender:Gender
    
    init(name: String, year: SchoolYear, bio: String, major: Major, interests: Set<String>, gradDate: GradDate, nextSteps: NextSteps, age: Int, heightFeet: Int, heightInches: Int, gender: Gender) {
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
    }
}
