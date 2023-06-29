import SwiftUI
import ReccoHeadless

private struct Selectable<T: Equatable & Hashable>: Equatable, Hashable {
    var selected: Bool
    let value: T
}

struct MultichoiceBodyView: View {
    var question: MultiChoiceQuestion
    var answers: [Int]?
    var selectedAnswers: ([MultiChoiceAnswerOption]?) -> Void
    
    @State private var options: [Selectable<MultiChoiceAnswerOption>]
    
    init(
        question: MultiChoiceQuestion,
        answers: [Int]? = nil,
        selectedAnswers: @escaping ([MultiChoiceAnswerOption]?) -> Void
    ) {
        self.question = question
        self.answers = answers
        self.selectedAnswers = selectedAnswers
        self.options = question.options.map {
            Selectable(
                selected: answers?.contains($0.id) ?? false,
                value: $0
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .XXS) {
            if !question.isSingleChoice {
                Text("questionnaire.button.multiple".localized)
                    .foregroundColor(.reccoPrimary40)
                    .body3()
                    .padding(.bottom, .M)
            }
            
            ForEach($options, id: \.self) { $option in
                item(for: $option)
            }
        }
    }
    
    @ViewBuilder
    private func item(for option: Binding<Selectable<MultiChoiceAnswerOption>>) -> some View {
        Button {
            performLogicOnSelecting(option: option)
        } label: {
            HStack(spacing: .S) {
                Text(option.wrappedValue.value.text)
                    .foregroundColor(option.wrappedValue.selected ? .reccoOnAccent : .reccoPrimary)
                    .body2()
                    .multilineTextAlignment(.leading)
                
                if !question.isSingleChoice {
                    Spacer()
                    
                    Image(resource: option.wrappedValue.selected ? "check_ic" : "plus_ic")
                        .renderingMode(.template)
                        .foregroundColor(option.wrappedValue.selected ? .reccoAccent : .reccoPrimary)
                }
            }
            .padding(.S)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                option.wrappedValue.selected ?
                    Color.reccoAccent20 :
                    Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: .XXS))
            .background(
                RoundedRectangle(cornerRadius: .XXS)
                    .stroke()
                    .fill(
                        option.wrappedValue.selected ?
                            Color.reccoAccent :
                            Color.reccoPrimary20
                    )
            )
        }
    }
    
    private func performLogicOnSelecting(option: Binding<Selectable<MultiChoiceAnswerOption>>) {
        // if it is not already selected
        if !option.wrappedValue.selected {
            if question.isSingleChoice {
                options.indices.forEach { options[$0].selected = false }
            }
            
            if question.maxOptions <= options.filter(\.selected).count {
                options
                    .firstIndex(where: \.selected)
                    .map { options[$0].selected = false  }
            }
        }
        
        option.wrappedValue.selected.toggle()
        
        performFeedback(selected: option.wrappedValue.selected)
        
        let selected = options
            .filter(\.selected)
            .map(\.value)
        
        withAnimation {
            selectedAnswers(
                selected.isEmpty ? nil : selected
            )
        }
    }
    
    private func performFeedback(selected: Bool) {
        HapticPlayer
            .shared
            .playHaptic(pattern: selected ? .selected : .deselected)
    }
}

struct MultichoiceBodyView_Previews: PreviewProvider {
    static var previews: some View {
        MultichoiceBodyView(
            question: .init(
                maxOptions: 1,
                minOptions: 0,
                options: []
            ),
            answers: nil,
            selectedAnswers: { _ in }
        )
    }
}
