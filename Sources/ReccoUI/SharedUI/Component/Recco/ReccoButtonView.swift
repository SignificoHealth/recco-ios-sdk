import Foundation
import SwiftUI

struct ReccoButtonView: View {
    enum Style {
        case primary
        case secondary
        case borderless
        case mini
    }
    
    @Environment(\.isEnabled) var isEnabled
    
    var leadingImage: Image?
    var trailingImage: Image?
    var text: String?
    var action: () -> Void
    var isLoading: Bool
    var style: ReccoButtonView.Style
    
    init(
        style: ReccoButtonView.Style = .primary,
        text: String? = nil,
        leadingImage: Image? = nil,
        trailingImage: Image? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.leadingImage = leadingImage
        self.trailingImage = trailingImage
        self.text = text
        self.action = action
        self.isLoading = isLoading
        self.style = style
    }
    
    var backgroundColor: Color {
        switch (style, isEnabled) {
        case (.primary, true), (.mini, true):
            return .reccoPrimary
            
        case (.primary, false), (.mini, false):
            return .reccoPrimary20
            
        case (.secondary, _), (.borderless, _):
            return .reccoBackground
        }
    }
    
    var accentColor: Color {
        switch (style, isEnabled) {
        case (.primary, true), (.mini, true), (.primary, false), (.mini, false):
            return .reccoOnPrimary
            
        case (.secondary, true), (.borderless, true):
            return .reccoPrimary
            
        case (.secondary, false), (.borderless, false):
            return .reccoPrimary40
        }
    }
    
    @ViewBuilder
    var background: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: .XXXS)
                .fill(backgroundColor)
        case .secondary:
            RoundedRectangle(cornerRadius: .XXXS)
                .stroke()
                .fill(accentColor)
        case .borderless:
            RoundedRectangle(cornerRadius: .XXXS)
                .fill(backgroundColor)
        case .mini:
            RoundedRectangle(cornerRadius: .L)
                .fill(backgroundColor)
        }
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                background
                    .layoutPriority(-1)
                
                HStack(spacing: style == .mini ? .XXXS : .XS) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                    } else {
                        leadingImage?.renderingMode(.template).foregroundColor(accentColor)
                        if style != .mini {
                            text.map { Text($0) }?
                                .foregroundColor(accentColor)
                                .cta()
                        } else {
                            text.map { Text($0) }?
                                .foregroundColor(accentColor)
                                .labelSmall()
                        }
                        
                        trailingImage?.renderingMode(.template).foregroundColor(accentColor)
                    }
                }
                .padding(.vertical, style == .mini ? .XXS : .XS)
                .padding(.horizontal, style == .mini ? .M : .S)
                .frame(maxWidth: style == .mini ? nil : .infinity)
                .frame(height: 48)
            }
        }
    }
}

struct HCButtonPrimary_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: .M) {
                ForEach([ReccoButtonView.Style.primary, .secondary, .borderless, .mini], id: \.self) { style in
                    ForEach([true, false], id: \.self) { enabled in
                        ReccoButtonView(
                            style: style,
                            text: "Hi man",
                            leadingImage: Image(systemName: "plus"),
                            isLoading: .random(),
                            action: {}
                        )
                        .disabled(!enabled)
                    }
                }
            }
            .padding()
        }
    }
}
