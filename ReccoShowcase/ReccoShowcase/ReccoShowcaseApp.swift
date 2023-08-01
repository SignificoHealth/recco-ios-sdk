import SwiftUI
import ReccoUI

let clientSecret = "yvU5m39iXgVtOOKSQqz8neU5mP5HkOamKKMhcX5FDdBE6s6lmrdkC87XQr5dApi5r-vVOFo"

@main
struct ReccoShowcaseApp: App {
    init() {
        ReccoUI.initialize(
            clientSecret: clientSecret,
            style: PaletteStorageObservable.shared.storage.selectedStyle
        )
    }
    
    var body: some Scene {
        WindowGroup {
           AppView()
        }
    }
}

struct CompanyView: View {
    var body: some View {
        VStack {
            HStack {
                Image("recco_logo")
                Text("by")
                    .bodySmallLight()
            }
            Image("significo_logo")
        }
        .padding(.vertical, 32)
    }
}

struct AppView: View {
    @AppStorage("username") var username: String = ""
        
    var body: some View {
        ZStack {
            if username.isEmpty {
                SignInView()
            } else {
                WelcomeView()
            }
        }
        .background(Color.lightGray.ignoresSafeArea())
    }
}
