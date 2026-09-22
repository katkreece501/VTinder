//
//  Enums.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/22/26.
//

enum SchoolYear {
    case Freshman, Sophomore, Junior, Senior, Masters, PhD, Other
}

enum Gender {
    case Female, Male, Other
}

enum NextSteps:String {
    case Working, Military, Other
    case gradSchool = "Grad School"
    case medSchool = "Medical School"
    case stillDeciding = "Still Deciding"
}

enum GradDate: String {
    case fall26 = "Fall 2026"
    case spring27 = "Spring 2027"
    case fall27 = "Fall 2027"
    case spring28 = "Spring 2028"
    case fall28 = "Fall 2028"
    case spring29 = "Spring 2029"
    case fall29 = "Fall 2029"
    case spring30 = "Spring 2030"
    case fall30 = "Fall 2030"
    case spring31 = "Spring 2031"
    case Other
}

enum Major:String {
    // Agriculture and Life Sciences
    case agtech = "Agricultural Technology"
    case animalPoultry = "Animal and Poultry Sciences"
    case bioEng = "Biological Systems Engineering"
    case enviSci = "Environment Sciences"
    case foodSci = "Food Science and Technology"
    case healthExercise = "Health and Excercise Sciences"
    case hnfe = "Human Nutrition, Foods, and Exercise (HNFE)"
    case nutrition = "Nutrition and Dietetics"
    case otherAgLife = "Other in Agriculture and Life Sciences"
    case Agribusiness, Biochemistry
    // Architecture, Arts, and Design
    case creativeTech = "Creative Technologies"
    case fashionMerch = "Fashion Merchandising and Design"
    case graphicDesign = "Graphic Design"
    case industrialDesign = "Industrial Design"
    case interiorDesign = "Interior Design"
    case otherArchArtDesign = "Other in Architecture, Arts, and Design"
    case Architecture
    // Business
    case bit = "Business Information Technology (BIT)"
    case bizAdmin = "Business Administration"
    case bizUndecided = "Business Undecided"
    case cybersec = "Cybersecurity Management and Analytics"
    case eitm = "Entrepreneurship, Innovation & Technology Management"
    case finReal = "Finance and Real Estate"
    case finPlan = "Financial Planning and Wealth Management"
    case finTech = "FinTech and Big Data Analytics"
    case hosTour = "Hospitality and Tourism Management"
    case mgtConsult = "Management Consulting and Analytics"
    case otherBiz = "Other Business"
    case realEstate = "Real Estate"
    case Accounting, Finance, Management, Marketing
    // Engineering
    case aero = "Aerospace Engineering"
    case biomedEng = "Biomedical Engineering"
    case buildConstruct = "Building Construction"
    case chemEng = "Chemical Engineering"
    case civil = "Civil Engineering"
    case compEng = "Computer Engineering"
    case cs = "Computer Science"
    case constructEng = "Construction Engineering"
    case elect = "Electrical Engineering"
    case genEng = "General Engineering"
    case ise = "Industrial & System Engineering"
    case materialEng = "Materials Science and Engineering"
    case mech = "Mechanical Engineering"
    case mining = "Mining Engineering"
    case otherEng = "Other Engineering"
    // Inter College
    case it = "Information Technology"
    case transBio = "Translational Biology, Medicine, and Health"
    // Liberal Arts and Human Sciences
    case currInstruc = "Curriculum and Instruction"
    case elemEd = "Elementary Education"
    case humanDev = "Human Development"
    case intRel = "International Relations"
    case multiMediaJour = "Multimedia Journalism"
    case natSec = "National Security and Foreign Affairs"
    case otherLibArts = "Other in Liberal Arts and Human Sciences"
    case ppe = "Philosophy, Politics, and Economics"
    case polySci = "Politcal Science"
    case pubAdmin = "Public Administration and Public Affairs"
    case pubRel = "Public Relations"
    case sportsMediaAnalyt = "Sports Media and Analytics"
    case Advertising, Communication, Criminology, English, History, Sociology
    // Science
    case cmda = "Computational Modeling and Data Analytics"
    case medChem = "Medical Chemistry"
    case otherSci = "Other in Science"
    case Biology, Chemistry, Economics, Geosciences, Mathematics, Microbiology, Neuroscience, Physics, Psycology, Statistics
    // Veterinary Medicine
    case bioVet = "Biomedical and Veterinary Sciences"
    case pubHealth = "Public Health"
    case vetMed = "Veterinary Medicine"
    // Natural Resources and Environment
    case enviCons = "Environmental Conservation and Society"
    case natRes = "Natural Resources"
    case otherNatRes = "Other in Natural Resources and Environment"
    case packaging = "Packaging Systems and Design"
    case wildCons = "Wildlife Conservation"
    case Forestry, Geography, Meteorology
    // Other
    case Medicine, Other, Undecided
}
