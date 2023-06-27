import SwiftUI

public struct RefreshableScrollView<Content: View>: View {
    public init(
        scrollOffset: Binding<CGFloat> = .constant(0),
        refreshAction: @escaping () async -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.refreshAction = refreshAction
        self.scrollOffset = scrollOffset
    }
    
    var scrollOffset: Binding<CGFloat>
    let content: () -> Content
    let refreshAction: () async -> Void
    
    @ViewBuilder
    public var body: some View {
        if #available(iOS 16, *) {
            ObservableScrollView(scrollOffset: scrollOffset) { _ in
                content()
            }
            .refreshable {
                // done to avoid possible bug iOS 16(scrollview gets repainted on pull to refresh, cancelling the structured task). https://developer.apple.com/forums/thread/722673
                Task {
                    await refreshAction()
                }
            }
        } else if #available(iOS 15, *) {
            iOS15RefreshableScrollview(
                scrollOffset: scrollOffset,
                content: content
            )
            .refreshable {
                Task {
                    await refreshAction()
                }
            }
        } else {
            iOS14RefreshableScrollView(
                scrollOffset: scrollOffset,
                content: content,
                refreshAction: refreshAction
            )
            .ignoresSafeArea()
        }
    }
}

@available(iOS 15.0, *)
private struct iOS15RefreshableScrollview<Content: View>: View {
    @Environment(\.refresh) private var refresh
    
    @State private var refreshing: iOS15RefreshControl.State = .threshold {
        didSet {
            guard refreshing != oldValue, refreshing == .disappearing
            else { return }
            withAnimation(nil) {
                refreshing = .threshold
            }
        }
    }
    
    private var content: () -> Content
    private let coordinateSpace = "pullToRefresh"
    private var threshold: CGFloat
    private var scrollOffset: Binding<CGFloat>

    public init(
        scrollOffset: Binding<CGFloat>,
        threshold: CGFloat = 70,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.threshold = threshold
        self.scrollOffset = scrollOffset
    }
    
    @ViewBuilder
    var refreshLoader: some View {
        VStack(spacing: 0) {
            if let refresh = refresh {
                let refreshControlHeight: CGFloat = 56 // 30 + 2 * 8
                GeometryReader { proxy in
                    let offset = proxy.frame(in: .named(coordinateSpace)).minY
                    if offset > threshold {
                        Spacer().task {
                            await UIImpactFeedbackGenerator().impactOccurred(intensity: 0.75)
                            refreshing = .refreshing
                            await refresh()
                            refreshing = .disappearing
                        }
                    }
                    let offsetProgress = min(max(offset / threshold, 0), 1)
                    iOS15RefreshControl(state: refreshing, animation: Double(offsetProgress))
                        .frame(maxWidth: .infinity)
                        .frame(height: refreshControlHeight)
                        .offset(y: -offset)
                }
                .frame(height: refreshControlHeight)
            }
        }
        .frame(height: refreshing == .refreshing ? nil : 0, alignment: .top)
    }
    
    public var body: some View {
        ObservableScrollView(scrollOffset: scrollOffset) { _ in
            VStack(spacing: 0) {
                refreshLoader
                content()
            }
        }
        .animation(.easeInOut, value: refreshing)
        .coordinateSpace(name: coordinateSpace)
    }
}

private class ScrollViewController: UIViewController {
    override func loadView() {
        self.view = UIScrollView()
        self.view.clipsToBounds = false
    }
    
    var scrollView: UIScrollView! {
        view as? UIScrollView
    }
}

private struct iOS14RefreshableScrollView<Content: View>: UIViewControllerRepresentable {
    var scrollOffset: Binding<CGFloat>
    let content: () -> Content
    let refreshAction: (() async -> Void)?
    
    init(
        scrollOffset: Binding<CGFloat>,
        content: @escaping () -> Content,
        refreshAction: @escaping (@escaping () -> Void) -> Void
    ) {
        self.scrollOffset = scrollOffset
        self.content = content
        self.refreshAction = {
            await withCheckedContinuation { continuation in
                refreshAction {
                    continuation.resume()
                }
            }
        }
    }
    
    init(
        scrollOffset: Binding<CGFloat>,
        content: @escaping () -> Content,
        refreshAction: @escaping () async -> Void
    ) {
        self.scrollOffset = scrollOffset
        self.content = content
        self.refreshAction = refreshAction
    }
    
    class ContentContainer<Content: View>: UIHostingController<Content> { }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = ScrollViewController()
        let scrollView = controller.scrollView!
        
        let container = ContentContainer(rootView: content())
        let containerView = container.view!
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        
        let refreshControl = UIRefreshControl()
        refreshControl.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.triggerRefresh(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        container.willMove(toParent: controller)
        controller.addChild(container)
        
        scrollView.addSubview(container.view)

        scrollView.contentLayoutGuide.topAnchor
            .constraint(equalTo: containerView.topAnchor).isActive = true
        scrollView.contentLayoutGuide.leadingAnchor
            .constraint(equalTo: containerView.leadingAnchor).isActive = true
        scrollView.contentLayoutGuide.trailingAnchor
            .constraint(equalTo: containerView.trailingAnchor).isActive = true
        scrollView.contentLayoutGuide.bottomAnchor
            .constraint(equalTo: containerView.bottomAnchor).isActive = true
        containerView.widthAnchor
            .constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.delegate = context.coordinator
        
        container.didMove(toParent: controller)
        return controller
    }
    
    func updateUIViewController(_ viewController: UIViewController, context: Context) {
        viewController.view.backgroundColor = context.environment.scrollViewControllerBackgroundColor
        
        if let controller = viewController.children.first as? ContentContainer<Content> {
            controller.rootView = content()
            controller.view.invalidateIntrinsicContentSize()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: iOS14RefreshableScrollView
        
        init(_ parent: iOS14RefreshableScrollView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.scrollOffset.wrappedValue = scrollView.contentOffset.y
        }
        
        @objc func triggerRefresh(_ control: UIRefreshControl) {
            if let action = parent.refreshAction {
                Task {
                    await action()
                    control.endRefreshing()
                }
            }
        }
    }
}


private struct ScrollViewBackgroundColorKey: EnvironmentKey {
    static var defaultValue: UIColor = .systemBackground
}

private extension EnvironmentValues {
    var scrollViewControllerBackgroundColor: UIColor {
        get { self[ScrollViewBackgroundColorKey.self] }
        set { self[ScrollViewBackgroundColorKey.self] = newValue }
    }
}

extension RefreshableScrollView {
    @ViewBuilder
    func background(_ color: UIColor) -> some View {
        if #available(iOS 15, *) {
            background(Color(color))
        } else {
            environment(\.scrollViewControllerBackgroundColor, color)
        }
    }
}

private struct RotationModifier: ViewModifier {
    
    let angle: Angle
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(angle)
    }
}

@available(iOS 15.0, *)
private struct iOS15RefreshControl: View {
    
    enum State {
        case threshold
        case refreshing
        case disappearing
    }
    
    var state: State
    var animation: CGFloat
    
    var body: some View {
        TimelineView(.animation) { timeline in
        if state != .disappearing {
                let progress: CGFloat = {
                if state == .threshold {
                    return animation
                } else if state == .refreshing {
                    return timeline.date.timeIntervalSinceReferenceDate.remainder(dividingBy: 1)
                } else {
                    return 1
                }
                }()
                ZStack {
                    ForEach(0..<8, id: \.self) { index in
                        capsule(index, time: progress)
                    }
                }
                .frame(width: 30, height: 30)
                .transition(transition)
                .animation(.default, value: state)
            }
        }
    }
    
    private func capsule(_ index: Int, time: CGFloat) -> some View {
        Capsule()
            .fill(.gray)
            .frame(width: 10, height: 4)
            .offset(x: 10)
            .rotationEffect(.degrees(360 / 8 * Double(index) - 90), anchor: .center)
            .opacity(opacity(index: index, animation: time))
    }
    
    private func opacity(index: Int, animation: CGFloat) -> CGFloat {
        let i = CGFloat(index)
        switch state {
        case .threshold:
            let start: CGFloat = i / 7 / 2
            let curvedAnimation = pow(animation, 2)
            let clampedCurveAnimation = max(curvedAnimation - start, 0)
            return min(clampedCurveAnimation / 0.5, 1)
        case .refreshing:
            let start: CGFloat = i / 8
            return ((1 - animation) + start).truncatingRemainder(dividingBy: 1)
        case .disappearing:
            return 0
        }
    }
    
    private var transition: AnyTransition {
        let removal = AnyTransition.scale(scale: 0)
            .combined(with: .opacity)
            .combined(with: .modifier(active: RotationModifier(angle: .degrees(360)),
                                      identity: RotationModifier(angle: .degrees(0))))
        return .asymmetric(insertion: .identity, removal: removal)
    }
}
