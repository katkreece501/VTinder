import SwiftUI

// Registration page
struct RegistrationView: View {
    let onRegistered: (Profile, String) -> Void
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""

    private let apiService: APIService = APIService()

    var body: some View {
        VStack(spacing: 16, content: {
            // Name entry
            TextField("Name", text: Binding<String>(
                get: { () -> String in
                    return name
                },
                set: { (newValue: String) in
                    name = newValue
                }
            ))
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Email entry
            TextField("Email", text: Binding<String>(
                get: { () -> String in
                    return email
                },
                set: { (newValue: String) in
                    email = newValue
                }
            ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(UIKeyboardType.emailAddress)
                // keeps the keyboard from changing what the user types
                .textInputAutocapitalization(TextInputAutocapitalization.never)
                .autocorrectionDisabled()

            // Password field
            SecureField("Password", text: Binding<String>(
                get: { () -> String in
                    return password
                },
                set: { (newValue: String) in
                    password = newValue
                }
            ))
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Creates the account
            Button("Create Account", action: { () -> Void in
                Task(operation: { () async -> Void in
                    await createAccount()
                })
            })
                .buttonStyle(BorderedProminentButtonStyle())

            // Shows what went wrong, if anything
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(Color.red)
            }
        })
        .padding()
        .navigationTitle("Create Account")
    }

    // Creates the account then sends the new user off to the profile editor
    private func createAccount() async {
        let uuid: String = UUID().uuidString.lowercased()

        // Registers the user
        do {
            try await apiService.register(uuid: uuid, name: name, email: email, password: password)
        } catch {
            errorMessage = "Couldn't create your account. That email may already be in use."
            return
        }

        let profile: Profile = Profile(uuid: uuid,
                                       year: SchoolYear.freshman.rawValue,
                                       bio: "",
                                       major: Major.accounting.rawValue,
                                       interests: "",
                                       gradDate: GradDate.fall26.rawValue,
                                       nextSteps: NextSteps.gradSchool.rawValue,
                                       age: 0,
                                       heightInches: 0,
                                       gender: Gender.female.rawValue)

        errorMessage = ""
        onRegistered(profile, name)
    }
}
