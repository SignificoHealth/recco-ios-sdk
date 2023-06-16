//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 16/6/23.
//

import SwiftUI
import SFEntities

private struct Selectable<T: Equatable & Hashable>: Equatable, Hashable {
    var selected: Bool
    let value: T
}

struct MultichoiceBodyView: View {
    var question: MultiChoiceQuestion
    var answers: [Int]?
    var selectedAnswers: ([MultiChoiceAnswerOption]) -> Void
    
    @State private var options: [Selectable<MultiChoiceAnswerOption>]
    
    private var isSingleChoice: Bool {
        return (0...1).contains(
            question.maxOptions - question.minOptions
        )
    }
    
    init(
        question: MultiChoiceQuestion,
        answers: [Int]? = nil,
        selectedAnswers: @escaping ([MultiChoiceAnswerOption]) -> Void
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
            ForEach($options, id: \.self) { $option in
                item(for: $option)
            }
        }
    }
    
    @ViewBuilder
    private func item(for option: Binding<Selectable<MultiChoiceAnswerOption>>) -> some View {
        Button {
            if isSingleChoice {
                options.indices.forEach { options[$0].selected = false }
            }
            
            option.wrappedValue.selected.toggle()
            
            selectedAnswers(
                options
                    .filter(\.selected)
                    .map(\.value)
            )
        } label: {
            HStack(spacing: .S) {
                Text(option.wrappedValue.value.text)
                    .foregroundColor(option.wrappedValue.selected ? .sfOnAccent : .sfPrimary)
                    .body2()
                    .multilineTextAlignment(.leading)
                
                if !isSingleChoice {
                    Spacer()
                    
                    Image(resource: option.wrappedValue.selected ? "check_ic" : "plus_ic")
                        .renderingMode(.template)
                        .foregroundColor(option.wrappedValue.selected ? .sfAccent : .sfPrimary)
                }
            }
            .padding(.S)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                option.wrappedValue.selected ?
                    Color.sfAccent20 :
                    Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: .XXS))
            .background(
                RoundedRectangle(cornerRadius: .XXS)
                    .stroke()
                    .fill(
                        option.wrappedValue.selected ?
                            Color.sfAccent :
                            Color.sfPrimary20
                    )
            )
        }
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
