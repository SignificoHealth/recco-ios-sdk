import SwiftUI
import ReccoHeadless
import NukeUI

struct FeedItemView: View {
    let item: AppUserRecommendation
    
    var body: some View {
        LazyImage(
            url: item.imageUrl
        ) { state in
            if let image = state.image {
                image.resizable()
                    .scaledToFill()
                    .opacity(
                        item.status == .viewed ? 0.4 : 1
                    )
            } else if state.error != nil {
                Color.reccoPrimary20.overlay(
                    Image(resource: "error_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
            } else {
                ReccoImageLoadingView(feedItem: true)
            }
        }
        .processors([.resize(width: .cardSize.width)])
        .animation(.linear(duration: 0.1))
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
        ))
    }
}
