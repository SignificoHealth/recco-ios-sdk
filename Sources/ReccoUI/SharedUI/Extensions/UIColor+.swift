import Foundation
import UIKit

extension UIColor {
    func solidColorWith(background: UIColor) -> UIColor {
        func clampValue(_ v: CGFloat) -> CGFloat {
            guard v > 0 else { return  0 }
            guard v < 1 else { return  1 }
            return v
        }
        
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        background.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        r1 = clampValue(r1)
        g1 = clampValue(g1)
        b1 = clampValue(b1)
        
        r2 = clampValue(r2)
        g2 = clampValue(g2)
        b2 = clampValue(b2)
        a2 = clampValue(a2)
        
        return UIColor(  red  : r1 * (1 - a2) + r2 * a2,
                         green: g1 * (1 - a2) + g2 * a2,
                         blue : b1 * (1 - a2) + b2 * a2,
                         alpha: 1)
    }
    
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
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            ).appending("FF")
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
