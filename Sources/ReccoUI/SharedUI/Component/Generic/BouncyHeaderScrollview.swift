import SwiftUI

struct BouncyHeaderScrollview<
    Header: View,
    Content: View,
    OverlayHeader: View,
    CTA: View
>: View {
    init(
        navTitle: String? = nil,
        backAction: (() -> Void)? = nil,
        closeAction: (() -> Void)? = nil,
        imageHeaderHeight: CGFloat = UIScreen.main.bounds.width * (7 / 10),
        shapeHeight: CGFloat?,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder overlayHeader: @escaping () -> OverlayHeader,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder cta: @escaping () -> CTA
    ) {
        self.header = header
        self.content = content
        self.backAction = backAction
        self.imageHeaderHeight = imageHeaderHeight
        self.overlayHeader = overlayHeader
        self.closeAction = closeAction
        self.cta = cta
        self.navTitle = navTitle
        self.shapeHeight = shapeHeight
    }
    
    private var navTitle: String?
    private var shapeHeight: CGFloat?
    private var header: () -> Header
    private var content: () -> Content
    private var overlayHeader: () -> OverlayHeader
    private var cta: () -> CTA
    private var backAction: (() -> Void)?
    private var closeAction: (() -> Void)?
    
    @Environment(\.currentScrollObservable) var scrollObservable
    @Environment(\.currentScrollOffsetId) var scrollOffsetId

    @State private var scrollOffset: CGFloat = .zero
    
    private var imageHeaderHeight: CGFloat
    
    private var zoomEffect: CGFloat {
        (1 + abs(scrollOffset.clamped(to: -200...0) / imageHeaderHeight * 1.1))
            .clamped(to: 1...1.5)
    }
    
    private var paralaxEffect: CGFloat {
        -(scrollOffset.clamped(to: 0...200) / 10)
    }
    
    private var topActionsVisible: Bool {
        scrollOffset < imageHeaderHeight - 50
    }
        
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .topLeading) {
                header()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .frame(height: imageHeaderHeight)
                    .clipped()
                    .scaleEffect(
                        zoomEffect,
                        anchor: .top
                    )
                    .transformEffect(.init(translationX: 0, y: paralaxEffect))
                    .ignoresSafeArea(.all, edges: .top)
            }
            .overlay(overlayHeader())
            
            VStack(spacing: 0) {
                ObservableScrollView { _ in
                    VStack(alignment: .leading, spacing: 0) {
                        Color.clear
                            .frame(height: imageHeaderHeight, alignment: .top)
                            .padding(.bottom, -(shapeHeight ?? 0))
                        content()
                    }
                }
                
                cta()
            }
            .ignoresSafeArea(.all, edges: .top)
            .overlay(
                HStack {
                    if let backAction = backAction {
                        Button(action: backAction, label: {
                            Image(resource: "chevron_back")
                                .renderingMode(.template)
                        })
                        .accentColor(.reccoWhite)
                        .padding(.vertical, .XS)
                        .opacity(topActionsVisible ? 1 : 0)
                        Spacer()
                    }
                    
                    if let closeAction = closeAction {
                        Spacer()
                        Button(action: closeAction, label: {
                            Image(resource: "close_ic")
                                .renderingMode(.template)
                        })
                        .accentColor(.reccoWhite)
                        .padding(.vertical, .XS)
                        .opacity(topActionsVisible ? 1 : 0)
                    }
                }
                    .padding(.horizontal, .S),
                alignment: .top
            )
        }
        .onReceive(scrollObservable) { id, offset in
            scrollOffset = offset
        }
    }
}

extension BouncyHeaderScrollview where
OverlayHeader == EmptyView,
CTA == EmptyView {
    init(
        navTitle: String? = nil,
        backAction: (() -> Void)? = nil,
        closeAction: (() -> Void)? = nil,
        imageHeaderHeight: CGFloat = UIScreen.main.bounds.height * 0.4,
        shapeHeight: CGFloat? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            navTitle: navTitle,
            backAction: backAction,
            closeAction: closeAction,
            imageHeaderHeight: imageHeaderHeight,
            shapeHeight: shapeHeight,
            header: header,
            overlayHeader: { EmptyView() },
            content: content,
            cta: { EmptyView() }
        )
    }
}

extension BouncyHeaderScrollview where CTA == EmptyView {
    init(
        navTitle: String? = nil,
        backAction: (() -> Void)? = nil,
        closeAction: (() -> Void)? = nil,
        imageHeaderHeight: CGFloat = UIScreen.main.bounds.width * (7 / 10),
        shapeHeight: CGFloat? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder overlayHeader: @escaping () -> OverlayHeader,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            navTitle: navTitle,
            backAction: backAction,
            closeAction: closeAction,
            imageHeaderHeight: imageHeaderHeight,
            shapeHeight: shapeHeight,
            header: header,
            overlayHeader: overlayHeader,
            content: content,
            cta: { EmptyView() }
        )
    }
}

struct BouncyHeaderScrollview_Previews: PreviewProvider {
    static var previews: some View {
        BouncyHeaderScrollview(
            navTitle: "Dummy nav",
            backAction: {},
            closeAction: nil,
            imageHeaderHeight: 375,
            header: {
                Color.blue
                    .overlay(
                        Circle().fill(Color.black)
                            .padding(100)
                    )
            },
            content: {
                Color.red
                    .frame(height: 1500)
            }
        )
    }
}
