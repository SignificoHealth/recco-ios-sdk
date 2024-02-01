import ReccoHeadless
import SwiftUI

private struct BoundsPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct ArticleDetailView: View {
    @Environment(\.currentScrollObservable) var scrollOffsetObservable
    @StateObject var viewModel: ArticleDetailViewModel
    @State private var offset: CGFloat = .zero

    private var headerHeight: CGFloat {
        UIScreen.main.bounds.height * 0.4
    }

    private var negativePaddingTop: CGFloat {
        -UIScreen.main.bounds.height * 0.05
    }

    var body: some View {
        BouncyHeaderScrollview(
            navTitle: viewModel.heading,
            imageHeaderHeight: headerHeight,
            header: { articleHeader },
            content: {
                VStack(alignment: .leading, spacing: .M) {
                    Text(viewModel.heading)
                        .h1()
                        .fixedSize(horizontal: false, vertical: true)

                    if let duration = viewModel.article?.duration {
                        HStack(spacing: 0) {
                            Image(resource: ContentType.articles.iconName)
                                .renderingMode(.template)
                                .foregroundColor(.reccoPrimary)
                                .padding(.trailing, .XXXS)
                            Text(ContentType.articles.caption)
                                .labelSmall()

                            Text("recco_dashboard_duration".localized(displayDuration(seconds: duration)))
                                .labelSmall()
                        }
                    }

                    Rectangle()
                        .fill(Color.reccoAccent40)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)

                    ReccoLoadingView(viewModel.isLoading) {
                        if let article = viewModel.article {
                            VStack(alignment: .leading, spacing: .L) {
                                if let lead = article.lead {
                                    Text(lead).body1bold()
                                }

                                if let audioUrl = article.audioUrl {
                                    AudioPlayerView(url: audioUrl, nowPlayingInfo: .init(
                                        title: article.headline,
                                        subtitle: article.lead,
                                        imageUrl: viewModel.imageUrl
                                    ))
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
                .cornerRadius(.L, corners: [.topLeft, .topRight])
                .padding(.top, negativePaddingTop)
            }
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
        .environment(\.currentScrollOffsetId, "\(self)")
        .addCloseSDKToNavbar(viewModel.dismiss)
        .navigationTitle(viewModel.heading)
        .onReceive(scrollOffsetObservable) { _, newOffset in
            withAnimation(.interactiveSpring()) {
                offset = newOffset
            }
        }
        .overlay(
            VStack {
                if let article = viewModel.article {
                    Spacer()
                    ReccoContentInteractionView(
                        rating: article.rating,
                        bookmark: article.bookmarked,
                        toggleBookmark: viewModel.toggleBookmark,
                        rate: viewModel.rate
                    )
                }
            }.ignoresSafeArea(),
            alignment: .bottom
        )
        .task {
            await viewModel.initialLoad()
        }
    }

    @ViewBuilder
    private var articleHeader: some View {
        ReccoContentImageView(
            url: viewModel.article?.imageUrl ?? viewModel.imageUrl,
            alt: viewModel.article?.imageAlt
        )
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            ArticleDetailView(viewModel: r.get(argument: (
                ContentId(itemId: "", catalogId: ""),
                "This is a header",
                URL(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg"), { (_: ContentId) in }, { (_: Bool) in }
            )))
        }
    }
}
