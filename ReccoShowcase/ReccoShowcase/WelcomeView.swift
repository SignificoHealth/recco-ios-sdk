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
    @State var showingPaletteEditor = false
    @State var editingThemeKey: String? = nil

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
        ZStack {
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
            .overlay(
                Button(action: {
                    showPaletteSelector.toggle()
                }, label: {
                    Image("palette_ic")
                        .rotationEffect(.radians(showPaletteSelector ? .pi * 0.5 : 0))
                })
                .frame(
                    width: 60,
                    height: 60,
                    alignment: .leading
                )
                .contentShape(Rectangle()),
                alignment: .topLeading
            )
            
            if showPaletteSelector {
                ChangeReccoThemeView(
                    showingPaletteEditor: $showingPaletteEditor,
                    editingThemeKey: $editingThemeKey,
                    onTap: { theme in
                        ReccoUI.initialize(clientSecret: "yvU5m39iXgVtOOKSQqz8neU5mP5HkOamKKMhcX5FDdBE6s6lmrdkC87XQr5dApi5r-vVOFo", theme: theme)
                        
                        showPaletteSelector.toggle()
                    }
                )
                .zIndex(10)
                .transition(.move(edge: .top))
                .padding(.leading, 20)
            }
        }
        .padding(24)
        .background(
            Color.black.opacity(showPaletteSelector ? 0.4 : 0)
                .ignoresSafeArea()
        )
        .background(Color.lightGray)
        .animation(.easeInOut(duration: 0.3), value: showPaletteSelector)
        .onChange(of: showingPaletteEditor, perform: { newValue in
            if newValue == false { editingThemeKey = nil }
        })
        .sheet(isPresented: $displayRecco) {
            SFRootView()
        }
        .sheet(isPresented: $showingPaletteEditor) {
            CreatePaletteView(
                themeKey: editingThemeKey,
                shouldShow: $showingPaletteEditor
            )
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}



