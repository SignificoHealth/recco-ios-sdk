import Foundation
import SwiftUI

private var alertAnimation: Animation {
    .easeInOut(duration: 0.3)
}

/// This view will be presented over another view, so make sure the undelying view is big enough for your alert, as it won't overflow like a real alertview
///
struct ReccoAlert<Header: View>: View {
    init(
        isPresent: Binding<Bool>,
        title: String? = nil,
        text: String? = nil,
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

    @Binding var isPresent: Bool
    @State private var offset: CGFloat = 0.0

    var title: String?
    var text: String?
    var buttonText: String
    var header: () -> Header
    var action: () -> Void

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: .M)
                    .fill(Color.reccoBackground)
                    .shadowBase(opacity: 0.2)
            )
            .offset(y: offset)
            .simultaneousGesture(dragToDismiss)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.M)
            .transition(.move(edge: .bottom))
    }

    private var dragToDismiss: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { gesture in
                guard gesture.translation.height > 0 else { return }
                //                withAnimation(.linear(duration: 0.05)) {
                offset = gesture.translation.height
                //                }
            }
            .onEnded { gesture in
                let velocityY = gesture.predictedEndLocation.y - gesture.location.y
                if offset > UIScreen.main.bounds.height * 0.15 && velocityY > 300 {
                    withAnimation(alertAnimation) {
                        $isPresent.wrappedValue = false
                    }
                } else {
                    withAnimation(alertAnimation) {
                        offset = .zero
                    }
                }
            }
    }

    private var content: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                header()
                    .frame(maxWidth: .infinity)
                    .background(Color.reccoAccent20)
                    .cornerRadius(.M, corners: [.topLeft, .topRight])

                ReccoCloseButton {
                    withAnimation(alertAnimation) {
                        $isPresent.wrappedValue = false
                    }
                }
                .padding(.horizontal, .M)
                .padding(.top, -.M)
            }

            VStack(spacing: .M) {
                if let title {
                    Text(title)
                        .h1()
                        .multilineTextAlignment(.center)
                }

                if let text {
                    Text(text)
                        .body2()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                ReccoButtonView(
                    text: buttonText,
                    action: action
                )
            }
            .padding(.horizontal, .M)
            .padding(.top, .M)
            .padding(.bottom, .L)
        }
    }
}

extension View {
    func reccoAlert<Wrapped, Header: View>(
        showWhenPresent: Binding<Wrapped?>,
        body: (Wrapped) -> ReccoAlert<Header>
    ) -> some View {
        ZStack {
            self
                .allowsHitTesting(
                    !showWhenPresent.isPresent().wrappedValue
                )

            ZStack {
                if let value = showWhenPresent.wrappedValue {
                    body(value)
                }
            }
        }
    }
}
