/*
 Holds the ReportRecord struct, which stores a report as Moderators see it.
 */

import Foundation

/*
 Holds the data of a report sent in by a Dater, as it comes back from the API.
 Note that this is different from the Report struct in ReportForm.swift, which is an older version that isn't used.
 This is an example of an Object-oriented paradigm.
 */
struct ReportRecord: Codable {
    let id: Int // Unique ID of the report
    let reporter: String // ID of the user who sent the report
    let reporterName: String // Name of the user who sent the report
    let reported: String // ID of the user being reported
    let reportedName: String // Name of the user being reported
    let timestamp: Date // When the report was sent
    let reason: String // Why the user was reported
}
