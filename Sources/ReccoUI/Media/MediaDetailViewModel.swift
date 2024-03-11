import Foundation
import ReccoHeadless

final class MediaDetailViewModel: ObservableObject {
    private var mediaRepo: MediaRepository
    private let contentRepo: ContentRepository
    private let contentId: ContentId
    private let updateContentSeen: (ContentId) -> Void
    private let onBookmarkChanged: (Bool) -> Void
    private let nav: ReccoCoordinator
    private let logger: Logger
    private var hasShownWarningAlertAlready = false

    let imageUrl: URL?
    let heading: String
    let mediaType: MediaType

    @Published var isLoading = true
    @Published var media: AppUserMedia?
    @Published var initialLoadError: Error?
    @Published var actionError: Error?
    @Published var isPlayingMedia = false
    @Published var warningAlert: String?
    @Published var neverShowWarningToggle = false

    init(
        loadedContent: (MediaType, ContentId, String, URL?, (ContentId) -> Void, (Bool) -> Void),
        mediaRepo: MediaRepository,
        contentRepo: ContentRepository,
        nav: ReccoCoordinator,
        logger: Logger
    ) {
        self.mediaRepo = mediaRepo
        self.mediaType = loadedContent.0
        self.contentRepo = contentRepo
        self.contentId = loadedContent.1
        self.imageUrl = loadedContent.3
        self.heading = loadedContent.2
        self.updateContentSeen = loadedContent.4
        self.onBookmarkChanged = loadedContent.5
        self.nav = nav
        self.logger = logger

        bind()
    }

    @MainActor
    func initialLoad() async {
        do {
            let media: AppUserMedia
            if mediaType == .audio {
                media = try await mediaRepo.getAudio(with: contentId)
            } else {
                media = try await mediaRepo.getVideo(with: contentId)
            }

            self.media = media
            self.media?.status = .viewed
            self.updateContentSeen(media.id)
        } catch {
            logger.log(error)
            initialLoadError = error
        }

        isLoading = false
    }

    @MainActor
    func toggleBookmark() async {
        guard let media = media else { return }

        do {
            try await contentRepo.setBookmark(.init(
                contentId: media.id,
                contentType: .articles,
                bookmarked: !media.bookmarked
            ))

            self.media?.bookmarked.toggle()
            self.onBookmarkChanged(!media.bookmarked)
        } catch {
            logger.log(error)
            actionError = error
        }

        isLoading = false
    }

    @MainActor
    func rate(_ rating: ContentRating) async {
        guard let media = media else { return }

        do {
            try await contentRepo.setRating(.init(
                contentId: media.id,
                contentType: .articles,
                rating: rating
            ))

            self.media?.rating = rating
        } catch {
            logger.log(error)
            actionError = error
        }

        isLoading = false
    }

    func dismiss() {
        nav.navigate(to: .dismiss)
    }

    func back() {
        nav.navigate(to: .back)
    }

    func showWarningAlertIfNecessary() {
        if !mediaRepo.userTappedNeverShowVideoWarning && !hasShownWarningAlertAlready {
            warningAlert = media?.warning
            hasShownWarningAlertAlready = true
        } else {
            playPause()
        }
    }

    func playPause() {
        isPlayingMedia.toggle()
    }

    private func bind() {
        $neverShowWarningToggle
            .dropFirst()
            .sink { [unowned self] new in
                mediaRepo.userTappedNeverShowVideoWarning = new
            }
            .store(in: &cancellables)
    }
}
