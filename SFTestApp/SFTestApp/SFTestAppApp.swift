//
//  SFTestAppApp.swift
//  SFTestApp
//
//  Created by Adrián R on 25/5/23.
//

import SwiftUI
import SignificoSF
import SFApi

@main
struct SFTestAppApp: App {
    init() {
        SignificoSF.initialize(
            clientSecret: "YuJi02IHzJDxe-oiqT1QOptnh9mGMnulPPx5C3xoyBSe0dNha-m1qOjG9DopeSspqR9d6-Y"
        )
        
        SFApi.login(clientId: "myId")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
