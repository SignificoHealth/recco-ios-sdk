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
    
    @State var font: ReccoFont = .sfPro
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
                        changeSytle(style)
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
            ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        showPaletteSelector.toggle()
                    }, label: {
                        Image("palette_ic")
                            .rotationEffect(.radians(showPaletteSelector ? .pi * 0.5 : 0))
                    })
                
                Picker(
                    selection: $font,
                    content: {
                        ForEach(ReccoFont.allCases, id: \.self){
                            Text($0.rawValue)
                                .font(Font($0.uiFont(size: 16, weight: .regular)))
                        }
                    },
                    label: { EmptyView() }
                )
                .frame(width: 30, height: 30, alignment: .leading)
                .clipped()
                .opacity(0.05)
                .overlay(
                    Image(systemName: "textformat")
                        .foregroundColor(.warmBrown)
                        .allowsHitTesting(false)
                )
            }
        }
        .background(Color.lightGray)
        .animation(.easeInOut(duration: 0.3), value: showPaletteSelector)
        .onChange(of: showingPaletteEditor, perform: { newValue in
            if newValue == false { editingStyleKey = nil }
        })
        .onChange(of: font, perform: { newValue in
            var new = PaletteStorageObservable.shared.storage.selectedStyle
            new.font = newValue
            
            changeSytle(new)
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
    
    private func changeSytle(_ reccoStyle: ReccoStyle) {
        ReccoUI.initialize(clientSecret: clientSecret, style: reccoStyle)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}



