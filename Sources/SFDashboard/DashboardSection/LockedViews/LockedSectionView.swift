import SwiftUI
import SFSharedUI
import Combine

struct LockedSectionView: View {
    var isLocked: Bool
    @Binding var performedUnlockAnimation: Bool
    
    @State private var numberOfItems = 5
    @State private var shouldShake: Bool = false
    @State private var performingUnlockAnimation: Bool = false
    @State private var rememberLockState: Bool = true
    @State private var lockedImages: [String] = (1...7).map { idx in "locked_bg_item_\(idx)"
    }
    var body: some View {
        // Empty axes allows us to create scrollview with no scrolling
        ScrollView([]) {
            HStack(spacing: .XXS) {
                ForEach(0..<(numberOfItems-1), id: \.self) { idx in
                    LockedFeedItem(
                        unlocking: performingUnlockAnimation,
                        imageName: lockedImages[idx]
                    )
                }
            }
            .padding(.horizontal, .M)
            .overlay(
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        numberOfItems = max(numberOfItems, Int(proxy.size.width / .cardSize.width))
                    }
                }
            )
        }
        .frame(height: .cardSize.height)
        .modifier(Shake(animatableData: shouldShake ? 1 : 0))
        .onReceive(Just(isLocked)) { newValue in
            if rememberLockState != newValue {
                rememberLockState = newValue
            }
        }
        .onChange(of: rememberLockState) { newValue in
            if !newValue && !performedUnlockAnimation {
                performUnlockAnimation()
            }
        }
    }
    
    private func performUnlockAnimation() {
        Task {
            try await Task.sleep(nanoseconds: 400 * NSEC_PER_MSEC)
            
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    shouldShake = true
                }
                
                HapticPlayer.shared.playUnlockHapticPattern()
            }
            
            try await Task.sleep(nanoseconds: 700 * NSEC_PER_MSEC)
            
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    performingUnlockAnimation = true
                }
            }

            try await Task.sleep(nanoseconds: 1000 * NSEC_PER_MSEC)
            
            await MainActor.run {
                performedUnlockAnimation = true
            }
        }
    }
}

struct LockedSectionView_Previews: PreviewProvider {
    struct Wrapped: View {
        @State var isLocked: Bool
        
        var body: some View {
            LockedSectionView(
                isLocked: isLocked,
                performedUnlockAnimation: .constant(false)
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLocked = false
                }
            }
        }
    }
    static var previews: some View {
        Wrapped(isLocked: true)
    }
}
