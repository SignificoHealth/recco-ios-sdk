import SwiftUI
import ReccoHeadless

struct NumericBodyView: View {
    private var locale: Locale {
        .current
    }
    
    let question: NumericQuestion
    var selectedAnswer: (Double?) -> Void
    
    init(
        question: NumericQuestion,
        selectedAnswer: @escaping (Double?) -> Void,
        answer: Double?
    ) {
        self.question = question
        self.selectedAnswer = selectedAnswer
        
        let formattedAnswer = answer.map {
            displayAnswer(
                $0,
                locale: Locale.current,
                format: question.format
            )
        }
        
        if let formattedAnswer {
            self._value = .init(initialValue: formattedAnswer.0)
            self._value2 = .init(initialValue: formattedAnswer.1 ?? "")
        } else {
            self._value = .init(initialValue: "")
            self._value2 = .init(initialValue: "")
        }
    }

    @State private var value: String
    @State private var value2: String

    var body: some View {
        HStack(spacing: .M) {
            switch (locale.getUnitSystem(), question.format) {
            case (_, .decimal), (_, .integer), (.metric, .humanHeight), (_, .humanWeight):
                ReccoFieldView(
                    text: $value,
                    keyboardType: question.format.keyboard,
                    placeholder: question.format.placeholder(locale),
                    label: question.format.label(locale)?.0
                )
            
            case (.imperialUS, .humanHeight), (.imperialGB, .humanHeight):
                ReccoFieldView(
                    text: $value,
                    placeholder: question.format.placeholder(locale),
                    label: question.format.label(locale)?.0
                )
                
                ReccoFieldView(
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
