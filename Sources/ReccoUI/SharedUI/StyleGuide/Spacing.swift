import CoreGraphics
import Foundation

// swiftlint:disable identifier_name

enum Spacing: CGFloat {
    case xxxs = 4.0
    case xxs = 8.0
    case xs = 12.0
    case s = 16.0
    case m = 24.0
    case l = 32.0
    case xl = 40.0
}

extension CGFloat {
    static var cardSize: CGSize {
        .init(width: 144, height: 256)
    }
    /// 4 pt
    static var XXXS: CGFloat {
        Spacing.xxxs.rawValue
    }

    /// 8 pt
    static var XXS: CGFloat {
        Spacing.xxs.rawValue
    }
    
    /// 12 pt
    static var XS: CGFloat {
        Spacing.xs.rawValue
    }
    
    /// 16 pt
    static var S: CGFloat {
        Spacing.s.rawValue
    }
    
    /// 24 pt
    static var M: CGFloat {
        Spacing.m.rawValue
    }
    
    /// 32 pt
    static var L: CGFloat {
        Spacing.l.rawValue
    }
    
    /// 40 pt
    static var XL: CGFloat {
        Spacing.xl.rawValue
    }
}

// swiftlint:enable identifier_name
