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
    var currentAnswer: EitherAnswerType?
    var answerChanged: (Question, EitherAnswerType) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .L) {
                Text(item.text)
                    .cta()
                
                switch item.value {
                case let .multiChoice(multi):
                    MultichoiceBodyView(
                        question: multi,
                        answers: currentAnswer?.multichoice,
                        selectedAnswers: { options in
                            answerChanged(item, .multiChoice(options.map(\.id)))
                        }
                    )
                case let .numeric(numeric):
                    NumericBodyView(question: numeric)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, .M)
        }
        .background(Color.sfBackground)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(
            item: try! .init(
                id: UUID().uuidString,
                index: 0,
                text: "hi my man",
                type: .multichoice,
                multiChoice: .init(
                    maxOptions: 0,
                    minOptions: 1,
                    options: [.init(id: 0, text: "Answer 1"), .init(id: 1, text: "Answer 2"), .init(id: 2, text: "Answer 3 Answer 3 Answer 3 Answer 3 Answer 3 Answer 3 v Answer 3 Answer 3 Answer 3 Answer 3 Answer 3")]
                )
            ),
            currentAnswer: nil,
            answerChanged: { _, _ in})
    }
}
