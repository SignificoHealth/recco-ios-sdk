import SwiftUI
import ReccoHeadless

struct QuestionnaireView: View {
    @StateObject var viewModel: QuestionnaireViewModel
    var navTitle: String
    
    init(
        viewModel: QuestionnaireViewModel,
        navTitle: String
    ) {
        self.navTitle = navTitle
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ReccoLoadingUnwrappingView(
            viewModel.questions,
            error: $viewModel.initialLoadError,
            retry: { await viewModel.getQuestionnaire() }
        ) { questions in
            VStack(spacing: .XXS) {
                questionnaireProgressView
                    .padding(.horizontal, .M)
                
                TabView(
                    selection: $viewModel.currentQuestion.animation(.interactiveSpring())
                ) {
                    ForEach(viewModel.questions ?? [], id: \.self) { question in
                        QuestionView(
                            item: question,
                            currentAnswer: viewModel.answers[question]??.value,
                            answerChanged: { viewModel.answer($1, for: $0)
                            }
                        )
                        .tag(Optional(question))
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: .XXS) {
                    if viewModel.currentIndex != 0 {
                        ReccoButtonView(
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
                                    
                    ReccoButtonView(
                        text: viewModel.isOnLastQuestion ? "recco_finish_button".localized : "recco_continue_button".localized,
                        isLoading: viewModel.sendLoading,
                        action: {
                            withAnimation(.interactiveSpring()) {
                                viewModel.next()
                            }
                        }
                    )
                    .disabled(!viewModel.mainButtonEnabled)
                }
                .padding(.M)
            }
        }
        .onChange(of: viewModel.currentQuestion, perform: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIApplication.shared.endEditing()
            }
        })
        .navigationBarHidden(false)
        .navigationTitle(navTitle)
        .background(Color.reccoBackground.ignoresSafeArea())
        .addCloseSDKToNavbar(viewModel.dismiss)
        .reccoNotification(error: $viewModel.sendError)
        .task {
            if viewModel.questions == nil {
                await viewModel.getQuestionnaire()
            }
        }
    }
    
    @ViewBuilder
    var questionnaireProgressView: some View {
        if let questions = viewModel.questions,
           let current = viewModel.currentQuestion,
           let currentQuestionNumber = questions.firstIndex(of: current) {
            VStack(spacing: .S){
                ProgressView(
                    value: Double(currentQuestionNumber),
                    total: Double(questions.count)
                )
                .accentColor(.reccoAccent)
                
                (
                    Text("\(currentQuestionNumber + 1)")
                    .foregroundColor(.reccoAccent) +
                    Text("/\(questions.count)")
                ).h4()
            }
        }
    }
}


extension UIApplication {
    fileprivate func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            QuestionnaireView(
                viewModel: r.get(
                    argument: ReccoTopic.physicalActivity
                ),
                navTitle: "Title"
            )
        }
    }
}
