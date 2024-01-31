import ReccoHeadless
import SwiftUI

struct MediaDetailView: View {
    @Environment(\.currentScrollObservable) var scrollOffsetObservable
    @StateObject var viewModel: MediaDetailViewModel

    @State private var offset: CGFloat = .zero
    @State private var showPlayerImageOverlay = true

    private var contentType: ContentType {
        viewModel.mediaType == .audio ? .audio : .video
    }

    private var headerHeight: CGFloat {
        max(300, UIScreen.main.bounds.height * 0.4)
    }

    private var negativePaddingTop: CGFloat {
        -UIScreen.main.bounds.height * 0.05
    }

    var body: some View {
        BouncyHeaderScrollview(
            navTitle: viewModel.heading,
            imageHeaderHeight: headerHeight,
            contentOnTop: false,
            header: {
                mediaHeader
            },
            overlayHeader: {
                playButton
            },
            content: {
                VStack(alignment: .leading, spacing: .M) {
                    Text(viewModel.heading)
                        .h1()
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 0) {
                        Image(resource: contentType.iconName)
                            .renderingMode(.template)
                            .foregroundColor(.reccoPrimary)
                            .padding(.trailing, .XXXS)
                        Text(contentType.caption)
                            .labelSmall()
                        if let duration = viewModel.media?.duration {
                            Text("recco_dashboard_duration".localized(displayDuration(seconds: duration)))
                                .labelSmall()
                        }
                    }
                    .redacted(reason: viewModel.media == nil ? .placeholder : [])

                    Rectangle()
                        .fill(Color.reccoAccent40)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)

                    ReccoLoadingView(viewModel.isLoading) {
                        if let media = viewModel.media {
                            VStack(alignment: .leading, spacing: .L) {
                                if media.textIsTranscription {
                                    Text("recco_audio_detail_transcription".localized)
                                        .foregroundColor(.reccoAccent)
                                        .body1bold()
                                }

                                if let body = media.description {
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
                if let media = viewModel.media {
                    Spacer()
                    ReccoContentInteractionView(
                        rating: media.rating,
                        bookmark: media.bookmarked,
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

    private var playButton: some View {
        Button(
            action: {
                viewModel.playPause()
                withAnimation {
                    showPlayerImageOverlay = false
                }
            },
            label: {
                HStack(spacing: .S) {
                    RoundedRectangle(cornerRadius: .S)
                        .fill(Color.reccoAccent)
                        .frame(width: 88, height: 56)
                        .overlay(
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.reccoWhite)
                        )

                    Text("Play")
                        .foregroundColor(.reccoWhite)
                        .h4()
                        .padding(.horizontal, .XS)
                }
                .frame(height: 72)
                .padding(.XXS)
                .padding(.horizontal, .XXXS)
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
                        .cornerRadius(.XS)
                )
            }
        )
        .opacity(showPlayerImageOverlay ? 1 : 0)
    }

    @ViewBuilder
    private var image: some View {
        if let imageUrl = viewModel.media?.dynamicImageResizingUrl ?? viewModel.imageUrl {
            ReccoURLImageView(
                url: imageUrl,
                alt: viewModel.media?.imageAlt,
                downSampleSize: .size(.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.7))
            ) {
                Color.reccoPrimary20.overlay(
                    Image(resource: "error_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .addBlackOpacityOverlay()
            } loadingView: {
                ReccoImageLoadingView(feedItem: false)
                    .scaledToFill()
                    .addBlackOpacityOverlay()
            } transformView: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .addBlackOpacityOverlay()
            }
        } else {
            ZStack {
                Color.reccoIllustration
                ReccoStyleImage(name: "default_image", resizable: true)
                    .scaledToFill()
            }
        }
    }

    @ViewBuilder
    private var mediaHeader: some View {
        ZStack(alignment: .top) {
            if let media = viewModel.media {
                VStack(spacing: 0) {
                    Spacer()
                    VideoPlayerView(
                        startPlaying: $viewModel.isPlayingMedia,
                        media: media,
                        overlayView: {
                            if viewModel.mediaType == .audio {
                                image
                            }
                        }
                    )
                    .frame(height: headerHeight * 0.8)
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .frame(height: headerHeight)
                .background(Color.black)
                .frame(width: UIScreen.main.bounds.width)
            }

            ZStack {
                image
            }
            .opacity(showPlayerImageOverlay ? 1 : 0)
        }
        .background(Color.reccoWhite)
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            MediaDetailView(viewModel: r.get(argument: (MediaType.audio,
                                                        ContentId(itemId: "", catalogId: ""),
                                                        "This is a header",
                                                        URL(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg"), { (_: ContentId) in }, { (_: Bool) in }
            )))
        }
    }
}
