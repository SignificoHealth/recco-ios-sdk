//
//  SwiftUIView.swift
//  ReccoShowcase
//
//  Created by Carmelo J Cortés Alhambra on 5/7/23.
//

import SwiftUI
import ReccoUI

struct WelcomeView: View {
    
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
            
            Button("logout") {
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
        VStack(spacing: 42) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 24) {
                    CompanyView()

                    HStack(spacing: 0) {
                        VStack {
                            Image("welcome_image1")
                                .padding(.leading, 40)
                            Image("welcome_image2")
                        }
                        Image("welcome_image3")
                    }
                    
                    Text("hello_text_\(username)")
                        .bodyBig()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
            }
            
            if logoutLoading {
                ProgressView()
                    .preferredColorScheme(.light)
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

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}



