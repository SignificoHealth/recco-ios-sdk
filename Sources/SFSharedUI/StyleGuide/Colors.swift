//
//  Colors.swift
//  
//
//  Created by Adrián R on 13/7/22.
//

import Foundation
import SFResources
import SwiftUI

// MARK: Main

public extension UIColor {
    static let sfPrimary: UIColor = .init(resource: "sfPrimary")!
    static let sfAccent: UIColor = .init(resource: "sfAccent")!
    static let sfBackground: UIColor = .init(resource: "sfBackground")!
    static let sfIllustration: UIColor = .init(resource: "sfIllustration")!
    static let sfOnAccent: UIColor = .init(resource: "sfOnAccent")!
    static let sfOnBackground: UIColor = .init(resource: "sfOnBackground")!
    static let sfOnPrimary: UIColor = .init(resource: "sfOnPrimary")!
    static let sfOnSurface: UIColor = .init(resource: "sfOnSurface")!
    static let sfSurface: UIColor = .init(resource: "sfSurface")!
}

public extension Color {
    static let sfPrimary: Color = .init(.sfPrimary)
    static let sfAccent: Color = .init(.sfAccent)
    static let sfBackground: Color = .init(.sfBackground)
    static let sfIllustration: Color = .init(.sfIllustration)
    static let sfOnAccent: Color = .init(.sfOnAccent)
    static let sfOnBackground: Color = .init(.sfOnBackground)
    static let sfOnPrimary: Color = .init(.sfOnPrimary)
    static let sfOnSurface: Color = .init(.sfOnSurface)
    static let sfSurface: Color = .init(.sfSurface)
}

// MARK: Derivation

public extension UIColor {
    static var sfPrimary10: UIColor =
        .sfPrimary.withAlphaComponent(0.1)
    static var sfPrimary20: UIColor =
        .sfPrimary.withAlphaComponent(0.2)
    static var sfPrimary40: UIColor =
        .sfPrimary.withAlphaComponent(0.4)
    static var sfPrimary60: UIColor =
        .sfPrimary.withAlphaComponent(0.6)
    static let sfPrimary80: UIColor =
        .sfPrimary.withAlphaComponent(0.8)
    static let sfOnBackground60 = UIColor.sfOnBackground.withAlphaComponent(0.6)
    static let sfOnBackground20 = UIColor.sfOnBackground.withAlphaComponent(0.2)
    static let sfAccent10 = UIColor.sfAccent.withAlphaComponent(0.1)
    static let sfAccent20 = UIColor.sfAccent.withAlphaComponent(0.2)
    static let sfAccent40 = UIColor.sfAccent.withAlphaComponent(0.4)
    static let sfAccent60 = UIColor.sfAccent.withAlphaComponent(0.6)
}

extension Color {
    static let sfPrimary10: Color = Color(.sfPrimary10)
    static let sfPrimary20: Color = Color(.sfPrimary20)
    static let sfPrimary40: Color = Color(.sfPrimary40)
    static let sfPrimary60: Color = Color(.sfPrimary60)
    static let sfPrimary80: Color = Color(.sfPrimary80)
    static let sfOnBackground60 = Color(.sfOnBackground60)
    static let sfOnBackground20 = Color(.sfOnBackground20)
    static let sfAccent10 = Color(.sfAccent10)
    static let sfAccent20 = Color(.sfAccent20)
    static let sfAccent40 = Color(.sfAccent40)
    static let sfAccent60 = Color(.sfAccent60)
}

struct ColorsName_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach([Color.sfPrimary, .sfPrimary10, .sfPrimary20, .sfPrimary40, .sfPrimary60, .sfPrimary80, .sfAccent, .sfAccent10, .sfAccent20, .sfAccent40, .sfAccent60, .sfSurface, .sfBackground, .sfIllustration, .sfOnAccent, .sfOnPrimary, .sfOnSurface, .sfOnBackground, .sfOnBackground20, .sfOnBackground60], id: \.self) { color in
                        Rectangle()
                            .fill(color)
                            .frame(width: 20, height: 20)
                            .border(Color.black)
                }
                
            }
        }
        .padding()
    }
}
