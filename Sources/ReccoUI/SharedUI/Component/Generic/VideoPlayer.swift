//
//  ArticleVideoPlayer.swift
//  DHG
//
//  Created by Adrián R on 8/5/23.
//

import AVKit
import Foundation
import ReccoHeadless
import SwiftUI
import UIKit

struct VideoPlayerView<OverlayView: View>: UIViewControllerRepresentable {
    init(
        startPlaying: Binding<Bool>,
        gravity: AVLayerVideoGravity = .resizeAspect,
        media: AppUserMedia,
        artworkUrl: URL?,
        whenReady: @escaping () -> Void = {},
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) {
        self.artworkUrl = artworkUrl
        self.media = media
        self._startPlaying = startPlaying
        self.gravity = gravity
        self.whenReady = whenReady
        self.overlayView = overlayView
    }

    @Binding var startPlaying: Bool
    var gravity: AVLayerVideoGravity = .resizeAspect
    var media: AppUserMedia
    var artworkUrl: URL?
    var whenReady: () -> Void = {}
    var overlayView: () -> OverlayView

    func makeUIViewController(context: Context) -> some UIViewController {
        let playerVC = AVPlayerViewController()
        let overlayVc = UIHostingController(rootView: overlayView())
        playerVC.contentOverlayView?.addSubview(overlayVc.view)
        overlayVc.view.translatesAutoresizingMaskIntoConstraints = true
        overlayVc.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlayVc.view.backgroundColor = .clear
        playerVC.player = .init(url: media.mediaUrl)
        playerVC.player?.pause()
        playerVC.videoGravity = gravity
        playerVC.modalPresentationCapturesStatusBarAppearance = true
        playerVC.allowsPictureInPicturePlayback = true
        playerVC.updatesNowPlayingInfoCenter = false
        context.coordinator.player = playerVC.player

        if #available(iOS 14.2, *) {
            playerVC.canStartPictureInPictureAutomaticallyFromInline = true
        }

        return playerVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let vc = uiViewController as? AVPlayerViewController
        let isPlaying = vc?.player?.rate ?? 0 > 0

        guard isPlaying != startPlaying else {
            return
        }

        if startPlaying {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        }

        startPlaying ? vc?.player?.play() : vc?.player?.pause()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            media: media,
            artworkUrl: artworkUrl,
            whenReady
        ) {
            startPlaying = $0
        }
    }

    final class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        private let whenReady: () -> Void
        private let playingChanged: (Bool) -> Void
        private let media: AppUserMedia
        private let artworkUrl: URL?
        private var hasStartedPlaying = false
        private var playerCoordinator: AVPlayerSystemCoordinator!

        weak var player: AVPlayer? {
            didSet {
                guard playerCoordinator == nil else { return }
                self.playerCoordinator = .init(
                    avplayer: player!,
                    info: .init(
                        title: media.headline,
                        imageUrl: artworkUrl
                    ),
                    onStatusChanged: { [weak self] isReady in
                        if isReady { self?.whenReady() }
                    },
                    onPlayBackChanged: { [weak self] isPlaying in
                        DispatchQueue.main.async {
                            self?.playingChanged(isPlaying)
                        }
                    }
                )
            }
        }

        init(
            media: AppUserMedia,
            artworkUrl: URL?,
            _ ready: @escaping () -> Void,
            _ playingChanged: @escaping (Bool) -> Void
        ) {
            self.media = media
            self.whenReady = ready
            self.playingChanged = playingChanged
            self.artworkUrl = artworkUrl
            super.init()
        }

        func playerViewController(
            _ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
        ) {
            completionHandler(true)
        }
    }
}

extension VideoPlayerView where OverlayView == EmptyView {
    init(
        startPlaying: Binding<Bool>,
        gravity: AVLayerVideoGravity = .resizeAspect,
        media: AppUserMedia,
        artworkUrl: URL? = nil,
        whenReady: @escaping () -> Void = {}
    ) {
        self.init(
            startPlaying: startPlaying,
            gravity: gravity,
            media: media,
            artworkUrl: artworkUrl,
            whenReady: whenReady,
            overlayView: { EmptyView() }
        )
    }
}

#Preview {
    VideoPlayerView(
        startPlaying: .constant(true),
        media: AppUserMedia(
            type: .audio,
            id: .init(itemId: "", catalogId: ""), rating: .dislike, status: .noInteraction, bookmarked: true, headline: "Hola", description: "Adios", category: .exercise, disclaimer: nil, warning: nil, dynamicImageResizingUrl: URL(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg"), imageAlt: nil, mediaUrl: .init(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!, duration: 30, textIsTranscription: true),
        artworkUrl: nil, whenReady: {},
        overlayView: {
            Circle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
        }
    )
    .frame(height: 250)
}
