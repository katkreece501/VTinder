//
//  VTinderApp.swift
//  VTinder
//
//  Created by Kathleen Reece on 9/15/26.
//

import SwiftUI

@main
struct VTinderApp: App {
    var body: some Scene {
        WindowGroup {
            //ProfileSwiper(currUserID: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa")
            // 99999999-9999-4999-8999-999999999999
            DaterHomeView(currUserID: "99999999-9999-4999-8999-999999999999")
        }
    }
}
