import SwiftUI

// the login screen
struct LoginView: View {
    let onLoggedIn: (String, Bool) -> Void // Passed in as a parameter. Given the user's ID and whether they're a Moderator
    let onRegistered: (Profile, String) -> Void
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""

    private let apiService: APIService = APIService()

    var body: some View {
        NavigationStack(root: {
            VStack(spacing: 16, content: {
                Text("Welcome To VTinder!")
                    .font(Font.largeTitle.bold())

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
                    .textInputAutocapitalization(TextInputAutocapitalization.never)
                    .autocorrectionDisabled()

                SecureField("Password", text: Binding<String>(
                    get: { () -> String in
                        return password
                    },
                    set: { (newValue: String) in
                        password = newValue
                    }
                ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Register and login buttons side by side under the fields
                HStack(spacing: 16, content: {
                    // Opens the sign-up form
                    NavigationLink(destination: RegistrationView(onRegistered: onRegistered), label: {
                        Text("Register")
                    })
                        .buttonStyle(BorderedButtonStyle())

                    // Logs the user in
                    Button("Login", action: { () -> Void in
                        Task(operation: { () async -> Void in
                            await logIn()
                        })
                    })
                        .buttonStyle(BorderedProminentButtonStyle())
                })

                // Shows what went wrong, if anything
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                }
            })
            .padding()
        })
    }

    // Checks the email and password with the server and goes to the home page if they're right
    private func logIn() async {
        let result: LoginResult
        do {
            result = try await apiService.login(email: email, password: password)
        } catch LoginError.banned { // If the user has been banned
            errorMessage = "This account has been banned."
            return
        } catch LoginError.invalidCredentials { // If the email or password is wrong
            errorMessage = "Couldn't log in. Check your email and password."
            return
        } catch let error as URLError {
            if error.code == .cannotConnectToHost {
                errorMessage = "The API is not running right now. Please try again later."
            } else {
                errorMessage = "A network error occurred. Please try again."
            }
            print("Network error: \(error)")
            return
        } catch {
            errorMessage = "Couldn't log in. Check your email and password."
            return
        }

        errorMessage = ""
        onLoggedIn(result.uuid, result.isModerator)
    }
}

#Preview {
    LoginView(onLoggedIn: { (uuid: String, isModerator: Bool) in
    }, onRegistered: { (profile: Profile, name: String) in
    })
}
