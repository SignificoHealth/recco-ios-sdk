//
//  File.swift
//  
//
//  Created by Adrián R on 8/6/23.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    fileprivate func htmlText(
        color: UIColor = .sfPrimary,
        reference: UIFont = .systemFont(ofSize: 15),
        completion: @escaping (NSAttributedString) -> Void
    ) {
        DispatchQueue.global().async {
            guard let attString = try? NSMutableAttributedString(
                data: self.data(using: .unicode, allowLossyConversion: true)!,
                options: [.documentType : NSAttributedString.DocumentType.html],
                documentAttributes: nil
            ) else { completion(NSMutableAttributedString(string: self)); return }

            attString.enumerateAttribute(
                .font,
                in: .init(location: 0, length: attString.length),
                options: []
            ) { font, range, bool in
                if let oldFont = font as? UIFont,
                   let descriptor = reference.fontDescriptor.withSymbolicTraits(oldFont.fontDescriptor.symbolicTraits) {
                    let newFont = UIFont(descriptor: descriptor, size: max(15, oldFont.pointSize))
                    attString.removeAttribute(.font, range: range)
                    attString.addAttribute(.font, value: newFont, range: range)
                    attString.addAttribute(.foregroundColor, value: color, range: range)
                }
            }
            
            DispatchQueue.main.async {
                completion(attString)
            }
        }
    }
}

// https://gist.github.com/shaps80/8a3170160f80cfdc6e8179fa0f5e1621
// We dont need every line of this view, so we can trim it in the future.

public struct HTMLTextView: View {
    @Environment(\.layoutDirection) private var layoutDirection
    private var htmlText: String
    @State private var calculatedHeight: CGFloat = 44
    @State private var isEmpty: Bool = false
    
    private var placeholderFont: SwiftUI.Font = .body
    private var placeholderAlignment: TextAlignment = .leading
    private var foregroundColor: UIColor = .label
    private var autocapitalization: UITextAutocapitalizationType = .sentences
    private var multilineTextAlignment: NSTextAlignment = .left
    private var font: UIFont = .preferredFont(forTextStyle: .body)
    private var returnKeyType: UIReturnKeyType?
    private var clearsOnInsertion: Bool = false
    private var autocorrection: UITextAutocorrectionType = .default
    private var truncationMode: NSLineBreakMode = .byTruncatingTail
    private var isSecure: Bool = false
    private var isEditable: Bool = true
    private var isSelectable: Bool = true
    private var enablesReturnKeyAutomatically: Bool?
    private var autoDetectionTypes: UIDataDetectorTypes = []
    private var didInteractWithUrl: ((URL) -> Void)?
    
    public init(text: String, didInteractWithUrl: ((URL) -> Void)? = nil) {
        self.didInteractWithUrl = didInteractWithUrl
        htmlText = text
        _isEmpty = State(initialValue: self.htmlText.isEmpty)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            SwiftUITextView(
                htmlText,
                foregroundColor: foregroundColor,
                font: font,
                multilineTextAlignment: multilineTextAlignment,
                autocapitalization: autocapitalization,
                returnKeyType: returnKeyType,
                clearsOnInsertion: clearsOnInsertion,
                autocorrection: autocorrection,
                truncationMode: truncationMode,
                isSecure: isSecure,
                isEditable: isEditable,
                isSelectable: isSelectable,
                enablesReturnKeyAutomatically: enablesReturnKeyAutomatically,
                autoDetectionTypes: autoDetectionTypes,
                calculatedHeight: $calculatedHeight,
                didInteractWithUrl: didInteractWithUrl,
                height: $calculatedHeight,
                width: proxy.size.width
            )
        }
        .frame(height: calculatedHeight)
    }
}

public extension HTMLTextView {
    func autoDetectDataTypes(_ types: UIDataDetectorTypes) -> HTMLTextView {
        var view = self
        view.autoDetectionTypes = types
        return view
    }
    
    func foregroundColor(_ color: UIColor) -> HTMLTextView {
        var view = self
        view.foregroundColor = color
        return view
    }
    
    func autocapitalization(_ style: UITextAutocapitalizationType) -> HTMLTextView {
        var view = self
        view.autocapitalization = style
        return view
    }
    
    func multilineTextAlignment(_ alignment: TextAlignment) -> HTMLTextView {
        var view = self
        view.placeholderAlignment = alignment
        switch alignment {
        case .leading:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            view.multilineTextAlignment = layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            view.multilineTextAlignment = .center
        }
        return view
    }
    
    func font(_ font: UIFont) -> HTMLTextView {
        var view = self
        view.font = font
        return view
    }
    
    func clearOnInsertion(_ value: Bool) -> HTMLTextView {
        var view = self
        view.clearsOnInsertion = value
        return view
    }
    
    func disableAutocorrection(_ disable: Bool?) -> HTMLTextView {
        var view = self
        if let disable = disable {
            view.autocorrection = disable ? .no : .yes
        } else {
            view.autocorrection = .default
        }
        return view
    }
    
    func isEditable(_ isEditable: Bool) -> HTMLTextView {
        var view = self
        view.isEditable = isEditable
        return view
    }
    
    func isSelectable(_ isSelectable: Bool) -> HTMLTextView {
        var view = self
        view.isSelectable = isSelectable
        return view
    }
    
    func returnKey(_ style: UIReturnKeyType?) -> HTMLTextView {
        var view = self
        view.returnKeyType = style
        return view
    }
    
    func automaticallyEnablesReturn(_ value: Bool?) -> HTMLTextView {
        var view = self
        view.enablesReturnKeyAutomatically = value
        return view
    }
    
    func truncationMode(_ mode: Text.TruncationMode) -> HTMLTextView {
        var view = self
        switch mode {
        case .head: view.truncationMode = .byTruncatingHead
        case .tail: view.truncationMode = .byTruncatingTail
        case .middle: view.truncationMode = .byTruncatingMiddle
        @unknown default:
            fatalError("Unknown text truncation mode")
        }
        return view
    }
    
}

private struct SwiftUITextView: UIViewRepresentable {
    @Binding var height: CGFloat
    private var width: CGFloat
    private var text: String
    private let foregroundColor: UIColor
    private let autocapitalization: UITextAutocapitalizationType
    private let multilineTextAlignment: NSTextAlignment
    private let font: UIFont
    private let returnKeyType: UIReturnKeyType?
    private let clearsOnInsertion: Bool
    private let autocorrection: UITextAutocorrectionType
    private let truncationMode: NSLineBreakMode
    private let isSecure: Bool
    private let isEditable: Bool
    private let isSelectable: Bool
    private let enablesReturnKeyAutomatically: Bool?
    private var autoDetectionTypes: UIDataDetectorTypes = []
    private var didInteractWithUrl: ((URL) -> Void)?

    init(_ text: String,
         foregroundColor: UIColor,
         font: UIFont,
         multilineTextAlignment: NSTextAlignment,
         autocapitalization: UITextAutocapitalizationType,
         returnKeyType: UIReturnKeyType?,
         clearsOnInsertion: Bool,
         autocorrection: UITextAutocorrectionType,
         truncationMode: NSLineBreakMode,
         isSecure: Bool,
         isEditable: Bool,
         isSelectable: Bool,
         enablesReturnKeyAutomatically: Bool?,
         autoDetectionTypes: UIDataDetectorTypes,
         calculatedHeight: Binding<CGFloat>,
         didInteractWithUrl: ((URL) -> Void)?,
         height: Binding<CGFloat>,
         width: CGFloat
    ) {
        self.text = text
        self.foregroundColor = foregroundColor
        self.font = font
        self.multilineTextAlignment = multilineTextAlignment
        self.autocapitalization = autocapitalization
        self.returnKeyType = returnKeyType
        self.clearsOnInsertion = clearsOnInsertion
        self.autocorrection = autocorrection
        self.truncationMode = truncationMode
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        self.autoDetectionTypes = autoDetectionTypes
        self.didInteractWithUrl = didInteractWithUrl
        self._height = height
        self.width = width
    }
    
    func makeUIView(context: Context) -> UIKitTextView {
        let view = UIKitTextView()
        view.delegate = view
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        view.backgroundColor = UIColor.clear
        view.adjustsFontForContentSizeCategory = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.font = font
        view.textAlignment = multilineTextAlignment
        view.textColor = foregroundColor
        view.autocapitalizationType = autocapitalization
        view.autocorrectionType = autocorrection
        view.isEditable = isEditable
        view.isSelectable = isSelectable
        view.isScrollEnabled = false
        view.tintColor = .sfPrimary
        view.dataDetectorTypes = autoDetectionTypes
        view.didInteractWithUrl = didInteractWithUrl
        
        return view
    }
    
    func updateUIView(_ view: UIKitTextView, context: Context) {
        text.htmlText { string in
            view.attributedText = string
            
            SwiftUITextView.recalculateHeight(view: view, result: $height, maxWidth: width)
        }
    }
    
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>, maxWidth: CGFloat) {
        let newSize = view.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        guard result.wrappedValue != newSize.height else { return }
        
        DispatchQueue.main.async { // call in next render cycle.
            result.wrappedValue = newSize.height
        }
    }
    
}

private final class UIKitTextView: UITextView, UITextViewDelegate {
    var didInteractWithUrl: ((URL) -> Void)?
    
    override var keyCommands: [UIKeyCommand]? {
        return (super.keyCommands ?? []) + [
            UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape(_:)))
        ]
    }
    
    @objc private func escape(_ sender: Any) {
        resignFirstResponder()
    }
    
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        didInteractWithUrl?(URL)
        return true
    }
}
