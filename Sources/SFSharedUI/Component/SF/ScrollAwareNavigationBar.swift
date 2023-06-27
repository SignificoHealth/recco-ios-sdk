import SwiftUI

public struct ScrollAwareNavigationBar<Content: View>: View {
    @Environment(\.currentScrollObservable) var scrollObservable
    @State private var navigationBarHidden: Bool = true
    
    private var threshold: CGFloat
    private var content: () -> Content

    public init(
        threshold: CGFloat = 200.0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.threshold = threshold
        self.content = content
    }
    
    public var body: some View {
        content()
            .navigationBarHidden(navigationBarHidden)
            .onReceive(scrollObservable) { new in
                let reachedThreshold = new > threshold
                if reachedThreshold && navigationBarHidden {
                    withAnimation {
                        navigationBarHidden = false
                    }
                }
                
                if !reachedThreshold && !navigationBarHidden {
                    withAnimation {
                        navigationBarHidden = true
                    }
                }
            }
    }
}

extension View {
    public func showNavigationBarOnScroll(
        threshold: CGFloat = UIScreen.main.bounds.height * 0.2
    ) -> some View {
        ScrollAwareNavigationBar(
            threshold: threshold,
            content: { self }
        )
    }
}
