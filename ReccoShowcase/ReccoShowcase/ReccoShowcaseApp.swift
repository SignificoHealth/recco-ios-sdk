import ReccoUI
import SwiftUI

let clientSecret = "PrTPVoqFek1I5ILEL0MUkkYhlIJFxHqH53yfeNBLu54A4OLiy8CC8vKLSMRcxKq2MpVhtFg"

@main
struct ReccoShowcaseApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance

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
