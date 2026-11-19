//
//  ModeratorHomeView.swift
//  VTinder
//

/*
 Holds the view that Moderators see when they log in to the app. The exact view layout changes based on device (iPhone vs iPad), but from this
 view Moderators can:
 - View all users and their profiles
 - Message or ban any user
 - View and resolve reports sent in by Daters
 Moderators do not have access to any of the dating functions.
 */

import SwiftUI

/*
 Serves as the central "navigation view" for Moderators, allowing them to easily switch between viewing all users and viewing reports.
 iPhone and iPad users have a slightly different layout for switching between activities.
 In our opinion, this is mainly Object-Oriented programming, due to the use of the UserList, ReportList, and various other SwiftUI classes.
 */
struct ModeratorHomeView: View {
    let currUserID: String // Passed in as a parameter
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    // Whether we're showing the various pop-up info boxes or not
    @State private var showUsersInfo = false
    @State private var showReportsInfo = false

    var body: some View {
        // If you're on an iPhone
        if horizontalSizeClass == .compact {
            TabView { // Switch between activities by clicking between different tabs at the bottom
                // Viewing all users
                Tab("Users", systemImage: "person.3") {
                    NavigationStack {
                        UserList(currUserID: currUserID)
                            .navigationTitle("Users")
                            .toolbar {
                                // Instructions for viewing users
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        showUsersInfo = true
                                    } label: {
                                        Image(systemName: "questionmark")
                                    }
                                    .popover(isPresented: $showUsersInfo) {
                                        Text("Every user of the app is listed here. Click on a name to see their profile, message them, or ban them.")
                                            .padding()
                                            .frame(width: 250)
                                            .presentationCompactAdaptation(.popover)
                                    }
                                }
                            }
                    }
                }
                // Viewing reports sent in by Daters
                Tab("Reports", systemImage: "flag") {
                    NavigationStack {
                        ReportList(currUserID: currUserID)
                            .navigationTitle("Reports")
                            .toolbar {
                                // Instructions for handling reports
                                ToolbarItem(placement: .topBarLeading) {
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
                }
            }
        }
        // If you're on an iPad
        else {
            NavigationSplitView {
                List {
                    NavigationLink("Users", destination: UserList(currUserID: currUserID).navigationTitle("Users"))
                    NavigationLink("Reports", destination: ReportList(currUserID: currUserID).navigationTitle("Reports"))
                    /*
                     For iPad users, the instruction popups are located in the respective destination views.
                     */
                }
            } detail: {
                Text("Select something to do!")
            }
        }
    }
}
