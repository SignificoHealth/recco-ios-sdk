import SwiftUI
import ReccoUI

@main
struct ReccoShowcaseApp: App {
    init() {
        ReccoUI.initialize(
            clientSecret: "YuJi02IHzJDxe-oiqT1QOptnh9mGMnulPPx5C3xoyBSe0dNha-m1qOjG9DopeSspqR9d6-Y"
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
