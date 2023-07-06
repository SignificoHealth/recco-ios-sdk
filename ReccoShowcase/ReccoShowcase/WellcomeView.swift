//
//  SwiftUIView.swift
//  ReccoShowcase
//
//  Created by Carmelo J Cortés Alhambra on 5/7/23.
//

import SwiftUI
import ReccoUI

struct WellcomeView: View {
    
    @AppStorage("username") var username: String = ""
    @State var displayRecco: Bool = false
    @State var logoutLoading: Bool = false
    @State var logoutError: Bool = false
        
    var buttonsView: some View {
        VStack(spacing: 16) {
            Button("Go to Recco") {
                displayRecco = true
            }
            .buttonStyle(CallToActionPrimaryStyle())
            
            Button("Logout") {
                logoutLoading = true
                Task {
                    do {
                        try await ReccoUI.logout()
                        username = ""
                    } catch {
                        logoutError = true
                    }
                    logoutLoading = false
                }
            }
            .buttonStyle(CallToActionSecondaryStyle())
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 42) {
            HStack(spacing: 0) {
                VStack {
                    Image("welcome_image1")
                        .padding(.leading, 40)
                    Image("welcome_image2")
                }
                Image("welcome_image3")
            }
            
            Text("Hello __\(username)__! We are the __Significo__ and we want to share with you our exciting new product: __Recco!__")
                .bodyBig()
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            if logoutLoading {
                ProgressView()
            } else {
                buttonsView
            }
        }
        .padding(24)
        .background(Color.lightGray)
        .sheet(isPresented: $displayRecco) {
            SFRootView()
        }
    }
}

/*
struct WellcomeView: View {
    
    @AppStorage("username") var username: String = ""
    @State var displayRecco: Bool = false
    @State var logoutLoading: Bool = false
    @State var logoutError: Bool = false
    
    var companyView: some View {
        VStack() {
            HStack {
                Image("recco_logo")
                Text("by")
            }
            Image("significo_logo")
        }
        .padding(.vertical, 32)
    }
    
    var content: some View {
        VStack(alignment: .center, spacing: 42) {
            companyView
            
            HStack(spacing: 0) {
                VStack {
                    Image("welcome_image1").padding(.leading, 40)
                    Image("welcome_image2")
                }
                Image("welcome_image3")
            }
            
            Text("Hello __\(username)__! We are the __Significo__ and we want to share with you our exciting new product: __Recco!__")
                .bodyBig()
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var buttonsView: some View {
        VStack(spacing: 16) {
            Button("Go to Recco") {
                displayRecco = true
            }
            .buttonStyle(CallToActionPrimaryStyle())
            
            Button("Logout") {
                logoutLoading = true
                Task {
                    do {
                        try await ReccoUI.logout()
                        username = ""
                    } catch {
                        logoutError = true
                    }
                    logoutLoading = false
                }
            }
            .buttonStyle(CallToActionSecondaryStyle())
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            content
            Spacer()
            
            if logoutLoading {
                ProgressView()
            } else {
                buttonsView
            }
        }
        .padding(24)
        .background(Color.lightGray)
        .sheet(isPresented: $displayRecco) {
            SFRootView()
        }
    }
}
*/

struct WellcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WellcomeView()
    }
}



