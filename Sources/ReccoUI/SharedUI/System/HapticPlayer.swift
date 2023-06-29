import CoreHaptics

enum HapticPattern: String {
    case unlock = "unlock_haptic"
    case selected = "selected_haptic"
    case deselected = "deselected_haptic"
}

final class HapticPlayer {
    static let shared: HapticPlayer = .init()
    
    private var engine: CHHapticEngine?
    private var player: CHHapticPatternPlayer?
    private var isPlaying: Bool = false
    
    func playHaptic(pattern: HapticPattern) {
        guard let url = localBundle.url(forResource: pattern.rawValue, withExtension: "ahap") else { return }
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

