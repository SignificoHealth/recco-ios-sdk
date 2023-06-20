//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 16/6/23.
//

import SwiftUI
import SFEntities
import UIKit

struct NumericBodyView: View {
    init(
        question: NumericQuestion,
        selectedAnswer: @escaping (Double?) -> Void,
        answer: Double?
    ) {
        self.question = question
        self.selectedAnswer = selectedAnswer
        
        let formattedAnswer = answer.map {
            displayAnswer($0, format: question.format)
        }
        
        if let formattedAnswer {
            self._value = .init(initialValue: formattedAnswer.0)
            self._value2 = .init(initialValue: formattedAnswer.1 ?? "")
        } else {
            self._value = .init(initialValue: "")
            self._value2 = .init(initialValue: "")
        }
    }
    
    let question: NumericQuestion
    var selectedAnswer: (Double?) -> Void

    @State private var value: String
    @State private var value2: String

    var body: some View {
        HStack {
            BiggerInsetsTextField(text: $value)
                .frame(height: 48)
                .placeholder(when: value.isEmpty) {
                    Text("Enter your value")
                        .foregroundColor(.sfPrimary40)
                        .body2()
                }
                .accentColor(.sfAccent)
        }
        .overlay(
            Rectangle()
                .fill(Color.sfPrimary20)
                .frame(height: 2),
            alignment: .bottom
        )
        .onChange(of: value) { newValue in
            selectedAnswer(
                Double(newValue)
            )
        }
    }
}

fileprivate class ModifiedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

fileprivate struct BiggerInsetsTextField: UIViewRepresentable {
    @Binding var text: String
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    func makeUIView(context: Context) -> ModifiedTextField {
        let textField = ModifiedTextField(frame: .zero)
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.textColor = .sfPrimary
        textField.delegate = context.coordinator
        textField.keyboardType = .decimalPad
        textField.tintColor = .sfAccent
        return textField
    }
    
    
    func updateUIView(_ uiView: ModifiedTextField, context: Context) {
        uiView.text = text
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: BiggerInsetsTextField
        
        init(_ parent: BiggerInsetsTextField) {
            self.parent = parent
        }
        
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

extension View {
    func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

struct NumericBodyView_Previews: PreviewProvider {
    static var previews: some View {
        NumericBodyView(question: .init(maxValue: 0, minValue: 10, format: .decimal), selectedAnswer: { _ in }, answer: nil)
    }
}
