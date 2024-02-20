//
//  MetricMapper.swift
//
//
//  Created by Roberto Frontado on 29/09/2023.
//

extension AppUserMetricEvent {
    init(dto: AppUserMetricEventDTO) {
        self.init(
            category: AppUserMetricCategory(dto: dto.category),
            action: AppUserMetricAction(dto: dto.action),
            value: dto.value
        )
    }
}

extension AppUserMetricAction {
    init(dto: AppUserMetricActionDTO) {
        switch dto {
        case .view:
            self = .view
        case .hostAppOpen:
            self = .hostAppOpen
        case .reccoSdkOpen:
            self = .reccoSDKOpen
        }
    }
}

extension AppUserMetricCategory {
    init(dto: AppUserMetricCategoryDTO) {
        switch dto {
        case .userSession:
            self = .userSession
        case .dashboardScreen:
            self = .dashboardScreen
        }
    }
}

extension AppUserMetricEventDTO {
    init(entity: AppUserMetricEvent) {
        self.init(
            category: AppUserMetricCategoryDTO(entity: entity.category),
            action: AppUserMetricActionDTO(entity: entity.action),
            value: entity.value
        )
    }
}

extension AppUserMetricActionDTO {
    init(entity: AppUserMetricAction) {
        switch entity {
        case .view:
            self = .view
        case .hostAppOpen:
            self = .hostAppOpen
        case .reccoSDKOpen:
            self = .reccoSdkOpen
        }
    }
}

extension AppUserMetricCategoryDTO {
    init(entity: AppUserMetricCategory) {
        switch entity {
        case .userSession:
            self = .userSession
        case .dashboardScreen:
            self = .dashboardScreen
        }
    }
}
