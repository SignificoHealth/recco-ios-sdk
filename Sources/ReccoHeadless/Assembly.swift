//
//  Assembly.swift
//
//
//  Created by Adrián R on 30/5/23.
//

import Foundation
import UIKit

public final class ReccoHeadlessAssembly: ReccoAssembly {
    private let clientSecret: String

    public init(clientSecret: String) {
        self.clientSecret = clientSecret
    }

    public func assemble(container: ReccoContainer) {
        container.register(type: AuthRepository.self) { [clientSecret] r in
            LiveAuthRepository(
                keychain: r.get(),
                clientSecret: clientSecret
            )
        }

        container.register(type: RecommendationRepository.self) { _ in
            LiveRecommendationRepository()
        }

        container.register(type: FeedRepository.self) { _ in
            LiveFeedRepository()
        }

        container.register(type: ArticleRepository.self) { _ in
            LiveArticleRepository()
        }

        container.register(type: ContentRepository.self) { _ in
            LiveContentRepository()
        }

        container.register(type: QuestionnaireRepository.self) { _ in
            LiveQuestionnaireRepository()
        }

        container.register(type: MetricRepository.self) { r in
            LiveMetricRepository(keychain: r.get())
        }

        container.register(type: MeRepository.self, singleton: true) { r in
            LiveMeRepository(keychain: r.get())
        }

        container.register(type: Calendar.self) { _ in
            .current
        }

        container.register(type: (() -> UIWindow?).self) { _ in {
            // swiftlint:disable:next first_where
            UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        }
        }

        container.register(type: KeychainProxy.self) { _ in
            .standard
        }
    }
}
