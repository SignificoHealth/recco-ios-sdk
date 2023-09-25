import Combine
import SwiftUI

struct CurrentScrollOffsetObservable: EnvironmentKey {
    static let defaultValue: PassthroughSubject<(String, CGFloat), Never> = .init()
}

struct CurrentScrollOffsetId: EnvironmentKey {
    static let defaultValue: String? = nil
}

extension EnvironmentValues {
    var currentScrollObservable: PassthroughSubject<(String, CGFloat), Never> {
        get { self[CurrentScrollOffsetObservable.self] }
        set { self[CurrentScrollOffsetObservable.self] = newValue }
    }

    var currentScrollOffsetId: String? {
        get { self[CurrentScrollOffsetId.self] }
        set { self[CurrentScrollOffsetId.self] = newValue }
    }
}

struct ScrollAwareNavigationBar<Content: View>: View {
    @State private var navigationBarHidden: Bool = true

    private var threshold: CGFloat
    private var content: () -> Content

    @Environment(\.currentScrollObservable) var scrollObservable
    @Environment(\.currentScrollOffsetId) var id

    init(
        threshold: CGFloat = 200.0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.threshold = threshold
        self.content = content
    }

    var body: some View {
        content()
            .navigationBarHidden(navigationBarHidden)
            .onReceive(scrollObservable) { incId, offset in
                guard let id = self.id, incId == id else { return }

                let reachedThreshold = offset > threshold
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
    func showNavigationBarOnScroll(
        threshold: CGFloat = UIScreen.main.bounds.height * 0.2
    ) -> some View {
        ScrollAwareNavigationBar(
            threshold: threshold,
            content: {
                self
            }
        )
        .environment(\.currentScrollOffsetId, "\(self)")
    }
}
