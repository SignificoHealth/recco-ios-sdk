import SwiftUI
import ReccoUI

@main
struct ReccoShowcaseApp: App {
    init() {
        ReccoUI.initialize(
            clientSecret: "yvU5m39iXgVtOOKSQqz8neU5mP5HkOamKKMhcX5FDdBE6s6lmrdkC87XQr5dApi5r-vVOFo"
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
