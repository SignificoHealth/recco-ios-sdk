//
//  ContentView.swift
//  SFTestApp
//
//  Created by Adrián R on 25/5/23.
//

import SwiftUI
import SignificoSF

struct ContentView: View {
    @AppStorage("loggedUser") var currentUser: String = ""
    @State var showConfigurationView: Bool = false
    @State var showFullscreenDashboard: Bool = false
    @State var showSheetDashboard: Bool = false

    var currentUserDisplay: String {
        currentUser.isEmpty ?
        "Not logged in" :
        currentUser
    }
    
    var window: UIWindow? {
        UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .first(where: { $0 is UIWindowScene })
        .flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: \.isKeyWindow)
    }
    
    var body: some View {
        NavigationView {
            List {
                Text("Current User: ") +
                Text(currentUserDisplay).bold()
                
                Button {
                    showSheetDashboard = true
                } label: {
                    Text("Show Dashboard partially")
                        .bold()
                }
                
                Button {
                    showFullscreenDashboard = true
                } label: {
                    Text("Show Dashboard full scren")
                        .bold()
                }
            }
            .navigationTitle("SFShowcase")
            .toolbar {
                ToolbarItem {
                    Button {
                        showConfigurationView = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSheetDashboard) {
                SFRootView()
            }
            .sheet(isPresented: $showConfigurationView) {
                ConfigurationView(user: $currentUser)
            }
            .fullScreenCover(isPresented: $showFullscreenDashboard) {
                SFRootView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
