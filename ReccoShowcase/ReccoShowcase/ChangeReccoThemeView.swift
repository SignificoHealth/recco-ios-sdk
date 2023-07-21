//
//  ChangeReccoThemeView.swift
//  ReccoShowcase
//
//  Created by Adrián R on 21/7/23.
//

import SwiftUI
import ReccoUI

extension ColorScheme {
    var icon: String {
        return self == .light ?
            "sun_ic" : "moon_ic"
    }
    
    var bgColor: Color {
        return self == .light ? .white : .black
    }
    
    var fgColor: Color {
        return self == .light ? .black : .white
    }
}

struct ChangeReccoThemeView: View {
    var onTap: (ReccoTheme) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: -1) {
                HStack(spacing: 0) {
                    ForEach([ColorScheme.light, .dark], id: \.self) { colorScheme in
                        Image(colorScheme.icon)
                            .frame(width: 60)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 6)
                            .padding(.top, 12)
                            .background(colorScheme.bgColor)
                    }
                }
                
                VStack(spacing: 0) {
                    ForEach([ReccoTheme.fresh, ReccoTheme.summer], id: \.self) { theme in
                        Button(action: { onTap(theme) }) {
                            HStack(spacing: 0) {
                                ForEach([ColorScheme.light, .dark], id: \.self) { colorScheme in
                                    themeItem(theme, scheme: colorScheme)
                                        .frame(width: 60)
                                        .padding(12)
                                        .background(colorScheme.bgColor)
                                        .environment(\.colorScheme, colorScheme)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.white)
        }
    }
    
    @ViewBuilder
    func themeItem(_ theme: ReccoTheme, scheme: ColorScheme) -> some View {
        VStack {
            Text(theme.name)
                .textCase(.uppercase)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(scheme.fgColor)
            
            themeItemColors(theme, scheme: scheme)
        }
    }
    
    @ViewBuilder
    func themeItemColors(_ theme: ReccoTheme, scheme: ColorScheme) -> some View {
        LazyVGrid(columns: gridLayout, spacing: 0) {
            ForEach([
                theme.color.primary,
                theme.color.onPrimary,
                theme.color.accent,
                theme.color.onAccent,
                theme.color.background,
                theme.color.onBackground
            ], id: \.self) { item in
                Rectangle()
                    .fill(Color(item))
                    .frame(width: 28, height: 28)
                    .border(scheme.fgColor, width: 1)
            }
        }
    }
    
    private let gridLayout = [
        GridItem(.fixed(28), spacing: 0, alignment: .top),
        GridItem(.fixed(28), spacing: 0, alignment: .top)
    ]
}

struct ChangeReccoThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeReccoThemeView(onTap: { theme in
            
        })
    }
}
