//
//  AuthenticationMapper.swift
//
//
//  Created by Adrián R on 1/6/23.
//

import Foundation

extension AppUser {
    init(dto: AppUserDTO) {
        self.init(
            id: dto.id,
            isOnboardingQuestionnaireCompleted: dto.isOnboardingQuestionnaireCompleted
        )
    }
}

extension PAT {
    init(dto: PATDTO) {
        self.init(
            accessToken: dto.accessToken,
            expirationDate: dto.expirationDate,
            tokenId: dto.tokenId,
            creationDate: dto.creationDate
        )
    }
}

extension PATReferenceDeleteDTO {
    init(entity: PATReferenceDelete) {
        self.init(
            tokenId: entity.tokenId
        )
    }
}
