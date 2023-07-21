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
    @State var showPaletteSelector = false
        
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
                    HStack(alignment: .top) {
                        Button(action: {
                            withAnimation(.linear(duration: 0.3)) {
                                showPaletteSelector.toggle()
                            }
                        }, label: {
                            Image("palette_ic")
                        })

                        Spacer()
                        
                        CompanyView()
                        
                        Spacer()
                        Spacer()
                    }
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
        .overlay(
            ZStack {
                if showPaletteSelector {
                    ChangeReccoThemeView(onTap: { theme in
                        ReccoUI.initialize(clientSecret: "yvU5m39iXgVtOOKSQqz8neU5mP5HkOamKKMhcX5FDdBE6s6lmrdkC87XQr5dApi5r-vVOFo", theme: theme)
                        withAnimation(.linear(duration: 0.3)) {
                            showPaletteSelector.toggle()
                        }
                    })
                    .padding(.leading, 66)
                    .padding(.top, 23)
                }
            }
            .transition(.opacity),
            alignment: .topLeading
        )
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



