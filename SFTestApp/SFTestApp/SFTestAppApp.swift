//
//  SFTestAppApp.swift
//  SFTestApp
//
//  Created by Adrián R on 25/5/23.
//

import SwiftUI
import SignificoSF

@main
struct SFTestAppApp: App {
    init() {
        SignificoSF.initialize(
            clientSecret: "G29B_plhobNgkKPv5Np26EMK67cvxhbhT1VRyB5-vbFifpKhuveuMeCjnk0tnv8b2QKWflY"
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
