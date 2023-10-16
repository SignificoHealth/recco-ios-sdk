//
//  File.swift
//
//
//  Created by Saúl on 11/10/23.
//

import Foundation

extension AppStyle {
    init(dto: StyleDTO) {
        self.init(
            darkColors: AppColors(dto: dto.darkColors),
            lightColors: AppColors(dto: dto.lightColors),
            iosFont: ReccoFont(dto: dto.iosFont.rawValue)
        )
    }
}

extension AppColors {
    init(dto: ColorsDTO) {
        self.init(
            primary: dto.primary,
            onPrimary: dto.onPrimary,
            background: dto.background,
            onBackground: dto.onBackground,
            accent: dto.accent,
            onAccent: dto.onAccent,
            illustration: dto.illustration,
            illustrationOutline: dto.illustrationOutline
        )
    }
}

extension ReccoFont {
    init(dto: String) {
        switch dto {
        case "sf_pro":
            self = .sfPro
        case "helvetica_neue":
            self = .helveticaNeue
        case "avenir_next":
            self = .avenirNext
        case "apple_sd_gothic_neo":
            self = .appleSdGothicNeo
        case "georgia":
            self = .georgia
        default:
            self = .sfPro
        }
    }
}

