import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

// A ScrollView wrapper that tracks scroll offset changes.
public struct ObservableScrollView<Content>: View where Content: View {
    @Namespace var scrollSpace
    
    @Binding var scrollOffset: CGFloat
    let content: (ScrollViewProxy) -> Content
    var showsIndicators: Bool
    var axis: Axis.Set

    public init(
        axis: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        scrollOffset: Binding<CGFloat>,
        @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
    ) {
        _scrollOffset = scrollOffset
        self.showsIndicators = showsIndicators
        self.content = content
        self.axis = axis
    }
    
    public var body: some View {
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
            scrollOffset = value
        }
    }
}
