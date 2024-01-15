//
//  File.swift
//
//
//  Created by Saúl on 29/11/23.
//

import ReccoHeadless
import SwiftUI

struct QuestionnaireItemView: View {
    var item: AppUserRecommendation
    var topic: ReccoTopic?
    var fromBookmarks = false

    var opacity: CGFloat {
        fromBookmarks ?
            1 : item.status == .viewed ?
            0.4 : 1
    }

    var body: some View {
        VStack(spacing: .XS) {
            Spacer()

            Text("recco_questionnaire_card".localized(topic?.displayName ?? ""))
                .body2bold()
                .lineLimit(3)
                .frame(maxWidth: .infinity)
                .padding(.XXS)
                .multilineTextAlignment(.center)

            ReccoTopicImageView(topic: topic ?? ReccoTopic.mentalWellbeing)
                .frame(
                    minWidth: .minCardWidth, idealWidth: .cardSize.width, maxWidth: .cardSize.width
                )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: .XXS)
        )
        .frame(
            minWidth: .minCardWidth, idealWidth: .cardSize.width, maxWidth: .cardSize.width,
            minHeight: .cardSize.height, maxHeight: .cardSize.height
        )
        .background(
            RoundedRectangle(cornerRadius: .XXS)
                .fill(Color.reccoAccent20)
                .shadowBase()
        )
    }
}

struct QuestionnaireItemView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireItemView(item: .init(
            id: .init(itemId: "", catalogId: ""),
            type: .questionnaire,
            rating: .like,
            status: .noInteraction,
            headline: "This card is good",
            imageUrl: .init(string: "https://images.pexels.com/photos/708440/pexels-photo-708440.jpeg")
        ), fromBookmarks: false)
    }
}
