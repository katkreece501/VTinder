//
//  Profile.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/21/26.
//

import SwiftUI
import SwiftData
import UIKit

@Model
class Profile {
    var name:String
    var year:String
    var bio:String
    var major:String
    var interests:String
    var gradDate:String
    var nextSteps:String
    var age:Int
    var heightFeet:Int
    var heightInches:Int
    var gender:String
    var imageData: Data?
    
    init(name: String, year: String, bio: String, major: String, interests: String, gradDate: String, nextSteps: String, age: Int, heightFeet: Int, heightInches: Int, gender: String, imageData: Data) {
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
    
    var profileImage: UIImage? {
        imageData.flatMap {
            UIImage(data: $0)
        }
    }
}
