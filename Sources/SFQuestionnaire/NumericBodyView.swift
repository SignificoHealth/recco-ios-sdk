//
//  SwiftUIView.swift
//  
//
//  Created by Adrián R on 16/6/23.
//

import SwiftUI
import SFEntities

struct NumericBodyView: View {
    let question: NumericQuestion
    var selectedAnswer: (Double?) -> Void

    @State private var value: String = ""
    var body: some View {
        HStack {
            TextField("", text: $value)
                .frame(height: 48)
                .placeholder(when: value.isEmpty) {
                    Text("Enter your value")
                        .foregroundColor(.sfPrimary40)
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.sfPrimary)
                .keyboardType(.decimalPad)
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
        NumericBodyView(question: .init(maxValue: 0, minValue: 10, format: .decimal), selectedAnswer: { _ in })
    }
}
