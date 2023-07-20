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
    public struct Color {
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.uppercased().index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
