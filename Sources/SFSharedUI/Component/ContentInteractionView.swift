//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 8/6/23.
//

import SwiftUI
import SFEntities

public struct ContentInteractionView: View {
    public init(rating: ContentRating, bookmark: Bool, toggleBookmark: @escaping () -> Void, rate: @escaping (ContentRating) -> Void) {
        self.rating = rating
        self.bookmark = bookmark
        self.toggleBookmark = toggleBookmark
        self.rate = rate
    }
    
    var rating: ContentRating
    var bookmark: Bool
    var toggleBookmark: () -> Void
    var rate: (ContentRating) -> Void
    
    public var body: some View {
        HStack(spacing: .XS) {
            Button {
                toggleBookmark()
            } label: {
                Image(resource: bookmark ? "bookmark_filled" : "bookmark_outline")
                    .renderingMode(.template)
                    .foregroundColor(
                        bookmark ? Color.sfAccent : Color.sfPrimary
                    )
            }

            Rectangle()
                .fill(Color.sfPrimary20)
                .frame(width: 2)
            
            Button {
                rate(rating == .like ? .notRated : .like)
            } label: {
                Image(resource: rating == .like ? "like_filled" : "like_outline")
                    .renderingMode(.template)
                    .foregroundColor(
                        rating == .like ? Color.sfAccent : Color.sfPrimary
                    )
            }
            
            Button {
                rate(rating == .dislike ? .notRated : .dislike)
            } label: {
                Image(resource: rating == .dislike ? "dislike_filled" : "dislike_outline")
                    .renderingMode(.template)
                    .foregroundColor(
                        rating == .dislike ? Color.sfAccent : Color.sfPrimary
                    )
            }
        }
        .padding(.vertical, .XXS)
        .padding(.horizontal, .XS)
        .background(Color.sfBackground)
        .cornerRadius(.L, corners: .allCorners)
        .fixedSize()
    }
}

struct ContentInteractionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.sfSurface
            
            ContentInteractionView(
                rating: .like,
                bookmark: true,
                toggleBookmark: {},
                rate: { _ in }
            )
        }
    }
}
