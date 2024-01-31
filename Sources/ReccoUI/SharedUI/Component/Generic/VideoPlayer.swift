//
//  ArticleVideoPlayer.swift
//  DHG
//
//  Created by Adrián R on 8/5/23.
//

import AVKit
import Foundation
import MediaPlayer
import SwiftUI
import UIKit
import ReccoHeadless

struct VideoPlayerView<OverlayView: View>: UIViewControllerRepresentable {
    init(
        startPlaying: Binding<Bool>,
        gravity: AVLayerVideoGravity = .resizeAspect,
        media: AppUserMedia,
        whenReady: @escaping () -> Void = {},
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) {
        self.media = media
        self._startPlaying = startPlaying
        self.gravity = gravity
        self.whenReady = whenReady
        self.overlayView = overlayView
    }

    @Binding var startPlaying: Bool
    var gravity: AVLayerVideoGravity = .resizeAspect
    var media: AppUserMedia
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
        try? AVAudioSession.sharedInstance().setActive(startPlaying)

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
        Coordinator(media: media, whenReady)
    }

    final class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        var statusObservation: NSKeyValueObservation?
        private var timeObserver: Any?
        let whenReady: () -> Void
        let media: AppUserMedia
        
        weak var player: AVPlayer? {
            didSet {
                statusObservation = player?.observe(\.status, changeHandler: { [weak self] player, _ in
                    if player.status == .readyToPlay {
                        self?.whenReady()
                    }
                })
                
                timeObserver = player?.addPeriodicTimeObserver(
                    forInterval: CMTimeMake(
                        value: 1,
                        timescale: 2
                    ),
                    queue: DispatchQueue.main) { [weak self] _ in
                        self?.updateNowPlayingInfoCenter()
                }
                
                setupNowPlayingInfoCenter()
                setupRemoteCommandCenter()
            }
        }

        init(
            media: AppUserMedia,
            _ ready: @escaping () -> Void
        ) {
            self.media = media
            self.whenReady = ready
            super.init()
        }

        private func setupNowPlayingInfoCenter() {
            var nowPlayingInfo = [String: Any]()
            nowPlayingInfo[MPMediaItemPropertyTitle] = media.headline

            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }

        private func setupRemoteCommandCenter() {
            let commandCenter = MPRemoteCommandCenter.shared()

            commandCenter.playCommand.addTarget { [unowned self] _ in
                self.player?.play()
                return .success
            }

            commandCenter.pauseCommand.addTarget { [unowned self] _ in
                self.player?.pause()
                return .success
            }
            // Add other command handlers here...
        }

        private func updateNowPlayingInfoCenter() {
            // This method should be called periodically to update playback info
            var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime().seconds
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.currentItem?.duration.seconds
            // Add other updates here...

            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }

        func playerViewController(
            _ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
        ) {
            completionHandler(true)
        }

        deinit {
            statusObservation?.invalidate()
            statusObservation = nil
            timeObserver.map {
                player?.removeTimeObserver($0)
            }
        }
    }
}

extension VideoPlayerView where OverlayView == EmptyView {
    init(
        startPlaying: Binding<Bool>,
        gravity: AVLayerVideoGravity = .resizeAspect,
        media: AppUserMedia,
        whenReady: @escaping () -> Void = {}
    ) {
        self.init(
            startPlaying: startPlaying,
            gravity: gravity,
            media: media,
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
        whenReady: {},
        overlayView: {
            Circle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
        }
    )
    .frame(height: 250)
}
