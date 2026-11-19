//
//  ReportList.swift
//  VTinder
//

/*
 Holds the ReportList view, allowing Moderators to see and resolve reports sent in by Daters.
 */

import SwiftUI

/*
 Lists out every report sent in by Daters, with the newest reports at the top.
 Moderators can click a report to go to the reported user's profile, or swipe on it to mark it as resolved.
 In our opinion, this is mainly Object-Oriented programming, due to the heavy use of the ReportRecord struct and various other SwiftUI classes.
 However, the use of the loadReports() and resolve() functions to get and delete reports through the API is an example of Procedural programming.
 */
struct ReportList: View {
    @State var reports: [ReportRecord] = [] // Fetched from the API
    var currUserID: String // Passed in as a parameter
    @State var isLoading = true // If we are still fetching the reports from the API
    @State private var errorMessage: String = "" // Shown if a report couldn't be resolved
    let apiService = APIService()
    @State private var showReportsInfo = false // Are we showing the instructions pop up or not.

    var body: some View {
        // No NavigationStack here; this screen is pushed onto the home screen's stack
        Group(content: {
            if isLoading {
                ProgressView("Loading reports...")
            }
            // If there aren't any reports left to look at
            else if reports.isEmpty {
                ContentUnavailableView {
                    Label("No Reports", systemImage: "checkmark.shield")
                } description: {
                    Text("There's nothing to look into right now.")
                }
            }
            else {
                List {
                    ForEach(reports, id: \.id) { report in
                        ReportRow(report: report, currUserID: currUserID)
                            // Swiping on a report marks it as resolved
                            .swipeActions {
                                Button("Resolve", systemImage: "checkmark") {
                                    Task {
                                        await resolve(report)
                                    }
                                }
                                .tint(Color.green)
                            }
                    }
                }
            }
        })
        // Shows what went wrong, if anything
        .safeAreaInset(edge: .bottom) {
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(Font.footnote)
                    .foregroundStyle(HierarchicalShapeStyle.secondary)
            }
        }
        .task {
            await loadReports()
        }
        // For iPad users - their instructions button
        // On an iPhone, this will be hidden by the bottom tabs, and their instructions button is in ModeratorHomeView
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showReportsInfo = true
                } label: {
                    Image(systemName: "questionmark")
                }
                .popover(isPresented: $showReportsInfo) {
                    Text("Reports sent by daters show up here. Click on a report to see the reported user, and swipe left to resolve it.")
                        .padding()
                        .frame(width: 250)
                        .presentationCompactAdaptation(.popover)
                }
            }
        }
    }
    /*
     Goes to the API to get every report.
     Note that the reports come back already sorted from newest to oldest.
     */
    func loadReports() async {
        do {
            reports = try await apiService.fetchReports()
            isLoading = false
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
    /*
     Tells the API to delete a report once it's been dealt with, then takes it off the list.
     */
    func resolve(_ report: ReportRecord) async {
        do {
            try await apiService.deleteReport(id: report.id)
        } catch {
            errorMessage = "Couldn't resolve that report. Try again."
            return
        }
        errorMessage = ""
        reports.removeAll { $0.id == report.id }
    }
}

/*
 Displays who sent a report, who it's about, why it was sent, and when.
 Provides a link to the reported user's profile.
 */
struct ReportRow: View {
    var report: ReportRecord // Passed in as a parameter
    var currUserID: String // Passed in as a parameter

    var body: some View {
        NavigationLink {
            ReportedUserView(uuid: report.reported, currUserID: currUserID)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(report.reporterName) → \(report.reportedName)") // Show who reported who at the top
                    .font(.headline)
                Text(report.reason) // Show the reason for the report
                Text(report.timestamp, style: .date) // Show the date the report was sent
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
