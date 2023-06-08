//
//  File.swift
//  
//
//  Created by Adrián R on 8/6/23.
//

import Foundation
import SFRepo
import SFEntities

public final class ArticleDetailViewModel: ObservableObject {
    private let articleRepo: ArticleRepository
    private let contentRepo: ContentRepository
    private let contentId: ContentId
    let imageUrl: URL?
    let heading: String
    
    @Published var isLoading: Bool = true
    @Published var article: AppUserArticle?
    
    init(
        loadedContent: (ContentId, String, URL?),
        articleRepo: ArticleRepository,
        contentRepo: ContentRepository
    ) {
        self.articleRepo = articleRepo
        self.contentRepo = contentRepo
        self.contentId = loadedContent.0
        self.imageUrl = loadedContent.2
        self.heading = loadedContent.1
    }
    
    @MainActor
    func getArticle() async {
        do {
            article = try await articleRepo.getArticle(with: contentId)
        } catch {
            print(error)
        }
        
        isLoading = false
    }
}
