//
//  ChatReportForm.swift
//  VTinder
//

/*
 Holds the ChatReportForm view, allowing Daters to report another user from their list of matches.
 */

import SwiftUI

/*
 Form for reporting a user. The Dater only has to type in the reason for the report.
 The user being reported is passed in from the match list, and the API figures out who is sending the report from their login.
 In our opinion, this is mainly Object-Oriented programming, due to the use of the Profile struct and various other SwiftUI classes.
 However, the use of the sendReport() function to send the report to the API is an example of Procedural programming.
 */
struct ChatReportForm: View {
    let apiService = APIService()
    let reportedProfile: Profile // Passed in as a parameter
    @State private var reason: String = "" // The currently written reason for the report
    @State private var errorMessage: String = "" // Shown if the report couldn't be sent
    @State private var isSending = false // If we are still sending the report to the API

    @State private var isShowingCancelConfirmation = false // Whether we're showing the cancel confirmation pop-up
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                // Free response reason entry
                TextField(text: $reason, prompt: Text("Reason for report"), axis: .vertical) {
                    // blank
                }
                .lineLimit(1...5)

                // Shows what went wrong, if anything
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                }
            }
            .navigationTitle("Report \(reportedProfile.name)")
            .toolbar {
                // If the user wants to discard the report
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        // If they haven't typed anything, just close
                        if reason.isEmpty {
                            dismiss()
                        }
                        // If they have, make sure the user actually wants to cancel
                        else {
                            isShowingCancelConfirmation = true
                        }
                    }
                    // Cancel confirmation message
                    .confirmationDialog("Discard Report?", isPresented: $isShowingCancelConfirmation) {
                        Button("Discard Report!", role: .destructive) {
                            dismiss()
                        }
                    }
                }
                // If the user wants to send the report
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send Report", systemImage: "checkmark") {
                        Task {
                            await sendReport()
                        }
                    }
                    // Disabled while sending, so tapping the button twice doesn't send the report twice
                    .disabled(reasonIsBlank || isSending)
                }
            }
        }
    }

    /*
     Checks if the reason is empty or only has spaces in it.
     */
    private var reasonIsBlank: Bool {
        return reason.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }

    /*
     Sends the report to the API, then closes the form.
     If the report couldn't be sent, the form stays open so the user can try again.
     */
    func sendReport() async {
        isSending = true
        do {
            try await apiService.reportUser(uuid: reportedProfile.uuid,
                                            reason: reason.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        } catch {
            errorMessage = "Couldn't send your report. Try again."
            isSending = false
            return
        }
        dismiss()
    }
}
