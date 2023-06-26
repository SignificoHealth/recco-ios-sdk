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
            clientSecret: "YuJi02IHzJDxe-oiqT1QOptnh9mGMnulPPx5C3xoyBSe0dNha-m1qOjG9DopeSspqR9d6-Y"
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
