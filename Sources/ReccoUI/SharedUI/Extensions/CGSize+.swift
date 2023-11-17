import UIKit

extension CGSize {
    var inPixels: CGSize {
        let scale = UIScreen.main.scale
        let pixelWidth = width * scale
        let pixelHeight = height * scale
        return CGSize(width: pixelWidth, height: pixelHeight)
    }
}
