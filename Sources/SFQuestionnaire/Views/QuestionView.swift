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
            VStack(alignment: .leading, spacing: .S) {
                Text(item.text)
                    .cta()
                
                switch item.value {
                case let .multiChoice(multi):
                    MultichoiceBodyView(
                        question: multi,
                        answers: currentAnswer?.multichoice,
                        selectedAnswers: { options in
                            answerChanged(
                                item, .multiChoice(
                                    options?.map(\.id)
                                )
                            )
                        }
                    )
                case let .numeric(numeric):
                    NumericBodyView(question: numeric, selectedAnswer: {
                        answerChanged(item, .numeric($0))
                    })
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
                questionnaireId: "",
                index: 0,
                text: "hi my man",
                type: .numeric,
                numeric: .init(
                    maxValue: 0,
                    minValue: 100,
                    format: .decimal
                )
            ),
            currentAnswer: nil,
            answerChanged: { _, _ in})
    }
}
