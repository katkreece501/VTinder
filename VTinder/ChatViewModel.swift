import Foundation
import Observation

// Holds the messages for one chat; the chat screen redraws when these values change
@MainActor
@Observable
class ChatViewModel {
    var messages: [Message] = []
    var draft: String = ""
    var hasOlder: Bool = false  // true when the last page we got was full, so there may be more
    var errorMessage: String = ""
    let uuid: String

    private let apiService: APIService = APIService()

    init(uuid: String) {
        self.uuid = uuid
    }

    // Checks for new messages every 2 seconds until the chat screen closes
    func poll() async {
        while Task.isCancelled == false {
            await fetchNew()
            // The sleep throws once the screen closes, which ends the loop
            do {
                try await Task.sleep(for: Duration.seconds(2))
            } catch {
                return
            }
        }
    }

    // Adds any messages newer than the last one we have
    func fetchNew() async {
        guard let last: Message = messages.last else {
            // Nothing loaded yet (or the chat is empty), so get the newest page instead
            await loadNewest()
            return
        }

        let page: [Message]
        do {
            page = try await apiService.fetchMessages(with: uuid, beforeId: nil, afterId: last.id)
        } catch {
            // not a big deal; the next poll tries again
            return
        }

        // Skip anything another fetch already added while this one was waiting
        for i in 0..<page.count {
            if page[i].id > lastId {
                messages.append(page[i])
            }
        }
    }

    // Sends what's typed in the text box, then shows it right away
    func send() async {
        let text: String = draft.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard text.isEmpty == false else {
            return
        }

        // Clear the box first so tapping Send twice doesn't send it twice
        draft = ""
        do {
            try await apiService.sendMessage(to: uuid, text: text)
        } catch {
            draft = text
            errorMessage = "Couldn't send your message. Try again."
            return
        }
        errorMessage = ""
        await fetchNew()
    }

    // Puts the 20 messages before the oldest one we have at the top
    func loadOlder() async {
        guard let first: Message = messages.first else {
            return
        }

        let page: [Message]
        do {
            page = try await apiService.fetchMessages(with: uuid, beforeId: first.id, afterId: nil)
        } catch {
            // also happens if the user scrolls away mid-load; it retries when the top comes back into view
            return
        }
        messages.insert(contentsOf: page, at: 0)
        hasOlder = page.count == 20
    }

    // id of the oldest message, or 0 if there aren't any
    var firstId: Int {
        switch messages.first {
        case Optional.some(let first):
            return first.id
        case Optional.none:
            return 0
        }
    }

    // id of the newest message, or 0 if there aren't any
    var lastId: Int {
        switch messages.last {
        case Optional.some(let last):
            return last.id
        case Optional.none:
            return 0
        }
    }

    // Gets the 20 newest messages
    private func loadNewest() async {
        let page: [Message]
        do {
            page = try await apiService.fetchMessages(with: uuid, beforeId: nil, afterId: nil)
        } catch {
            errorMessage = "Couldn't load messages. Try again."
            return
        }
        messages = page
        hasOlder = page.count == 20
        errorMessage = ""
    }
}
