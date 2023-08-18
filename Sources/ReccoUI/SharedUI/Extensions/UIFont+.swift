import UIKit

extension UIFont {
    static func mimicProperties(
        of font: UIFont,
        in name: String,
        size: CGFloat
    ) -> UIFont {
        let newFont = UIFont(name: name, size: size)!
        let descriptor = newFont.fontDescriptor.withSymbolicTraits(font.fontDescriptor.symbolicTraits)!
        
        return UIFont(descriptor: descriptor, size: size)
    }
}
