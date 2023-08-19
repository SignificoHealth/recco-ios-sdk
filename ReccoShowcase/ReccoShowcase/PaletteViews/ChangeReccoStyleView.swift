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

struct ChangeReccoStyleView: View {
    @ObservedObject var storageObsevable: PaletteStorageObservable = .shared
    @Binding var showingPaletteEditor: Bool
    @Binding var editingStyleKey: String?

    var onTap: (ReccoStyle) -> Void
    var dismiss: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: -1) {
                HStack(spacing: 0) {
                    ForEach([ColorScheme.light, .dark], id: \.self) { colorScheme in
                        Image(colorScheme.icon)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(colorScheme.bgColor)
                    }
                }
                .frame(width: 210, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach([ReccoStyle.ocean, .fresh, .spring, .tech], id: \.self) { style in
                        editableStyleItem(style, editable: false, key: style.name)
                    }
                    
                    ForEach(Array(storageObsevable.storage.palettes.keys), id: \.self) { key in
                        editableStyleItem(storageObsevable.storage.palettes[key]!, editable: true, key: key)
                    }
                }
                
                Button {
                    showingPaletteEditor = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.warmBrown)
                        
                        Text("new_theme")
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
            .background(
                Color.black.opacity(0.0001)
                    .onTapGesture {
                        dismiss()
                    }
            )
        }
    }
    
    @ViewBuilder
    private func editableStyleItem(_ style: ReccoStyle, editable: Bool, key: String) -> some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    storageObsevable.storage.selectedKeyOrName = key
                    storageObsevable.storage.store()
                }
                onTap(style)
            } label: {
                HStack(spacing: 0) {
                    ForEach([ColorScheme.light, .dark], id: \.self) { colorScheme in
                        styleItem(style, scheme: colorScheme)
                            .padding(12)
                            .background(colorScheme.bgColor)
                            .environment(\.colorScheme, colorScheme)
                    }
                }
                .frame(width: 210, alignment: .leading)
            }
            .overlay(
                Group {
                    if storageObsevable.storage.selectedKeyOrName == key {
                        Rectangle()
                            .stroke(lineWidth: 4)
                            .fill(Color.softYellow)
                            .padding(2)
                    }
                }
            )
            .background(Color.white)
            
            if editable {
                Button {
                    editingStyleKey = key
                    showingPaletteEditor = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.white)
                }
                
                Button {
                    withAnimation {
                        storageObsevable.storage.palettes[key] = nil
                    }
                    
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
    private func styleItem(_ style: ReccoStyle, scheme: ColorScheme) -> some View {
        VStack {
            Text(style.name)
                .textCase(.uppercase)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(scheme.fgColor)
            
            styleItemColors(style, scheme: scheme)
        }
    }
    
    @ViewBuilder
    private func styleItemColors(_ style: ReccoStyle, scheme: ColorScheme) -> some View {
        LazyVGrid(columns: gridLayout, spacing: 0) {
            ForEach([
                style.color.primary,
                style.color.onPrimary,
                style.color.accent,
                style.color.onAccent,
                style.color.background,
                style.color.onBackground
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

struct ChangeReccoStyleView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeReccoStyleView(
            showingPaletteEditor: .constant(false),
            editingStyleKey: .constant(nil),
            onTap: { theme in },
            dismiss: {}
        )
        .background(Color.gray)
    }
}
