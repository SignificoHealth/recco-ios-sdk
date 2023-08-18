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
    @State var editingStyleKey: String? = nil

    var buttonsView: some View {
        VStack(spacing: 16) {
            Button("go_to_sdk") {
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
            
            if showPaletteSelector {
                ChangeReccoStyleView(
                    showingPaletteEditor: $showingPaletteEditor,
                    editingStyleKey: $editingStyleKey,
                    onTap: { style in
                        ReccoUI.initialize(clientSecret: clientSecret, style: style)
                        
                        showPaletteSelector.toggle()
                    },
                    dismiss: { showPaletteSelector = false }
                )
                .zIndex(10)
                .transition(.move(edge: .top))
                .padding(.leading, 20)
            }
        }
        .padding(24)
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showPaletteSelector.toggle()
                }, label: {
                    Image("palette_ic")
                        .rotationEffect(.radians(showPaletteSelector ? .pi * 0.5 : 0))
                })
            }
        }
        .background(Color.lightGray)
        .animation(.easeInOut(duration: 0.3), value: showPaletteSelector)
        .onChange(of: showingPaletteEditor, perform: { newValue in
            if newValue == false { editingStyleKey = nil }
        })
        .ignoresSafeArea()
        .sheet(isPresented: $displayRecco) {
            ReccoRootView()
        }
        .sheet(isPresented: $showingPaletteEditor) {
            CreatePaletteView(
                styleKey: editingStyleKey,
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



