import SwiftUI
import UIKit

struct ReccoFieldView: View {
    init(
        text: Binding<String>,
        keyboardType: UIKeyboardType = .decimalPad,
        placeholder: String,
        label: String? = nil
    ) {
        self._text = text
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.label = label
    }

    @State private var focused = false

    @Binding var text: String
    var keyboardType: UIKeyboardType
    var placeholder: String
    var label: String?

    var body: some View {
        HStack(spacing: .S) {
            UIKitTextField(
                isFocused: $focused,
                text: $text,
                keyboardType: keyboardType
            )
            .frame(height: 48)
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(.reccoPrimary40)
                    .body2()
            }
            .padding(.leading, .S)

            if let label {
                Spacer()
                Text(label)
                    .foregroundColor(.reccoPrimary40)
                    .body2()
                    .padding(.trailing, .S)
            }
        }
        .accentColor(.reccoAccent)
        .overlay(
            Rectangle()
                .fill(focused ? Color.reccoAccent : Color.reccoPrimary20)
                .frame(height: 2),
            alignment: .bottom
        )
        .background(
            Rectangle()
                .fill(focused ? Color.reccoAccent20 : Color.reccoBackground)
                .cornerRadius(.XXS, corners: [.topLeft, .topRight])
        )
    }
}

private class ModifiedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

private struct UIKitTextField: UIViewRepresentable {
    @Binding var isFocused: Bool
    @Binding var text: String
    var keyboardType: UIKeyboardType

    func makeUIView(context: Context) -> ModifiedTextField {
        let textField = ModifiedTextField(frame: .zero)
        textField.font = CurrentReccoStyle.font.uiFont(size: 15, weight: .medium)
        textField.textColor = .reccoPrimary
        textField.delegate = context.coordinator
        textField.keyboardType = .decimalPad
        textField.tintColor = .reccoAccent
        textField.keyboardType = keyboardType
        textField.backgroundColor = .clear
        return textField
    }

    func updateUIView(_ uiView: ModifiedTextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: UIKitTextField

        init(_ parent: UIKitTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFocused = true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFocused = false
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
