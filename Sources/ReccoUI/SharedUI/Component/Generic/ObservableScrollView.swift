import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ObservableScrollView<Content>: View where Content: View {
    @Namespace var scrollSpace
    @Environment(\.currentScrollObservable) var scrollObservable
    @Environment(\.currentScrollOffsetId) var offsetId

    let content: (ScrollViewProxy) -> Content
    var showsIndicators: Bool
    var axis: Axis.Set

    init(
        axis: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.content = content
        self.axis = axis
    }
    
    var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            ScrollViewReader { proxy in
                content(proxy)
                    .background(GeometryReader { geo in
                        let offset = axis == .vertical ? -geo.frame(in: .named(scrollSpace)).minY : -geo.frame(in: .named(scrollSpace)).minX
                        Color.clear
                            .preference(key: ScrollViewOffsetPreferenceKey.self,
                                        value: offset)
                    })
            }
        }
        .coordinateSpace(name: scrollSpace)
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offsetId.map { scrollObservable.send(($0, value)) }
        }
    }
}
