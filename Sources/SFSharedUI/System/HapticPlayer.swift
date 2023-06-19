import CoreHaptics
import SFResources

public final class HapticPlayer {
    public static let shared: HapticPlayer = .init()
    
    private var engine: CHHapticEngine?
    private var player: CHHapticPatternPlayer?
    
    public func playUnlockHapticPattern() {
        guard let url = localBundle.url(forResource: "unlock_haptic", withExtension: "ahap") else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            if engine == nil {
                engine = try CHHapticEngine()
                engine?.playsHapticsOnly = true
            }
            
            try engine?.start()
            try engine?.playPattern(from: url)
        } catch {
            print("\(error)")
        }
    }
}

