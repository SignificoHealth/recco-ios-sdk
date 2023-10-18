import Foundation

public struct AppStyle: Equatable, Hashable, Codable {
    init(darkColors: AppColors, lightColors: AppColors, iosFont: AppFont) {
        self.darkColors = darkColors
        self.lightColors = lightColors
        self.iosFont = iosFont
    }

    public var darkColors: AppColors
    public var lightColors: AppColors
    public var iosFont: AppFont
}
