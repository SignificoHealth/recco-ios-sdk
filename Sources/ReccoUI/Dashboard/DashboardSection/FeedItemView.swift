import ReccoHeadless
import SwiftUI

struct FeedItemView: View {
    var item: AppUserRecommendation
    var fromBookmarks = false

    var opacity: CGFloat {
        fromBookmarks ?
            1 : item.status == .viewed ?
                0.4 : 1
    }

    var body: some View {
        ReccoURLImageView(
            url: item.imageUrl,
            alt: item.imageAlt,
            downSampleSize: .size(CGFloat.cardSize)
        ) {
            Color.reccoPrimary20.overlay(
                Image(resource: "error_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
        } loadingView: {
            ReccoImageLoadingView(feedItem: true)
        } transformView: { image in
            image
                .resizable()
                .scaledToFill()
                .opacity(opacity)
        }
        .frame(
            minWidth: .minCardWidth, idealWidth: .cardSize.width, maxWidth: .cardSize.width,
            minHeight: .cardSize.height, maxHeight: .cardSize.height
        )
        .overlay(
            Text(item.headline)
                .body3()
                .lineLimit(2)
                .frame(maxWidth: .infinity)
                .padding(.XXS)
                .multilineTextAlignment(.center)
                .frame(height: .L + .M)
                .background(Color.reccoBackground),
            alignment: .bottom
        )
        .clipShape(
            RoundedRectangle(cornerRadius: .XXS)
        )
        .background(
            RoundedRectangle(cornerRadius: .XXS)
                .fill(Color.reccoBackground)
                .shadowBase()
        )
    }
}

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(item: .init(
            id: .init(itemId: "", catalogId: ""),
            type: .articles,
            rating: .like,
            status: .noInteraction,
            headline: "This card is good",
            imageUrl: .init(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg")
        ), fromBookmarks: false)
    }
}
