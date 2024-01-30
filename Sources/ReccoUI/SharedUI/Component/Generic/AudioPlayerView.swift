import AVKit
import Combine
import SwiftUI

final class AudioPlayerViewModel: ObservableObject {
    private(set) var avPlayer: AVPlayer!
    private var timeObserver: Any!
    private var rateObserver: NSKeyValueObservation!
    private var statusObserver: NSKeyValueObservation!
    private var cancellables: Set<AnyCancellable> = .init()

    @Published var currentTime: TimeInterval = 0
    @Published var durationTime: TimeInterval = 1.0
    @Published private(set) var isPlaying = false
    @Published var playbackError: Error?

    var secondsSliderRange: ClosedRange<TimeInterval> {
        0...durationTime
    }

    init(url: URL) {
        self.avPlayer = AVPlayer(url: url)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        } catch {
            playbackError = error
        }

        bind()
    }

    private func bind() {
        timeObserver = avPlayer.addPeriodicTimeObserver(
            forInterval: CMTimeMake(
                value: 1,
                timescale: 1
            ),
            queue: DispatchQueue.main) { [weak self] time in
            if self?.currentTime ?? 0 != CMTimeGetSeconds(time) {
                self?.currentTime = CMTimeGetSeconds(time)
            }
        }

        rateObserver = avPlayer.observe(\.rate, changeHandler: { [weak self] player, _ in
            self?.isPlaying = player.rate > 0
        })

        statusObserver = avPlayer.observe(\.status, changeHandler: { [weak self] player, _ in
            if player.status == .readyToPlay {
                self?.durationTime = player.currentItem.map {
                    Double(CMTimeGetSeconds($0.asset.duration))
                } ?? 1.0
            }
        })
    }

    func play() {
        if Int(currentTime) == Int(durationTime) {
            avPlayer.seek(
                to: CMTime(
                    value: CMTimeValue(0),
                    timescale: 1
                )
            )
        }

        try? AVAudioSession.sharedInstance().setActive(true)
        avPlayer.play()
    }

    func pause() {
        avPlayer.pause()
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    func setCurrentTime(seconds: TimeInterval, wasPlaying: Bool) {
        if wasPlaying {
            pause()
        }
        avPlayer.seek(
            to: CMTime(
                value: CMTimeValue(seconds),
                timescale: 1
            )
        )
        if wasPlaying {
            play()
        }
    }

    deinit {
        statusObserver.invalidate()
        rateObserver.invalidate()
        timeObserver.map {
            avPlayer.removeTimeObserver($0)
        }
    }
}

struct AudioPlayerView: View {
    @StateObject var viewModel: AudioPlayerViewModel
    @State private var wasEditing = false
    @State private var wasPlaying = false
    @State private var isEditingSlider = false

    private var playerButtonImage: String {
        if viewModel.isPlaying || wasPlaying && isEditingSlider {
            "pause.fill"
        } else {
            "play.fill"
        }
    }

    init(url: URL) {
        _viewModel = .init(wrappedValue: .init(url: url))
    }

    private func format(seconds: TimeInterval) -> String? {
        let components = DateComponents(second: Int(seconds))
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: components)
    }

    var body: some View {
        HStack(spacing: .S) {
            Button(
                action: {
                    if viewModel.isPlaying {
                        viewModel.pause()
                    } else {
                        viewModel.play()
                    }
                },
                label: {
                    Image(
                        systemName: playerButtonImage
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.reccoPrimary)
                })

            if let currentProgress = format(seconds: viewModel.currentTime) {
                Text(currentProgress)
                    .labelSmall()
            }

            Slider(
                value: $viewModel.currentTime,
                in: viewModel.secondsSliderRange,
                step: 1.0
            ) { isEditing in
                isEditingSlider = isEditing
                switch (isEditing, wasEditing) {
                case (false, true):
                    viewModel.setCurrentTime(seconds: viewModel.currentTime, wasPlaying: wasPlaying)
                    wasEditing = false
                    wasPlaying = false
                case (true, _):
                    wasPlaying = viewModel.isPlaying
                    viewModel.pause()
                    wasEditing = true
                default: 
                    return
                }
            }
            .accentColor(Color.reccoPrimary)

            if let totaldDuration = format(seconds: viewModel.durationTime) {
                Text(totaldDuration)
                    .labelSmall()
            }
        }
        .padding(.horizontal, .M)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color.reccoPrimary10)
        .cornerRadius(30, corners: .allCorners)
    }
}

#Preview {
    AudioPlayerView(url: URL(string: "https://github.com/rafaelreis-hotmart/Audio-Sample-files/raw/master/sample2.mp3")!)
}
