//
//  CreatePaletteView.swift
//  ReccoShowcase
//
//  Created by Adrián R on 27/7/23.
//

import Foundation
import ReccoUI
import SwiftUI

enum PalleteType: Hashable {
    case light
    case dark
}

extension PalleteType {
    var name: String {
        self == .light ?
            "light" : "dark"
    }

    var colorScheme: ColorScheme {
        self == .light ? .light : .dark
    }
}

struct CreatePaletteView: View {
    @ObservedObject var storageState: PaletteStorageObservable = .shared
    @Binding var shouldShow: Bool

    private var styleKey: String?

    @State var tabSelection: PalleteType = .light
    @State var styleName: String
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
        styleKey: String? = nil,
        shouldShow: Binding<Bool>
    ) {
        let style = styleKey.flatMap {
            PaletteStorageObservable.shared.storage.palettes[$0]
        } ?? .fresh

        self.styleKey = styleKey
        self._shouldShow = shouldShow
        self._styleName = .init(initialValue: style.name == ReccoStyle.fresh.name ? "" : style.name)
        self.primaryLight = Color(style.color.primary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.onPrimaryLight = Color(style.color.onPrimary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.accentLight = Color(style.color.accent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.onAccentLight = Color(style.color.onAccent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.backgroundLight = Color(style.color.background.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.onBackgroundLight = Color(style.color.onBackground.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.illustrationLight = Color(style.color.illustration.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.illustrationOutlineLight = Color(style.color.illustrationLine.uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)))
        self.primaryDark = Color(style.color.primary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.onPrimaryDark = Color(style.color.onPrimary.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.accentDark = Color(style.color.accent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.onAccentDark = Color(style.color.onAccent.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.backgroundDark = Color(style.color.background.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.onBackgroundDark = Color(style.color.onBackground.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.illustrationDark = Color(style.color.illustration.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
        self.illustrationOutlineDark = Color(style.color.illustrationLine.uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text(styleKey == nil ? "new_theme" : "edit_theme")
                    .font(.system(.title))
                    .bold()
                    .foregroundColor(.warmBrown)

                VStack(alignment: .leading) {
                    Text("theme_name")
                        .inputTitle()

                    TextField("theme_name_placeholder", text: $styleName)
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
                    Text(.init(PalleteType.light.name)).tag(PalleteType.light)
                    Text(.init(PalleteType.dark.name)).tag(PalleteType.dark)
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

            Button("save_theme") {
                let key = styleKey ?? UUID().uuidString
                storageState.storage.palettes[key] = ReccoStyle(
                    name: styleName,
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
            .disabled(styleName.isEmpty)
        }
        .background(
            Color.lightGray.ignoresSafeArea()
        )
    }

    @ViewBuilder
    var lightPaletteView: some View {
        VStack(spacing: 32) {
            colorPairView(
                colorName: "color_primary",
                $primaryLight,
                onColorName: "color_on_primary",
                $onPrimaryLight
            )

            colorPairView(
                colorName: "color_background",
                $backgroundLight,
                onColorName: "color_on_background",
                $onBackgroundLight
            )

            colorPairView(
                colorName: "color_accent",
                $accentLight,
                onColorName: "color_on_accent",
                $onAccentLight
            )

            colorPairView(
                colorName: "color_illustration_outline",
                $illustrationOutlineLight,
                onColorName: "color_illustration",
                $illustrationLight
            )
        }
        .environment(\.colorScheme, ColorScheme.light)
    }

    @ViewBuilder
    var darkPaletteView: some View {
        VStack(spacing: 32) {
            colorPairView(
                colorName: "color_primary",
                $primaryDark,
                onColorName: "color_on_primary",
                $onPrimaryDark
            )

            colorPairView(
                colorName: "color_background",
                $backgroundDark,
                onColorName: "color_on_background",
                $onBackgroundDark
            )

            colorPairView(
                colorName: "color_accent",
                $accentDark,
                onColorName: "color_on_accent",
                $onAccentDark
            )

            colorPairView(
                colorName: "color_illustration_outline",
                $illustrationOutlineDark,
                onColorName: "color_illustration",
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
                    Text(.init(colorName))
                        .foregroundColor(.black)
                }

                ColorPicker(selection: onColor) {
                    Text(.init(onColorName))
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
