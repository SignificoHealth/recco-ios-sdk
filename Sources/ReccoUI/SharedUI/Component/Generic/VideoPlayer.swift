//
//  ArticleVideoPlayer.swift
//  DHG
//
//  Created by Adrián R on 8/5/23.
//

import AVKit
import Foundation
import SwiftUI
import UIKit

struct VideoPlayerView<OverlayView: View>: UIViewControllerRepresentable {
    init(
        startPlaying: Binding<Bool>,
        gravity: AVLayerVideoGravity = .resizeAspect,
        url: URL,
        whenReady: @escaping () -> Void = {},
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) {
        self._startPlaying = startPlaying
        self.gravity = gravity
        self.url = url
        self.whenReady = whenReady
        self.overlayView = overlayView
    }

    @Binding var startPlaying: Bool
    var gravity: AVLayerVideoGravity = .resizeAspect
    var url: URL
    var whenReady: () -> Void = {}
    var overlayView: () -> OverlayView

    func makeUIViewController(context: Context) -> some UIViewController {
        let playerVC = AVPlayerViewController()
        let overlayVc = UIHostingController(rootView: overlayView())
        playerVC.contentOverlayView?.addSubview(overlayVc.view)
        overlayVc.view.translatesAutoresizingMaskIntoConstraints = true
        overlayVc.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlayVc.view.backgroundColor = .clear
        playerVC.player = .init(url: url)
        playerVC.player?.pause()
        playerVC.videoGravity = gravity
        playerVC.modalPresentationCapturesStatusBarAppearance = true
        playerVC.allowsPictureInPicturePlayback = true
        playerVC.player?.automaticallyWaitsToMinimizeStalling = true
        context.coordinator.player = playerVC.player

        if #available(iOS 14.2, *) {
            playerVC.canStartPictureInPictureAutomaticallyFromInline = true
        }
        return playerVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let vc = uiViewController as? AVPlayerViewController
        startPlaying ? vc?.player?.play() : vc?.player?.pause()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(whenReady)
    }

    final class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        var playerObservation: NSKeyValueObservation?
        let whenReady: () -> Void

        weak var player: AVPlayer? {
            didSet {
                playerObservation = player?.observe(\.status, changeHandler: { [weak self] player, _ in
                    if player.status == .readyToPlay {
                        self?.whenReady()
                    }
                })
            }
        }

        init(_ ready: @escaping () -> Void) {
            self.whenReady = ready
            super.init()
        }

        func playerViewController(
            _ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
        ) {
            completionHandler(true)
        }

        deinit {
            playerObservation?.invalidate()
            playerObservation = nil
        }
    }
}

extension VideoPlayerView where OverlayView == EmptyView {
    init(
        startPlaying: Binding<Bool>,
        gravity: AVLayerVideoGravity = .resizeAspect,
        url: URL,
        whenReady: @escaping () -> Void = {}
    ) {
        self.init(
            startPlaying: startPlaying,
            gravity: gravity,
            url: url,
            whenReady: whenReady,
            overlayView: { EmptyView() }
        )
    }
}

#Preview {
    VideoPlayerView(
        startPlaying: .constant(true),
        url: .init(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
        whenReady: {},
        overlayView: {
            Circle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
        }
    )
    .frame(height: 250)
}
