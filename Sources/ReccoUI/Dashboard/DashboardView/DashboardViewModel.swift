import Foundation
import ReccoHeadless

struct FeedSectionViewState: Hashable {
    var section: FeedSection
    var isLoading: Bool
}

final class DashboardViewModel: ObservableObject {
    private let feedRepo: FeedRepository
    private let recRepo: RecommendationRepository
    private let nav: ReccoCoordinator
    private let logger: Logger

    @Published var lockedSectionAlert: FeedSection?
    @Published var isLoading = true
    @Published var initialLoadError: Error?
    @Published var unlockAnimationsDone: [FeedSectionType: Bool] = [:]
    @Published var sections: [FeedSectionViewState] = []
    @Published var items: [FeedSectionType: [AppUserRecommendation]] = [:]
    @Published var errors: [FeedSection: Error?] = [:]

    init(
        feedRepo: FeedRepository,
        recRepo: RecommendationRepository,
        nav: ReccoCoordinator,
        logger: Logger
    ) {
        self.recRepo = recRepo
        self.feedRepo = feedRepo
        self.nav = nav
        self.logger = logger

        Task {
            await getFeedItems()
        }
    }

    func goToDetail(of item: AppUserRecommendation) {
        switch item.type {
        case .articles:
            nav.navigate(to: .article(
                id: item.id,
                headline: item.headline,
                imageUrl: item.imageUrl,
                seenContent: { [unowned self] id in
                    markContentAsSeen(id: id)
                }, onBookmarkedChange: { _ in }
            ))
        case .questionnaire:
            fatalError("asdf")
        case .audio, .video:
            nav.navigate(to: .media(
                mediaType: item.type == .audio ? .audio : .video,
                id: item.id,
                headline: item.headline,
                imageUrl: item.imageUrl,
                seenContent: { [unowned self] id in
                    markContentAsSeen(id: id)
                }, onBookmarkedChange: { _ in }
            ))
        }
    }

    @MainActor
    func goToQuestionnaire(of section: FeedSection) {
        if let topic = section.topic {
            nav.navigate(to: .questionnaire(
                topic, { [unowned self] _ in
                    reloadSection(
                        type: section.type,
                        nextState: .unlock
                    )
                }
            ))
        }
    }

    func goToBookmarks() {
        nav.navigate(to: .bookmarks)
    }

    func dismiss() {
        nav.navigate(to: .dismiss)
    }

    @MainActor
    func pressedUnlockSectionStart() {
        if let section = lockedSectionAlert,
           let topic = section.topic {
            nav.navigate(to: .questionnaire(
                topic, { [unowned self] _ in
                    reloadSection(
                        type: section.type,
                        nextState: .unlock
                    )
                }
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
            logger.log(error)
            initialLoadError = error
            isLoading = false
        }
    }

    func load(sections: [FeedSection]) async {
        await withTaskGroup(of: Void.self) { @MainActor [unowned self] group in
            for (idx, section) in sections.enumerated() where !section.locked {
                self.sections[idx].isLoading = true

                group.addTask { @MainActor [unowned self] in
                    do {
                        let items = try await recRepo.getFeedSection(section)
                        self.items[section.type] = items
                        self.errors[section] = nil
                    } catch {
                        logger.log(error)
                        self.initialLoadError = error
                    }

                    self.sections[idx].isLoading = false
                }
            }
        }
    }

    // MARK: Private

    @MainActor
    private func reloadSection(
        type: FeedSectionType,
        nextState: FeedSectionState
    ) {
        guard let idx = sections.firstIndex(
            where: { $0.section.type == type }
        ) else { return }

        let section = sections[idx].section

        Task {
            do {
                sections[idx].section.state = nextState
                sections[idx].isLoading = true
                if section.state == .locked {
                    // animation time, we avoid re-rendering the view while animating
                    try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 2100)
                }
                let data = try await recRepo.getFeedSection(section)
                items[section.type] = data
            } catch {
                logger.log(error)
                self.initialLoadError = error
            }

            sections[idx].isLoading = false
        }
    }

    private func markContentAsSeen(id: ContentId) {
        for section in sections {
            for (item, idx) in zip(items[section.section.type, default: []], items[section.section.type, default: []].indices) where item.status != .viewed && item.id == id {
                items[section.section.type]?[idx].status = .viewed
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
