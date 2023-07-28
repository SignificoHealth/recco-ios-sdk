import SwiftUI
import NukeUI
import ReccoHeadless

fileprivate struct BoundsPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct ArticleDetailView: View {
    @Environment(\.currentScrollObservable) var scrollOffsetObservable
    @StateObject var viewModel: ArticleDetailViewModel
    
    @State private var offset: CGFloat = .zero
    @State private var contentHeight: CGFloat = .zero
    @State private var totalViewHeight: CGFloat = UIScreen.main.bounds.height
    
    private var headerHeight: CGFloat {
        UIScreen.main.bounds.height * 0.4
    }
    
    private var negativePaddingTop: CGFloat {
        -UIScreen.main.bounds.height * 0.05
    }
    
    private var shadowOpacity: CGFloat {
        if viewModel.isLoading { return 0 }
        let distance = (totalViewHeight + offset) - ((headerHeight + negativePaddingTop) + contentHeight) + .XL + .L // add some padding to account for the view itself
        
        return (-distance/100).clamped(to: 0...0.3)
    }
    
    var body: some View {
        BouncyHeaderScrollview(
            navTitle: viewModel.heading,
            backAction: viewModel.back,
            closeAction: viewModel.dismiss,
            imageHeaderHeight: headerHeight,
            header: { articleHeader },
            content: {
                VStack(alignment: .leading, spacing: .M) {
                    Text(viewModel.heading)
                        .h1()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Rectangle()
                        .fill(Color.reccoAccent)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                    
                    ReccoLoadingView(viewModel.isLoading) {
                        if let article = viewModel.article {
                            VStack(alignment: .leading, spacing: .L) {
                                if let lead = article.lead {
                                    Text(lead).body1bold()
                                }
                                
                                if let body = article.articleBodyHtml {
                                    HTMLTextView(text: body)
                                        .isEditable(false)
                                        .isSelectable(true)
                                        .autoDetectDataTypes(.all)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, .L)
                .padding(.horizontal, .S)
                .background(Color.reccoBackground)
                .overlay(
                    GeometryReader { proxy in
                        Color.clear.preference(key: BoundsPreference.self, value: proxy.size.height)
                    }
                )
                .cornerRadius(.L, corners: [.topLeft, .topRight])
                .padding(.top, negativePaddingTop)
            }
        )
        .onPreferenceChange(BoundsPreference.self) { new in
            contentHeight = new
        }
        .overlay(
            Group {
                if let article = viewModel.article {
                    ReccoContentInteractionView(
                        rating: article.rating,
                        bookmark: article.bookmarked,
                        toggleBookmark: viewModel.toggleBookmark,
                        rate: viewModel.rate
                    )
                    .shadowBase(opacity: shadowOpacity)
                    .padding(.M)
                }
            },
            alignment: .bottom
        )
        .reccoErrorView(
            error: $viewModel.initialLoadError,
            onRetry: {
                await viewModel.initialLoad()
            },
            onClose: viewModel.back
        )
        .background(Color.reccoBackground.ignoresSafeArea())
        .reccoNotification(error: $viewModel.actionError)
        .overlay(
            GeometryReader { proxy in
                Color.clear.onAppear {
                    totalViewHeight = proxy.size.height
                }
            }
        )
        .showNavigationBarOnScroll(threshold: headerHeight)
        .addCloseSDKToNavbar(viewModel.dismiss)
        .navigationTitle(viewModel.heading)
        .onReceive(scrollOffsetObservable) { _, newOffset in
            withAnimation(.interactiveSpring()) {
                offset = newOffset
            }
        }
        .task {
            await viewModel.initialLoad()
        }
    }
    
    @ViewBuilder
    private var articleHeader: some View {
        if let imageUrl = viewModel.imageUrl {
            LazyImage(
                url: imageUrl
            ) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .addBlackOpacityOverlay()
                } else if state.error != nil {
                    Color.reccoPrimary20.overlay(
                        Image(resource: "error_image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    .addBlackOpacityOverlay()
                } else {
                    ReccoImageLoadingView(feedItem: false)
                        .scaledToFill()
                        .addBlackOpacityOverlay()
                }
            }
            .processors([.resize(width: UIScreen.main.bounds.width)])
            .animation(.linear(duration: 0.3))
        } else {
            ZStack {
                Color.reccoIllustration
                ReccoThemeImage(name: "default_image", resizable: true)
                    .scaledToFill()
            }
        }
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            ArticleDetailView(viewModel: r.get(argument: (
                    ContentId(itemId: "", catalogId: ""),
                    "This is a header",
                    URL(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg"),
                    { (asdf: ContentId) in },
                    { (bool: Bool) in }
            )))
        }
    }
}
