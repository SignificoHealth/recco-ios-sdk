//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 15/6/23.
//

import SwiftUI
import SFEntities

struct QuestionView: View {
    var item: Question
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .L) {
                Text(item.text)
                    .cta()
            }
            .padding(.horizontal, .M)
        }
        .background(Color.sfBackground)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(item: try! .init(id: UUID().uuidString, index: 0, text: "hi my man", type: .multichoice))
    }
}
