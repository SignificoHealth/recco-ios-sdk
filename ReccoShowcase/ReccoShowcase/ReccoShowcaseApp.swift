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
           AppView()
        }
    }
}

struct AppView: View {
    @AppStorage("username") var username: String = ""
    
    var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var companyView: some View {
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
    
    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                companyView
                    .padding(.top, 75)
                
                if username.isEmpty {
                    SignInView()
                } else {
                    WellcomeView()
                }
            }
        }
    }
}
