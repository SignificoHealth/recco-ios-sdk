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
            iosFont: dto.iosFont.rawValue
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
