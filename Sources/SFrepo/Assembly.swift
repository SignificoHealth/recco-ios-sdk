//
//  File.swift
//  
//
//  Created by Adrián R on 1/6/23.
//

import Foundation
import SFCore

public final class RepositoryAssembly: SFAssembly {
    private let clientSecret: String
    
    public init(clientSecret: String) {
        self.clientSecret = clientSecret
    }
    
    public func assemble(container: SFContainer) {
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
    }
}
