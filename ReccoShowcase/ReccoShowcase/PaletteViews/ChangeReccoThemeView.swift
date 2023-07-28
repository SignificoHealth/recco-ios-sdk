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
    @ObservedObject var storageObsevable: PaletteStorageObservable = .shared
    @Binding var showingPaletteEditor: Bool
    @Binding var editingThemeKey: String?

    var onTap: (ReccoTheme) -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: -1) {
                HStack(spacing: 0) {
                    ForEach([ColorScheme.light, .dark], id: \.self) { colorScheme in
                        Image(colorScheme.icon)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                            .background(colorScheme.bgColor)
                    }
                }
                .frame(width: 210, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach([ReccoTheme.ocean, .summer, .spring, .tech], id: \.self) { theme in
                        editableThemeItem(theme, editable: false, key: "")
                    }
                    
                    ForEach(Array(storageObsevable.storage.palettes.keys), id: \.self) { key in
                        editableThemeItem(storageObsevable.storage.palettes[key]!, editable: true, key: key)
                    }
                }
                
                Button {
                    showingPaletteEditor = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.warmBrown)
                        
                        Text("New palette")
                            .bold()
                            .bodyBig()
                            .padding(.vertical)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .frame(width: 210, alignment: .leading)
            }
            .frame(width: 260, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private func editableThemeItem(_ theme: ReccoTheme, editable: Bool, key: String) -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach([ColorScheme.light, .dark], id: \.self) { colorScheme in
                    themeItem(theme, scheme: colorScheme)
                        .padding(12)
                        .background(colorScheme.bgColor)
                        .environment(\.colorScheme, colorScheme)
                }
            }
            .frame(width: 210, alignment: .leading)
            .onTapGesture {
                onTap(theme)
            }
            
            if editable {
                Button {
                    editingThemeKey = key
                    showingPaletteEditor = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    storageObsevable.storage.palettes[key] = nil
                    storageObsevable.storage.store()
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.white)
                }
            }
        }
    }
    
    @ViewBuilder
    private func themeItem(_ theme: ReccoTheme, scheme: ColorScheme) -> some View {
        VStack {
            Text(theme.name)
                .textCase(.uppercase)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(scheme.fgColor)
            
            themeItemColors(theme, scheme: scheme)
        }
    }
    
    @ViewBuilder
    private func themeItemColors(_ theme: ReccoTheme, scheme: ColorScheme) -> some View {
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
                    .fill(Color(item.uiColor))
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
        ChangeReccoThemeView(
            showingPaletteEditor: .constant(false),
            editingThemeKey: .constant(nil),
            onTap: { theme in }
        )
        .background(Color.gray)
    }
}
