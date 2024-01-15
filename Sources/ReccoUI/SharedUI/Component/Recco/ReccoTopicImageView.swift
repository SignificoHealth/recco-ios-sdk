//
//  File.swift
//  
//
//  Created by Saúl on 19/12/23.
//

import ReccoHeadless
import SwiftUI

struct ReccoTopicImageView: View {
    let topic: ReccoTopic?

    var body: some View {
        let imageName: String

        switch topic {
        case .physicalActivity:
            imageName = "activity"
        case .nutrition:
            imageName = "eating_habits"
        case .sleep:
            imageName = "sleep"
        case .mentalWellbeing, .none:
            imageName = "people_digital"
        }

        return ReccoStyleImage(name: imageName, resizable: true)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct ReccoTopicImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HStack(spacing: .M) {
                ForEach(ReccoTopic.allCases, id: \.self) { topic in
                    ReccoTopicImageView(topic: topic)
                }
            }
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("ReccoTopicImageView: Light Mode")

            // Dark mode preview
            HStack(spacing: .M) {
                ForEach(ReccoTopic.allCases, id: \.self) { topic in
                    ReccoTopicImageView(topic: topic)
                }
            }
            .padding()
            .previewLayout(.sizeThatFits)
            .background(Color.reccoBackground)
            .colorScheme(.dark)
            .previewDisplayName("ReccoTopicImageView: Dark Mode")
        }
    }
}
