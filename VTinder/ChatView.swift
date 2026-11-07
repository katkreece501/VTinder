import SwiftUI

// Shows the chat with one match and lets the user send messages
struct ChatView: View {
    let profile: Profile
    let currentUserID: String
    @State private var viewModel: ChatViewModel

    init(profile: Profile, currentUserID: String) {
        self.profile = profile
        self.currentUserID = currentUserID
        self._viewModel = State<ChatViewModel>(initialValue: ChatViewModel(uuid: profile.uuid))
    }

    var body: some View {
        VStack(spacing: 0, content: {
            ScrollView(content: {
                LazyVStack(spacing: 8, content: {
                    // Scrolling up to this spinner loads the next 20 older messages;
                    // it runs again each time a page comes in, until there are no more
                    if viewModel.hasOlder {
                        ProgressView()
                            .task(id: viewModel.firstId, { () async -> Void in
                                await viewModel.loadOlder()
                            })
                    }

                    ForEach(viewModel.messages, id: \Message.id, content: { (message: Message) in
                        bubble(message)
                    })
                })
                .padding()
            })
            // Start at the newest message
            .defaultScrollAnchor(UnitPoint.bottom)
            // Keep the same messages on screen when older ones load above them
            .defaultScrollAnchor(UnitPoint.bottom, for: ScrollAnchorRole.sizeChanges)

            // Shows what went wrong, if anything
            if viewModel.errorMessage != "" {
                Text(viewModel.errorMessage)
                    .font(Font.footnote)
                    .foregroundStyle(HierarchicalShapeStyle.secondary)
            }

            // Text box and send button along the bottom
            HStack(content: {
                TextField("Message", text: Binding<String>(
                    get: { () -> String in
                        return viewModel.draft
                    },
                    set: { (newValue: String) in
                        viewModel.draft = newValue
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send", action: { () -> Void in
                    Task(operation: { () async -> Void in
                        await viewModel.send()
                    })
                })
                .disabled(draftIsBlank)
            })
            .padding()
        })
        // The match's name at the top of the screen
        .navigationTitle(profile.name)
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        // Lets the user look at the match's profile from the chat
        .toolbar(content: {
            ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing, content: {
                NavigationLink(destination: { () -> ProfileView in
                    return ProfileView(profile: profile, currUserID: currentUserID)
                }, label: { () -> Text in
                    return Text("Profile")
                })
            })
        })
        // Start polling when the screen appears, stop it when the screen closes
        .task({ () async -> Void in
            await viewModel.poll()
        })
    }

    // true when there's nothing but spaces in the text box
    private var draftIsBlank: Bool {
        return viewModel.draft.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }

    // One message bubble, mine go on the right in blue, theirs on the left in gray
    private func bubble(_ message: Message) -> some View {
        let alignment: Alignment
        let background: Color
        let foreground: Color
        if message.fromMe {
            alignment = Alignment.trailing
            background = Color.blue
            foreground = Color.white
        } else {
            alignment = Alignment.leading
            background = Color.gray.opacity(0.2)
            foreground = Color.primary
        }

        return Text(message.message)
            .padding(10)
            .foregroundStyle(foreground)
            .background(background, in: RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: CGFloat.infinity, alignment: alignment)
    }
}
