import ReccoHeadless
import SwiftUI

struct FeedItemView: View {
    var item: AppUserRecommendation
    var fromBookmarks = false

    private var opacity: CGFloat {
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
            VStack(alignment: .leading, spacing: .XXS) {
                Text(item.headline)
                    .body3()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 0) {
                    Image(resource: item.type.iconName)
                        .padding(.trailing, .XXXS)
                    Text(item.type.caption)
                        .contentType()
                    if let seconds = item.durationSeconds {
                        Text("recco_dashboard_duration".localized(displayDuration(seconds: seconds)))
                            .contentType()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.XS)
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
            headline: "This card is too good to be true",
            imageUrl: .init(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg"), durationSeconds: 100
        ), fromBookmarks: false)
    }
}
