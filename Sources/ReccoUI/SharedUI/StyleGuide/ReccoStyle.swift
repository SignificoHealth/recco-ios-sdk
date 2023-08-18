//
//  File.swift
//  
//
//  Created by Adrián R on 20/7/23.
//

import Foundation
import UIKit

var CurrentReccoStyle = ReccoStyle.summer

public enum ReccoFont: String, CaseIterable, Equatable, Hashable, Codable {
    case sfPro = "SF Pro"
    case helveticaNeue = "Helvetica Neue"
    case avenirNext = "Avenir Next"
    case appleSdGothicNeo = "Apple SD Gothic Neo"
    case georgia = "Georgia"
}

extension ReccoFont {
    public func uiFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let sfPro = UIFont.systemFont(ofSize: size, weight: weight)
        
        switch self {
        case .sfPro:
            return sfPro
        case .helveticaNeue:
            return .mimicProperties(of: sfPro, in: "HelveticaNeue", size: size)
        case .avenirNext:
            return .mimicProperties(of: sfPro, in: "AvenirNext-Regular", size: size)
        case .appleSdGothicNeo:
            return .mimicProperties(of: sfPro, in: "AppleSDGothicNeo-Regular", size: size)
        case .georgia:
            return .mimicProperties(of: sfPro, in: "Georgia", size: size)
        }
    }
}

public struct ReccoHexColor: Hashable, Equatable, Codable {
    public init(uiColor: UIColor) {
        self.lightModeHex = uiColor.resolvedColor(with: .init(userInterfaceStyle: .light)).hexString!
        self.darkModeHex = uiColor.resolvedColor(with: .init(userInterfaceStyle: .dark)).hexString!
    }
    
    public init(lightModeHex: String, darkModeHex: String) {
        self.darkModeHex = darkModeHex
        self.lightModeHex = lightModeHex
    }
    
    var darkModeHex: String
    var lightModeHex: String
}

extension ReccoHexColor {
    public var uiColor: UIColor {
        .init(dynamicProvider: { traits in
            traits.userInterfaceStyle == .light ?
                .init(hex: lightModeHex)! :
                .init(hex: darkModeHex)!
        })
    }
}

public struct ReccoStyle: Equatable, Hashable, Codable {
    public struct Color: Equatable, Hashable, Codable {
        public init(primary: ReccoHexColor, onPrimary: ReccoHexColor, background: ReccoHexColor, onBackground: ReccoHexColor, accent: ReccoHexColor, onAccent: ReccoHexColor, illustration: ReccoHexColor, illustrationLine: ReccoHexColor) {
            self.primary = primary
            self.onPrimary = onPrimary
            self.background = background
            self.onBackground = onBackground
            self.accent = accent
            self.onAccent = onAccent
            self.illustration = illustration
            self.illustrationLine = illustrationLine
        }
        
        public var primary: ReccoHexColor
        public var onPrimary: ReccoHexColor
        public var background: ReccoHexColor
        public var onBackground: ReccoHexColor
        public var accent: ReccoHexColor
        public var onAccent: ReccoHexColor
        public var illustration: ReccoHexColor
        public var illustrationLine: ReccoHexColor
    }
   
    public init(
        name: String,
        font: ReccoFont = .sfPro,
        color: ReccoStyle.Color
    ) {
        self.font = font
        self.name = name
        self.color = color
    }
    
    public let name: String
    public var font: ReccoFont
    public var color: ReccoStyle.Color
}

extension ReccoStyle {
    public static var ocean: ReccoStyle {
        ReccoStyle(
            name: "Ocean",
            color: .init(
                primary: .init(lightModeHex: "#125e85FF", darkModeHex: "#ceeeffFF"),
                onPrimary: .init(lightModeHex: "#FFFFFFFF", darkModeHex: "#263743FF"),
                background: .init(lightModeHex: "#ecf8feFF", darkModeHex: "#263743FF"),
                onBackground: .init(lightModeHex: "#0c5175FF", darkModeHex: "#e4f6ffFF"),
                accent: .init(lightModeHex: "#35b9ffFF", darkModeHex: "#35b9ffFF"),
                onAccent: .init(lightModeHex: "#17445bFF", darkModeHex: "#e4f6ffFF"),
                illustration: .init(lightModeHex: "#f5a08cFF", darkModeHex: "#35b9ffFF"),
                illustrationLine: .init(lightModeHex: "#105a81FF", darkModeHex: "#1e8cc7FF")
            )
        )
    }
    
    public static var summer: ReccoStyle {
        ReccoStyle(
            name: "Summer",
            color: .init(
                primary: .init(lightModeHex: "#383B45FF", darkModeHex: "#FFE6B0FF"),
                onPrimary: .init(lightModeHex: "#FFFFFFFF", darkModeHex: "#383b45FF"),
                background: .init(lightModeHex: "#fcfcfcFF", darkModeHex: "#383b45FF"),
                onBackground: .init(lightModeHex: "#383b45FF", darkModeHex: "#ffffffff"),
                accent: .init(lightModeHex: "#7b61ffff", darkModeHex: "#7b61ffff"),
                onAccent: .init(lightModeHex: "#2c2783ff", darkModeHex: "#ffe5aeff"),
                illustration: .init(lightModeHex: "#f5b731ff", darkModeHex: "#f5b731ff"),
                illustrationLine: .init(lightModeHex: "#454138ff", darkModeHex: "#454138ff")
            )
        )
    }
    
    public static var spring: ReccoStyle {
        ReccoStyle(
            name: "Spring",
            color: .init(
                primary: .init(lightModeHex: "#2c956dFF", darkModeHex: "#ffddbeFF"),
                onPrimary: .init(lightModeHex: "#ffffffFF", darkModeHex: "#383b45FF"),
                background: .init(lightModeHex: "#fcfcfcFF", darkModeHex: "#383b45FF"),
                onBackground: .init(lightModeHex: "#383b45FF", darkModeHex: "#ffffffFF"),
                accent: .init(lightModeHex: "#ea8822FF", darkModeHex: "#3ba17aFF"),
                onAccent: .init(lightModeHex: "#2c2783FF", darkModeHex: "#ffe5aeFF"),
                illustration: .init(lightModeHex: "#ffc188FF", darkModeHex: "#ffc188FF"),
                illustrationLine: .init(lightModeHex: "#306d49FF", darkModeHex: "#926500FF")
            )
        )
    }
    
    public static var tech: ReccoStyle {
        ReccoStyle(
            name: "Tech",
            color: .init(
                primary: .init(lightModeHex: "#2c956dFF", darkModeHex: "#e5e4a3FF"),
                onPrimary: .init(lightModeHex: "#ffffffFF", darkModeHex: "#373733FF"),
                background: .init(lightModeHex: "#f8f9f4FF", darkModeHex: "#242422FF"),
                onBackground: .init(lightModeHex: "#383b45FF", darkModeHex: "#e5e4a3FF"),
                accent: .init(lightModeHex: "#bab714FF", darkModeHex: "#e6e452FF"),
                onAccent: .init(lightModeHex: "#6a6d65FF", darkModeHex: "#ffffffFF"),
                illustration: .init(lightModeHex: "#f5b731FF", darkModeHex: "#f5b731FF"),
                illustrationLine: .init(lightModeHex: "#403f15FF", darkModeHex: "#403f15FF")
            )
        )
    }
}