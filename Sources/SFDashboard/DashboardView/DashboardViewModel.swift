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
    
    @Published var lockedSectionAlert: FeedSection?
    @Published var isLoading: Bool = true
    @Published var initialLoadError: Error?
    @Published var unlockAnimationsDone: [FeedSectionType: Bool] = [:]
    @Published var sections: [FeedSectionViewState] = []
    @Published var items: [FeedSectionType: [AppUserRecommendation]] = [:]
    @Published var errors: [FeedSection: Error?] = [:]
    
    public init(
        feedRepo: FeedRepository,
        recRepo: RecommendationRepository,
        nav: DashboardCoordinator
    ) {
        self.recRepo = recRepo
        self.feedRepo = feedRepo
        self.nav = nav
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
    
    func dismiss() {
        nav.navigate(to: .dismiss)
    }
    
    @MainActor
    func pressedUnlockSectionStart() {
        if let topic = lockedSectionAlert?.topic {
            nav.navigate(to: .questionnaire(
                topic,
                { [unowned self] in unlock(topic: $0) }
            ))
        }
        
        lockedSectionAlert = nil
    }
    
    func pressedLocked(section: FeedSection) {
        lockedSectionAlert = section
    }
    
    @MainActor
    func getFeedItems() async {
        initialLoadError = nil
        
        do {
            let data = try await feedRepo.getFeed()
            setView(sections: data)
            await load(sections: data)
        } catch {
            initialLoadError = error
            isLoading = false
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
                        self.items[section.type] = items
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
    
    @MainActor
    private func unlock(topic: SFTopic) {
        guard let idx = sections.firstIndex(
            where: { $0.section.locked && $0.section.topic == topic }
        ) else { return }
        
        let section = sections[idx].section
        
        Task {
            do {
                let data = try await recRepo.getFeedSection(section)
                items[section.type] = data
                sections[idx].section.locked = false
            } catch {
                self.initialLoadError = error
            }
        }
    }
    
    private func markContentAsSeen(id: ContentId) {
        for section in sections {
            for (item, idx) in zip(items[section.section.type, default: []], items[section.section.type, default: []].indices) where item.status != .viewed {
                if item.id == id {
                    items[section.section.type]?[idx].status = .viewed
                }
            }
        }
    }
    
    @MainActor
    private func setView(sections: [FeedSection]) {
        isLoading = false
        self.sections = sections.map { element in
            FeedSectionViewState(
                section: element,
                isLoading: !element.locked
            )
        }
        
        self.unlockAnimationsDone = sections.reduce(into: [:], { partialResult, section in
            partialResult[section.type] = !section.locked
        })
    }
}
