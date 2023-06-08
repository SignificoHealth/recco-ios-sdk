//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 6/6/23.
//

import SwiftUI
import SFEntities
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
                    .opacity(item.status == .viewed ? 0.4 : 1)
            } else if state.error != nil {
                Color.sfPrimary20.overlay(
                    Image(systemName: "exclamationmark.icloud.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                        .foregroundColor(.sfPrimary)
                )
            } else {
                ProgressView()
            }
        }
        .processors([.resize(width: .cardSize.width)])
        .animation(.linear(duration: 0.1))
        .frame(width: .cardSize.width, height: .cardSize.height)
        .overlay(
            Text(item.headline)
                .body3()
                .frame(maxWidth: .infinity)
                .padding(.XXS)
                .multilineTextAlignment(.center)
                .background(Color.sfBackground),
            alignment: .bottom
        )
        .background(
            Color.sfBackground
        )
        .clipShape(
            RoundedRectangle(cornerRadius: .XXS)
        )
        .shadowBase()
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
