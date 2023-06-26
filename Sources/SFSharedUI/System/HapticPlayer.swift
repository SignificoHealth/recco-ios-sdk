import CoreHaptics
import SFResources

public final class HapticPlayer {
    public static let shared: HapticPlayer = .init()
    
    private var engine: CHHapticEngine?
    private var player: CHHapticPatternPlayer?
    private var isPlaying: Bool = false
    public func playUnlockHapticPattern() {
        guard let url = localBundle.url(forResource: "unlock_haptic", withExtension: "ahap") else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        guard !isPlaying else { return }
        
        isPlaying = true
        
        do {
            engine = try CHHapticEngine()
            engine?.notifyWhenPlayersFinished(finishedHandler: {  [unowned self] _ in
                isPlaying = false
                return .stopEngine
            })
            engine?.playsHapticsOnly = true
            
            try engine?.start()
            try engine?.playPattern(from: url)
        } catch {
            print("\(error)")
        }
    }
}

