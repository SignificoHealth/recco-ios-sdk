//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 15/6/23.
//

import SwiftUI
import SFEntities
import SFSharedUI

public struct QuestionnaireView: View {
    @StateObject var viewModel: QuestionnaireViewModel
    
    public init(viewModel: QuestionnaireViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        SFLoadingUnwrappingView(
            viewModel.questions,
            error: $viewModel.initialLoadError,
            retry: { await viewModel.getQuestionnaire() }
        ) { questions in
            VStack(spacing: .XXS) {
                progressView
                    .padding(.horizontal, .M)
                
                TabView(
                    selection: $viewModel.currentQuestion.animation(.interactiveSpring())
                ) {
                    ForEach(viewModel.questions ?? [], id: \.self) { question in
                        QuestionView(
                            item: question,
                            currentAnswer: viewModel.answers[question]??.value,
                            answerChanged: viewModel.answerFor
                        )
                        .tag(Optional(question))
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: .XXS) {
                    if viewModel.currentIndex != 0 {
                        SFButton(
                            style: .secondary,
                            leadingImage: Image(resource: "chevron_back"),
                            action: {
                                withAnimation(.interactiveSpring()) {
                                    viewModel.previousQuestion()
                                }
                            }
                        )
                        .frame(width: 40)
                    }
                                    
                    SFButton(
                        text: viewModel.isOnLastQuestion ? "questionnaire.button.finish".localized : "questionnaire.button.continue".localized,
                        action: {
                            withAnimation(.interactiveSpring()) {
                                viewModel.next()
                            }
                        }
                    )
                }
                .padding(.M)
            }
        }
        .navigationBarHidden(false)
        .navigationTitle(viewModel.topic.displayName)
        .background(Color.sfBackground.ignoresSafeArea())
        .task {
            if viewModel.questions == nil {
                await viewModel.getQuestionnaire()
            }
        }
    }
    
    @ViewBuilder
    var progressView: some View {
        if let questions = viewModel.questions,
           let current = viewModel.currentQuestion,
           let currentQuestionNumber = questions.firstIndex(of: current) {
            VStack(spacing: .S){
                ProgressView(
                    value: Double(currentQuestionNumber),
                    total: Double(questions.count)
                )
                .accentColor(.sfAccent)
                
                (
                    Text("\(currentQuestionNumber + 1)")
                    .foregroundColor(.sfAccent) +
                    Text("/\(questions.count)")
                ).h4()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            QuestionnaireView(
                viewModel: r.get(
                    argument: SFTopic.physicalActivity
                )
            )
        }
    }
}
