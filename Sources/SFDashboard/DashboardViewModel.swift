//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation
import SFRepo
import SFEntities
import SFArticle

struct FeedSectionViewState: Hashable {
    var section: FeedSection
    var isLoading: Bool
}

public final class DashboardViewModel: ObservableObject {
    private let feedRepo: FeedRepository
    private let recRepo: RecommendationRepository
    private let nav: DashboardCoordinator
    
    @Published var isLoading: Bool = true
    @Published var initialLoadError: Error?
    @Published var sections: [FeedSectionViewState] = []
    @Published var items: [FeedSection: [AppUserRecommendation]] = [:]
    @Published var errors: [FeedSection: Error?] = [:]

    public init(
        feedRepo: FeedRepository,
        recRepo: RecommendationRepository,
        nav: DashboardCoordinator
    ) {
        self.recRepo = recRepo
        self.feedRepo = feedRepo
        self.nav = nav
        
        getFeedItems()
    }
    
    func goToDetail(of item: AppUserRecommendation) {
        nav.navigate(to: .article(
            id: item.id,
            headline: item.headline,
            imageUrl: item.imageUrl,
            seenContent: { [unowned self] id in
                markContentAsSeen(id: id)
            }
        ))
    }
    
    func getFeedItems() {
        Task {
            await MainActor.run {
                initialLoadError = nil
            }
            
            do {
                let data = try await feedRepo.getFeed()
                await setView(sections: data)
                await load(sections: data)
            } catch {
                await MainActor.run {
                    initialLoadError = error
                    isLoading = false
                }
            }
        }
    }
    
    func load(sections: [FeedSection]) async  {
        return await withTaskGroup(of: Void.self) { @MainActor [unowned self] group in
            for section in sections where !section.locked {
                guard let idx = sections.firstIndex(where: { $0 == section }) else {
                    return
                }
                
                self.sections[idx].isLoading = true
                
                group.addTask { @MainActor [unowned self] in
                    do {
                        let items = try await recRepo.getFeedSection(section)
                        self.items[section] = items
                        self.errors[section] = nil
                    } catch {
                        self.initialLoadError = error
                    }
                    
                    self.sections[idx].isLoading = false
                }
            }
        }
    }
    
    // MARK: Private
    
    private func markContentAsSeen(id: ContentId) {
        for section in sections {
            for (item, idx) in zip(items[section.section, default: []], items[section.section, default: []].indices) where item.status != .viewed {
                if item.id == id {
                    items[section.section]?[idx].status = .viewed
                }
            }
        }
    }
    
    @MainActor
    private func setView(sections: [FeedSection]) {
        self.isLoading = false
        self.sections = sections.enumerated().map { idx, element in
            FeedSectionViewState(
                section: element,
                isLoading: true
            )
        }
    }
}
