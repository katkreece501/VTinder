import Foundation

// Represents a single chat message between the user and one of their matches
struct Message: Codable {
    let id: Int
    let message: String
    let fromMe: Bool  // true if the logged-in user sent it

    init(id: Int, message: String, fromMe: Bool) {
        self.id = id
        self.message = message
        self.fromMe = fromMe
    }
}
