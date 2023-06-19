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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.3)) {
                shouldShake = true
            }
            
            HapticPlayer.shared.playUnlockHapticPattern()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                performingUnlockAnimation = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            performedUnlockAnimation = true
        }
    }
}

struct LockedFeedItem: View {
    var unlocking: Bool
    var imageName: String
    
    private var lockIcon: String {
        unlocking ? "unlocked_ic" : "locked_ic"
    }
    
    var body: some View {
        ZStack {
            Image(resource: imageName)
                .resizable()
                .blur(radius: 10)
            
            VStack(spacing: .XXS) {
                Image(resource: lockIcon)
                    .foregroundColor(.sfPrimary)
                
                Text("dashboard.unlock".localized)
                    .h3()
            }
        }
        .frame(width: .cardSize.width)
        .clipShape(
            RoundedRectangle(cornerRadius: .XXS)
        )
        .background(
            RoundedRectangle(cornerRadius: .XXS)
                .fill(Color.sfBackground)
        )
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
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
