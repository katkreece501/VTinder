import Foundation

// Represents a single chat message between the user and one of their matches
// This is an example of an Object-Orienteted paradigm
struct Message: Codable {
    let id: Int
    let message: String // content of the message
    let fromMe: Bool  // true if the logged-in user sent it

    init(id: Int, message: String, fromMe: Bool) {
        self.id = id
        self.message = message
        self.fromMe = fromMe
    }
}
