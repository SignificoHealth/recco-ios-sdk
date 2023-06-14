import Foundation
import SwiftUI

/// This view will be presented over another view, so make sure the undelying view is big enough for your alert, as it won't overflow like a real alertview
///
public struct SFAlert<Header: View>: View {
    public init(
        isPresent: Binding<Bool>,
        title: String,
        text: String?,
        buttonText: String,
        @ViewBuilder header: @escaping () -> Header,
        action: @escaping () -> Void
    ) {
        self._isPresent = isPresent
        self.text = text
        self.title = title
        self.buttonText = buttonText
        self.header = header
        self.action = action
    }
    
    @Binding public var isPresent: Bool
    public var title: String
    public var text: String?
    public var buttonText: String
    public var header: () -> Header
    public var action: () -> Void
    
    public var body: some View {
        ZStack {
            Spacer()
            VStack(spacing: 0) {
                header()
                    .frame(maxWidth: .infinity)
                    .background(Color.sfAccent20)
                
                VStack(spacing: .M) {
                    Text(title)
                        .h1()
                        .multilineTextAlignment(.center)
                    
                    if let text {
                        Text(text)
                            .body2()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    SFButton(
                        action: action,
                        text: buttonText
                    )
                }
                .padding(.horizontal, .M)
                .padding(.top, .M)
                .padding(.bottom, .L)
            }
            .overlay(
                SFCloseButton {
                    $isPresent.wrappedValue = false
                }
                .padding(.horizontal, .M)
                .padding(.top, -.M),
                alignment: .topTrailing
            )
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: .M)
                .fill(Color.sfBackground)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, .M)
        .background(
            Color.sfPrimary.opacity(0.6).ignoresSafeArea(edges: .all)
        )
    }
}

extension View {
    public func sfAlert<Header: View>(
        isPresent: Binding<Bool>,
        title: String,
        text: String?,
        buttonText: String,
        header: @escaping () -> Header,
        action: @escaping () -> Void
    ) -> some View {
        Group {
            if isPresent.wrappedValue {
                overlay(
                    SFAlert(
                        isPresent: isPresent,
                        title: title,
                        text: text,
                        buttonText: buttonText,
                        header: header,
                        action: action
                    )
                )
            } else {
                self
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: isPresent.wrappedValue)
    }
    
    public func sfAlert<Wrapped, Header: View>(
        showWhenPresent: Binding<Wrapped?>,
        body: (Wrapped) -> SFAlert<Header>
    ) -> some View {
        ZStack {
            self

            ZStack {
                if let value = showWhenPresent.wrappedValue {
                    body(value)
                }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.2), value: showWhenPresent.isPresent().wrappedValue)
        }
    }
}

struct SFAlert_Previews: PreviewProvider {
    static var previews: some View {
        SFAlert(
            isPresent: .constant(true),
            title: "Hola",
            text: "Hey this is Chema, shorthaired now (sorry ladies)",
            buttonText: "Continue",
            header: { Image(systemName: "photo.fill") },
            action: {}
        )
    }
}
