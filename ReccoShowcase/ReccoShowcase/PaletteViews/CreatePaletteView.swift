//
//  CreatePaletteView.swift
//  ReccoShowcase
//
//  Created by Adrián R on 27/7/23.
//

import Foundation
import SwiftUI
import ReccoUI

enum PalleteType: Hashable {
    case light
    case dark
}

extension PalleteType {
    var name: String {
        return self == .light ?
            "Light" : "Dark"
    }
    
    var colorScheme: ColorScheme {
        return self == .light ? .light : .dark
    }
}

struct CreatePaletteView: View {
    @ObservedObject var storageState: PaletteStorageObservable = .shared
    @Binding var shouldShow: Bool
    
    private var themeKey: String?
    
    @State var tabSelection: PalleteType = .light
    @State var themeName: String
    @State var primaryLight: Color
    @State var onPrimaryLight: Color
    @State var accentLight: Color
    @State var onAccentLight: Color
    @State var backgroundLight: Color
    @State var onBackgroundLight: Color
    @State var illustrationLight: Color
    @State var illustrationOutlineLight: Color
    @State var primaryDark: Color
    @State var onPrimaryDark: Color
    @State var accentDark: Color
    @State var onAccentDark: Color
    @State var backgroundDark: Color
    @State var onBackgroundDark: Color
    @State var illustrationDark: Color
    @State var illustrationOutlineDark: Color

    internal init(
        themeKey: String? = nil,
        shouldShow: Binding<Bool>
    ) {
        let theme = themeKey.flatMap {
            PaletteStorageObservable.shared.storage.palettes[$0]
        } ?? .summer
                
        self.themeKey = themeKey
        self._shouldShow = shouldShow
        self._themeName = .init(initialValue: theme.name == ReccoTheme.summer.name ? "" : theme.name)
        self.primaryLight = Color(theme.color.primary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.onPrimaryLight = Color(theme.color.onPrimary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.accentLight = Color(theme.color.accent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.onAccentLight = Color(theme.color.onAccent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.backgroundLight = Color(theme.color.background.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.onBackgroundLight = Color(theme.color.onBackground.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.illustrationLight = Color(theme.color.illustration.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.illustrationOutlineLight = Color(theme.color.illustrationLine.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.primaryDark = Color(theme.color.primary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.onPrimaryDark = Color(theme.color.onPrimary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.accentDark = Color(theme.color.accent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.onAccentDark = Color(theme.color.onAccent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.backgroundDark = Color(theme.color.background.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.onBackgroundDark = Color(theme.color.onBackground.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.illustrationDark = Color(theme.color.illustration.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.illustrationOutlineDark = Color(theme.color.illustrationLine.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(alignment: .leading) {
                    Text("theme_name")
                        .inputTitle()
                    
                    TextField("theme_name_placeholder", text: $themeName)
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(.warmBrown)
                        .keyboardType(.alphabet)
                        .autocorrectionDisabled(true)
                        .cornerRadius(8)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)
                        .preferredColorScheme(.light)
                }
                
                Picker(
                    "",
                    selection: $tabSelection
                ) {
                    Text(PalleteType.light.name).tag(PalleteType.light)
                    Text(PalleteType.dark.name).tag(PalleteType.dark)
                }
                .pickerStyle(.segmented)
                
                GeometryReader { proxy in
                    TabView(selection: $tabSelection) {
                        lightPaletteView
                            .padding(.horizontal, 2)
                            .tag(PalleteType.light)
                        
                        darkPaletteView                            .padding(.horizontal, 2)
                            .tag(PalleteType.dark)
                    }
                    .frame(width: proxy.size.width, height: 360)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .frame(height: 360)
            }
            .padding()
            .font(.body)
            
            Button("Save Theme") {
                let key = themeKey ?? UUID().uuidString
                storageState.storage.palettes[key] = ReccoTheme(
                    name: themeName,
                    color: .init(
                        primary: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(primaryLight) : UIColor(primaryDark)

                        })),
                        onPrimary: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(onPrimaryLight) : UIColor(onPrimaryDark)

                        })),
                        background: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(backgroundLight) : UIColor(backgroundDark)

                        })),
                        onBackground: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(onBackgroundLight) : UIColor(onBackgroundDark)

                        })),
                        accent: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(accentLight) : UIColor(accentDark)

                        })),
                        onAccent: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(onAccentLight) : UIColor(onAccentDark)

                        })),
                        illustration: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(illustrationLight) : UIColor(illustrationDark)

                        })),
                        illustrationLine: .init(uiColor: .init(dynamicProvider: { traits in
                            traits.userInterfaceStyle == .light ? UIColor(illustrationOutlineLight) : UIColor(illustrationOutlineDark)

                        }))
                    )
                )
                
                storageState.storage.store()                
                shouldShow = false
            }
            .buttonStyle(CallToActionPrimaryStyle())
            .padding()
            .disabled(themeName.isEmpty)
        }
        .background(
            Color.lightGray.ignoresSafeArea()
        )
    }
    
    @ViewBuilder
    var lightPaletteView: some View {
        VStack(spacing: 32) {
            colorPairView(
                colorName: "Primary",
                $primaryLight,
                onColorName: "On Primary",
                $onPrimaryLight
            )
            
            colorPairView(
                colorName: "Background",
                $backgroundLight,
                onColorName: "On Background",
                $onBackgroundLight
            )
            
            colorPairView(
                colorName: "Accent",
                $accentLight,
                onColorName: "On Accent",
                $onAccentLight
            )
            
            colorPairView(
                colorName: "Illustration Outline",
                $illustrationOutlineLight,
                onColorName: "Illustration",
                $illustrationLight
            )
        }
        .environment(\.colorScheme, ColorScheme.light)
    }
    
    @ViewBuilder
    var darkPaletteView: some View {
        VStack(spacing: 32) {
            colorPairView(
                colorName: "Primary",
                $primaryDark,
                onColorName: "On Primary",
                $onPrimaryDark
            )
            
            colorPairView(
                colorName: "Background",
                $backgroundDark,
                onColorName: "On Background",
                $onBackgroundDark
            )
            
            colorPairView(
                colorName: "Accent",
                $accentDark,
                onColorName: "On Accent",
                $onAccentDark
            )
            
            colorPairView(
                colorName: "Illustration Outline",
                $illustrationOutlineDark,
                onColorName: "Illustration",
                $illustrationDark
            )
        }
        .environment(\.colorScheme, ColorScheme.dark)
    }
    
    @ViewBuilder
    func colorPairView(
        colorName: String,
        _ color: Binding<Color>,
        onColorName: String,
        _ onColor: Binding<Color>
    ) -> some View {
        HStack {
            VStack {
                ColorPicker(selection: color) {
                    Text(colorName)
                        .foregroundColor(.black)
                }
                
                ColorPicker(selection: onColor) {
                    Text(onColorName)
                        .foregroundColor(.black)
                }
            }
            
            Spacer(minLength: 100)
            
            Circle()
                .fill(color.wrappedValue)
                .overlay(
                    Circle()
                        .fill(onColor.wrappedValue)
                        .padding(18)
                )
                .frame(width: 65)
                .overlay(
                    Circle()
                        .stroke()
                        .fill(Color.warmBrown)
                )
        }
    }
}

struct CreatePaletteView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePaletteView( shouldShow: .constant(true))
    }
}
