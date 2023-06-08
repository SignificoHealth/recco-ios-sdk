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

    var currentUserDisplay: String {
        currentUser.isEmpty ?
        "Not logged in" :
        currentUser
    }
    
    var body: some View {
        NavigationView {
            List {
                Text("Current User: ") +
                Text(currentUserDisplay).bold()
                Button {
                    UIApplication.shared.windows.first?.rootViewController?.present(GestureDismissableSFDashboard(), animated: true)
                } label: {
                    Text("Show Dashboard")
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
            .sheet(isPresented: $showConfigurationView) {
                ConfigurationView(user: $currentUser)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
