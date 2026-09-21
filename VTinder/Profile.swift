//
//  Profile.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/21/26.
//

enum SchoolYear {
    case freshman, sophomore, junior, senior, masters, phd, other
}

enum Gender {
    case female, male, other
}

enum NextSteps {
    case working, gradSchool, medSchool, military, stillDeciding, other
}

enum GradDate{
    case fall26, spring27, fall27, spring28, fall28, spring29, fall29, spring30, fall30, spring31, other
}


struct Profile {
    var name:String
    var year:SchoolYear
    var description:String
    var major:String
    var interests:Set<String> = Set<String>()
    var gradDate:GradDate
    var next_steps:String
    var age:Int
    var heightFeet:Int
    var heightInches:Int
    var gender:Gender
}
