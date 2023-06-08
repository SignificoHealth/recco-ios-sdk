//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation
import SFRepo
import SFEntities

struct FeedSectionViewState: Hashable {
    var section: FeedSection
    var isLoading: Bool
    var items: [AppUserRecommendation] = []
}

public final class DashboardViewModel: ObservableObject {
    private let feedRepo: FeedRepository
    private let recRepo: RecommendationRepository
    
    @Published var isLoading: Bool = true
    @Published var initialLoadError: Error?
    @Published var sections: [FeedSectionViewState] = []
    @Published var errors: [FeedSection: Error?] = [:]
    
    public init(
        feedRepo: FeedRepository,
        recRepo: RecommendationRepository
    ) {
        self.recRepo = recRepo
        self.feedRepo = feedRepo
        
        getFeedItems()
    }
    
    func getFeedItems() {
        initialLoadError = nil
        Task {
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
        return await withTaskGroup(of: Void.self) { [unowned self] group in
            for section in sections where !section.locked {
                await setLoading(section: section)
                group.addTask { [unowned self] in
                    do {
                        let items = try await recRepo.getFeedSection(section)
                        await setData(items, section: section)
                    } catch {
                        print(error)
                        await setError(error, section: section)
                    }
                }
            }
            
            return await group.waitForAll()
        }
    }
    
    // MARK: Private
    
    @MainActor
    private func setError(_ error: Error?, section: FeedSection) {
        guard let idx = sections.firstIndex(where: { $0.section == section }) else {
            return
        }
        
//        self.errors[section] = error
        self.initialLoadError = error
        self.sections[idx].isLoading = false
    }
    
    @MainActor
    private func setData(_ data: [AppUserRecommendation], section: FeedSection) {
        guard let idx = sections.firstIndex(where: { $0.section == section }) else {
            return
        }
        
        self.sections[idx].isLoading = false
        self.sections[idx].items = data
        self.errors[section] = nil
    }
    
    @MainActor
    private func setLoading(section: FeedSection) {
        guard let idx = sections.firstIndex(where: { $0.section == section }) else {
            return
        }
        
        self.sections[idx].isLoading = true
    }
    
    @MainActor
    private func setView(sections: [FeedSection]) {
        self.isLoading = false
        self.sections = sections.enumerated().map { idx, element in
            FeedSectionViewState(
                section: element,
                isLoading: true,
                items: self.sections[safe: idx]?.items ?? []
            )
        }
    }
}
