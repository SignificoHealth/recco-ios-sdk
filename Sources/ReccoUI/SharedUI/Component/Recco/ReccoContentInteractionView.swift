import SwiftUI
import ReccoHeadless

struct ReccoContentInteractionView: View {
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
            }

            Rectangle()
                .fill(Color.reccoPrimary20)
                .frame(width: 2)
            
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
            }
        }
        .padding(.vertical, .XXS)
        .padding(.horizontal, .XS)
        .background(Color.reccoBackground)
        .cornerRadius(.L, corners: .allCorners)
        .fixedSize()
    }
}

struct ReccoContentInteractionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.reccoLightGray
            
            ReccoContentInteractionView(
                rating: .like,
                bookmark: true,
                toggleBookmark: {},
                rate: { _ in }
            )
        }
    }
}
