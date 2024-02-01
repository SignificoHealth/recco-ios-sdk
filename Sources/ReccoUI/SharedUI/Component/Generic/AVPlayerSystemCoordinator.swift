//
//  File.swift
//
//
//  Created by Adrián R on 1/2/24.
//

import AVKit
import Foundation
import MediaPlayer
#if canImport(Nuke)
import Nuke
#endif

struct NowPlayingInfo {
    let title: String
    let subtitle: String?
    let imageUrl: URL?
}

final class AVPlayerSystemCoordinator {
    private weak var avPlayer: AVPlayer?
    private let info: NowPlayingInfo
    
    /// returns true when it is ready to play, and provides total duration
    /// for current item
    private let onStatusChanged: ((Bool) -> Void)?
    private let onPlayBackChanged: ((Bool) -> Void)?
    private let onProgressChanged: ((TimeInterval) -> Void)?
    
    // internal state
    private var lastRecordedTime: TimeInterval = 0
    private var firstTimePlaying = true
    // observer tokens
    private var periodicObserver: Any?
    private var rateObserver: NSKeyValueObservation?
    private var statusObserver: NSKeyValueObservation?
    
    init(
        avplayer: AVPlayer,
        info: NowPlayingInfo,
        onStatusChanged: ((Bool) -> Void)? = nil,
        onPlayBackChanged: ((Bool) -> Void)? = nil,
        onProgressChanged: ((TimeInterval) -> Void)? = nil
    ) {
        self.avPlayer = avplayer
        self.info = info
        self.onStatusChanged = onStatusChanged
        self.onPlayBackChanged = onPlayBackChanged
        self.onProgressChanged = onProgressChanged
        
        bind()
    }
    
    private func bind() {
        periodicObserver = avPlayer?.addPeriodicTimeObserver(
            forInterval: CMTimeMake(
                value: 1,
                timescale: 2
            ),
            queue: DispatchQueue.main) { [weak self] time in
                let progressInSeconds = CMTimeGetSeconds(time)
                self?.updateNowPlayingInfoCenter()
                if self?.lastRecordedTime ?? 0 != progressInSeconds {
                    self?.lastRecordedTime = progressInSeconds
                    self?.onProgressChanged?(progressInSeconds)
                }
            }
        
        rateObserver = avPlayer?.observe(\.rate, changeHandler: { [weak self] player, _ in
            let isPlaying = player.rate > 0
            if isPlaying && self?.firstTimePlaying ?? false {
                self?.firstTimePlayingSetup()
            }
            self?.onPlayBackChanged?(isPlaying)
        })
        
        statusObserver = avPlayer?.observe(\.status, changeHandler: { [weak self] player, _ in
            self?.onStatusChanged?(player.status == .readyToPlay)
        })
    }
    
    private func firstTimePlayingSetup() {
        try? AVAudioSession.sharedInstance().setActive(true)
        setupNowPlayingInfoCenter()
        setUpNowPlayingImage(info: info)
        setupRemoteCommandCenter()
        firstTimePlaying = false
    }
    
    private func setupNowPlayingInfoCenter() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = info.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = info.subtitle
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.avPlayer?.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.avPlayer?.pause()
            return .success
        }
        
        if let player = avPlayer {
            commandCenter.skipForwardCommand.isEnabled = true
            commandCenter.skipForwardCommand.preferredIntervals = [15]
            commandCenter.skipForwardCommand.addTarget { _ in
                // Implement skip forward functionality
                let playerCurrentTime = player.currentTime()
                let skipInterval = 15.0 // 15 seconds
                let newTime = playerCurrentTime + CMTimeMakeWithSeconds(skipInterval, preferredTimescale: 1)
                player.seek(to: newTime)
                return .success
            }
            
            // Skip backward command
            commandCenter.skipBackwardCommand.isEnabled = true
            commandCenter.skipBackwardCommand.preferredIntervals = [15]  // Define the skip interval
            commandCenter.skipBackwardCommand.addTarget { [unowned self] _ in
                // Implement skip backward functionality
                let playerCurrentTime = player.currentTime()
                let skipInterval = -15.0 // 15 seconds back
                let newTime = playerCurrentTime + CMTimeMakeWithSeconds(skipInterval, preferredTimescale: 1)
                player.seek(to: newTime)
                return .success
            }
            
            // Change playback position command
            commandCenter.changePlaybackPositionCommand.isEnabled = true
            commandCenter.changePlaybackPositionCommand.addTarget { event in
                let positionEvent = event as! MPChangePlaybackPositionCommandEvent
                player.seek(to: CMTimeMakeWithSeconds(positionEvent.positionTime, preferredTimescale: 1))
                return .success
            }
        }
    }
    
    // This method should be called periodically to update playback info
    private func updateNowPlayingInfoCenter() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = avPlayer?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = avPlayer?.currentItem?.duration.seconds
        // Add other updates here...
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setUpNowPlayingImage(info: NowPlayingInfo) {
#if canImport(Nuke)
        Task { @MainActor in
            do {
                let originalSize = CGSize(width: 300, height: 300)
                let request = ImageRequest(
                    url: info.imageUrl,
                    processors: [.resize(size: originalSize, crop: true)],
                    priority: .high
                )
                
                let image = try await ImagePipeline.shared.image(for: request)
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { newSize in
                    resizeArtworkImage(image: image, targetSize: newSize)
                }
                )
            }
        }
#endif
    }
    
    deinit {
        try? AVAudioSession.sharedInstance().setActive(false)
        statusObserver?.invalidate()
        statusObserver = nil
        rateObserver?.invalidate()
        rateObserver = nil
        periodicObserver.map {
            avPlayer?.removeTimeObserver($0)
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
}

private func resizeArtworkImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if widthRatio > heightRatio {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
