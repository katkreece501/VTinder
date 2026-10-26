//
//  ReportForm.swift
//  VTinder
//
//  Created by Kathleen Reece on 10/26/26.
//

import SwiftUI

struct ReportForm: View {
    @State private var reportee: String = ""
    @State private var reportContent: String = ""
    
    @State private var isShowingCancelConfirmation = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading) {
                    TextField(text: $reportee, prompt: Text("Who are you reporting?")) {
                        // blank
                    }
                    .padding(.bottom, 20)
                    TextField(text: $reportContent, prompt: Text("Why are you reporting them?"), axis: .vertical) {
                        // blank
                    }
                    .lineLimit(1...5)
                }
            }
            .navigationTitle("Report User")
            .toolbar {
                // If the user wants to discard the report
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        // If it seems like they haven't made any changes, just close automatically
                        if reportee.isEmpty, reportContent.isEmpty {
                            dismiss()
                        }
                        // If they have made changes, make sure the user actually wants to cancel
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
                // If the user wants to sent the report.
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send Report", systemImage: "checkmark") {
                        // TODO: Store the report in API database somehow
                        dismiss()
                    }
                    .disabled(reportee.isEmpty)
                    .disabled(reportContent.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ReportForm()
}
