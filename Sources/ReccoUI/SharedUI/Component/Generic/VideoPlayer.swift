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

struct VideoPlayerView: UIViewControllerRepresentable {
    @Binding var startPlaying: Bool
    var gravity: AVLayerVideoGravity = .resizeAspect
    var url: URL
    let whenReady: () -> Void

    func makeUIViewController(context: Context) -> some UIViewController {
        let playerVC = AVPlayerViewController()
        playerVC.player = .init(url: url)
        playerVC.player?.pause()
        playerVC.videoGravity = .resizeAspect
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

#Preview {
    VStack {
        VideoPlayerView(
            startPlaying: .constant(true),
            url: .init(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
            whenReady: {}
        )
        .frame(height: 250)
    }
}
