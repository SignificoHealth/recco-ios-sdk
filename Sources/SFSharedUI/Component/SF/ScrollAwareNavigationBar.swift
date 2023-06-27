import SwiftUI

public struct ScrollAwareNavigationBar<Content: View>: View {
    @State private var navigationBarHidden: Bool = true
    private var scrollOffsetY: CGFloat
    private var threshold: CGFloat
    private var content: () -> Content

    public init(
        threshold: CGFloat = 200.0,
        scrollOffsetY: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.threshold = threshold
        self.scrollOffsetY = scrollOffsetY
        self.content = content
    }
    
    public var body: some View {
        content()
            .onChange(of: scrollOffsetY) { new in
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
            .navigationBarHidden(navigationBarHidden)
    }
}

extension View {
    public func showNavigationBarOnScroll(
        threshold: CGFloat = 200.0,
        scrollOffsetY: CGFloat
    ) -> some View {
        ScrollAwareNavigationBar(
            threshold: threshold,
            scrollOffsetY: scrollOffsetY,
            content: { self }
        )
    }
}
