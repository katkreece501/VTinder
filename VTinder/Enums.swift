//
//  Enums.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/22/26.
//

enum SchoolYear:String, CaseIterable, Identifiable {
    case freshman = "Freshman"
    case sophomore = "Sophomore"
    case junior = "Junior"
    case senior = "Senior"
    case masters = "Masters"
    case phd = "PhD"
    case other = "Other"
    
    var id: Self { self }
}

enum Gender:String, CaseIterable, Identifiable {
    case female = "Female"
    case male = "Male"
    case other = "Other"
    
    var id: Self { self }
}

enum NextSteps:String, CaseIterable, Identifiable {
    case working = "Working"
    case military = "Military"
    case gradSchool = "Grad School"
    case medSchool = "Medical School"
    case stillDeciding = "Still Deciding"
    case other = "Other"
    
    var id: Self { self }
}

enum GradDate:String, CaseIterable, Identifiable {
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
    case other = "Other"
    
    var id: Self { self }
}

enum Major:String, CaseIterable, Identifiable {
    case accounting = "Accounting"
    case advertising = "Advertising"
    case aero = "Aerospace Engineering"
    case agbiz = "Agribusiness"
    case agtech = "Agricultural Technology"
    case animalPoultry = "Animal and Poultry Sciences"
    case architecture = "Architecture"
    case biochem = "Biochemistry"
    case bioEng = "Biological Systems Engineering"
    case bio = "Biology"
    case bioVet = "Biomedical and Veterinary Sciences"
    case biomedEng = "Biomedical Engineering"
    case buildConstruct = "Building Construction"
    case bizAdmin = "Business Administration"
    case bit = "Business Information Technology (BIT)"
    case bizUndecided = "Business Undecided"
    case chemEng = "Chemical Engineering"
    case chem = "Chemistry"
    case civil = "Civil Engineering"
    case comm = "Communication"
    case cmda = "Computational Modeling and Data Analytics (CMDA)"
    case compEng = "Computer Engineering"
    case cs = "Computer Science"
    case constructEng = "Construction Engineering"
    case creativeTech = "Creative Technologies"
    case crim = "Criminology"
    case currInstruc = "Curriculum and Instruction"
    case cybersec = "Cybersecurity Management and Analytics"
    case ecom = "Economics"
    case elect = "Electrical Engineering"
    case elemEd = "Elementary Education"
    case english = "English"
    case eitm = "Entrepreneurship, Innovation & Technology Management"
    case enviSci = "Environment Sciences"
    case enviCons = "Environmental Conservation and Society"
    case fashionMerch = "Fashion Merchandising and Design"
    case forest = "Forestry"
    case fin = "Finance"
    case finReal = "Finance and Real Estate"
    case finPlan = "Financial Planning and Wealth Management"
    case finTech = "FinTech and Big Data Analytics"
    case foodSci = "Food Science and Technology"
    case genEng = "General Engineering"
    case geog = "Geography"
    case geoSci = "Geosciences"
    case graphicDesign = "Graphic Design"
    case healthExercise = "Health and Excercise Sciences"
    case hist = "History"
    case hosTour = "Hospitality and Tourism Management"
    case humanDev = "Human Development"
    case hnfe = "Human Nutrition, Foods, and Exercise (HNFE)"
    case ise = "Industrial and System Engineering"
    case industrialDesign = "Industrial Design"
    case it = "Information Technology"
    case interiorDesign = "Interior Design"
    case intRel = "International Relations"
    case math = "Mathematics"
    case mgt = "Management"
    case mgtConsult = "Management Consulting and Analytics"
    case marketing = "Marketing"
    case materialEng = "Materials Science and Engineering"
    case mech = "Mechanical Engineering"
    case medChem = "Medical Chemistry"
    case med = "Medicine"
    case meteor = "Meteorology"
    case microBio = "Microbiology"
    case mining = "Mining Engineering"
    case multiMediaJour = "Multimedia Journalism"
    case natSec = "National Security and Foreign Affairs"
    case natRes = "Natural Resources"
    case neuro = "Neuroscience"
    case nutrition = "Nutrition and Dietetics"
    case packaging = "Packaging Systems and Design"
    case ppe = "Philosophy, Politics, and Economics"
    case phys = "Physics"
    case psyco = "Psycology"
    case polySci = "Politcal Science"
    case pubAdmin = "Public Administration and Public Affairs"
    case pubHealth = "Public Health"
    case pubRel = "Public Relations"
    case stat = "Statistics"
    case sportsMediaAnalyt = "Sports Media and Analytics"
    case realEstate = "Real Estate"
    case socio = "Sociology"
    case transBio = "Translational Biology, Medicine, and Health"
    case undecided = "Undecided"
    case vetMed = "Veterinary Medicine"
    case wildCons = "Wildlife Conservation"
    case otherAgLife = "Other (College of Agriculture and Life Sciences)"
    case otherArchArtDesign = "Other (College of Architecture, Arts, and Design)"
    case otherBiz = "Other (College of Business)"
    case otherEng = "Other (College of Engineering)"
    case otherLibArts = "Other (College of Liberal Arts and Human Sciences)"
    case otherSci = "Other (College of Science)"
    case otherNatRes = "Other (College of Natural Resources and Environment)"
    
    var id: Self { self }
}
