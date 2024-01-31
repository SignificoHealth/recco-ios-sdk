import ReccoHeadless
import SwiftUI

struct ReccoContentInteractionView: View {
    @Environment(\.colorScheme) var colorScheme

    init(rating: ContentRating, bookmark: Bool, toggleBookmark: @escaping () async -> Void, rate: @escaping (ContentRating) async -> Void) {
        self.rating = rating
        self.bookmark = bookmark
        self.toggleBookmark = toggleBookmark
        self.rate = rate
    }

    var rating: ContentRating
    var bookmark: Bool
    var toggleBookmark: () async -> Void
    var rate: (ContentRating) async -> Void

    private var safeAreaBottomInset: CGFloat {
        UIApplication.shared.windows.filter(\.isKeyWindow).first?.safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        HStack(spacing: .XS) {
            Button {
                Task {
                    await toggleBookmark()
                }
            } label: {
                Image(resource: bookmark ? "bookmark_filled" : "bookmark_outline")
                    .renderingMode(.template)
                    .foregroundColor(
                        bookmark ? Color.reccoAccent : Color.reccoPrimary
                    )
                    .frame(width: 40, height: 40)
                    .contentShape(
                        Rectangle()
                    )
            }

            Rectangle()
                .fill(Color.reccoPrimary20)
                .frame(width: 2)
                .frame(height: 24)

            Button {
                Task {
                    await rate(rating == .like ? .notRated : .like)
                }
            } label: {
                Image(resource: rating == .like ? "like_filled" : "like_outline")
                    .renderingMode(.template)
                    .foregroundColor(
                        rating == .like ? Color.reccoAccent : Color.reccoPrimary
                    )
                    .frame(width: 40, height: 40)
                    .contentShape(
                        Rectangle()
                    )
            }

            Button {
                Task {
                    await rate(rating == .dislike ? .notRated : .dislike)
                }
            } label: {
                Image(resource: rating == .dislike ? "dislike_filled" : "dislike_outline")
                    .renderingMode(.template)
                    .foregroundColor(
                        rating == .dislike ? Color.reccoAccent : Color.reccoPrimary
                    )
                    .frame(width: 40, height: 40)
                    .contentShape(
                        Rectangle()
                    )
            }
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.container, edges: .bottom)
        .frame(height: 56 + safeAreaBottomInset, alignment: .top)
        .background(
            VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight))
        )
    }
}

struct ReccoContentInteractionView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ReccoContentInteractionView(
                rating: .like,
                bookmark: true,
                toggleBookmark: {},
                rate: { _ in }
            )
        }
    }
}
