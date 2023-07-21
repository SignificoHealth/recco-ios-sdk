//
//  File.swift
//  
//
//  Created by Adrián R on 20/7/23.
//

import Foundation
import UIKit

var Theme = ReccoTheme.fresh

public struct ReccoTheme {
    public init(color: ReccoTheme.Color) {
        self.color = color
    }
    
    public struct Color {
        public init(primary: UIColor, onPrimary: UIColor, background: UIColor, onBackground: UIColor, accent: UIColor, onAccent: UIColor, illustration: UIColor, illustrationLine: UIColor) {
            self.primary = primary
            self.onPrimary = onPrimary
            self.background = background
            self.onBackground = onBackground
            self.accent = accent
            self.onAccent = onAccent
            self.illustration = illustration
            self.illustrationLine = illustrationLine
        }
        
        public var primary: UIColor
        public var onPrimary: UIColor
        public var background: UIColor
        public var onBackground: UIColor
        public var accent: UIColor
        public var onAccent: UIColor
        public var illustration: UIColor
        public var illustrationLine: UIColor
    }
    
    public var color: ReccoTheme.Color
}

extension ReccoTheme {
    public static var summer: ReccoTheme {
        ReccoTheme(
            color: .init(
                primary: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#125e85FF")! :
                        .init(hex: "#ceeeffFF")!
                        
                }),
                onPrimary: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#FFFFFFFF")! :
                        .init(hex: "#263743FF")!
                }),
                background: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#ecf8feFF")! :
                        .init(hex: "#263743FF")!
                }),
                onBackground: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#0c5175FF")! :
                        .init(hex: "#e4f6ffFF")!
                }),
                accent: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#35b9ffFF")! :
                        .init(hex: "#35b9ffFF")!
                }),
                onAccent: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#17445bFF")! :
                        .init(hex: "#e4f6ffFF")!
                }),
                illustration: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#f5a08cFF")! :
                        .init(hex: "#35b9ffFF")!
                }),
                illustrationLine: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#105a81FF")! :
                        .init(hex: "#1e8cc7FF")!
                })
            )
        )
    }
    
    public static var fresh: ReccoTheme {
        ReccoTheme(
            color: .init(
                primary: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#383B45FF")! :
                        .init(hex: "#FFE6B0FF")!
                        
                }),
                onPrimary: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#FFFFFFFF")! :
                        .init(hex: "#383b45FF")!
                }),
                background: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#fcfcfcFF")! :
                        .init(hex: "#383b45FF")!
                }),
                onBackground: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#383b45FF")! :
                        .init(hex: "#ffffffff")!
                }),
                accent: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#7b61ffff")! :
                        .init(hex: "#7b61ffff")!
                }),
                onAccent: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#2c2783ff")! :
                        .init(hex: "#ffe5aeff")!
                }),
                illustration: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#f5b731ff")! :
                        .init(hex: "#f5b731ff")!
                }),
                illustrationLine: .init(dynamicProvider: { traits in
                    traits.userInterfaceStyle == .light ?
                        .init(hex: "#454138ff")! :
                        .init(hex: "#454138ff")!
                })
            )
        )
    }
}
