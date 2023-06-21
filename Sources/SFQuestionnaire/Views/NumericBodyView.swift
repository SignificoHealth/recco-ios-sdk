//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 16/6/23.
//

import SwiftUI
import SFEntities
import SFSharedUI

struct NumericBodyView: View {
    @Environment(\.locale) var locale
    
    init(
        question: NumericQuestion,
        selectedAnswer: @escaping (Double?) -> Void,
        answer: Double?
    ) {
        self.question = question
        self.selectedAnswer = selectedAnswer
        self._value = .init(initialValue: "")
        self._value2 = .init(initialValue: "")

        defer {
            let formattedAnswer = answer.map {
                displayAnswer($0, locale: locale, format: question.format)
            }

            if let formattedAnswer {
                self.value = formattedAnswer.0
                self.value2 = formattedAnswer.1 ?? ""
            }
        }
    }
    
    let question: NumericQuestion
    var selectedAnswer: (Double?) -> Void

    @State private var value: String
    @State private var value2: String

    var body: some View {
        HStack(spacing: .M) {
            switch (locale.getUnitSystem(), question.format) {
            case (_, .decimal), (_, .integer), (.metric, .humanHeight), (_, .humanWeight):
                SFFieldView(
                    text: $value,
                    keyboardType: question.format.keyboard,
                    placeholder: question.format.placeholder(locale),
                    label: question.format.label(locale)?.0
                )
            
            case (.imperialUS, .humanHeight), (.imperialGB, .humanHeight):
                SFFieldView(
                    text: $value,
                    placeholder: question.format.placeholder(locale),
                    label: question.format.label(locale)?.0
                )
                
                SFFieldView(
                    text: $value2,
                    placeholder: question.format.placeholder(locale),
                    label: question.format.label(locale)?.1
                )
            }
        }
        .onChange(of: value) { newValue in
            sendAnswer(value1: newValue, value2: value2)
        }
        .onChange(of: value2) { newValue in
            sendAnswer(value1: value, value2: newValue)
        }
    }
    
    private func sendAnswer(value1: String, value2: String) {
        let value = formatAnswer(
            value1,
            second: value2,
            format: question.format,
            locale: locale
        )
                
        selectedAnswer(value)
    }
}

struct NumericBodyView_Previews: PreviewProvider {
    static var previews: some View {
        NumericBodyView(question: .init(maxValue: 0, minValue: 10, format: .humanWeight), selectedAnswer: { _ in }, answer: nil)
            .environment(\.locale, Locale.init(identifier: "en_GB"))
    }
}
