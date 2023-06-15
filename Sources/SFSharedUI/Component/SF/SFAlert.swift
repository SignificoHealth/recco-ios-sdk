import Foundation
import SwiftUI

private var alertAnimation: Animation {
    .easeInOut(duration: 0.3)
}

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
    @State private var offset: CGFloat = 0.0
    
    public var title: String
    public var text: String?
    public var buttonText: String
    public var header: () -> Header
    public var action: () -> Void
    
    public var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: .M)
                    .fill(Color.sfBackground)
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
                withAnimation(.interactiveSpring()) {
                    offset = gesture.translation.height
                }
            }
            .onEnded { gesture in
                let velocityY = gesture.predictedEndLocation.y - gesture.location.y
                if offset > UIScreen.main.bounds.height * 0.15 && velocityY > 500 {
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
                    .background(Color.sfAccent20)
                    .cornerRadius(.M, corners: [.topLeft, .topRight])
                
                SFCloseButton {
                    $isPresent.wrappedValue = false
                }
                .padding(.horizontal, .M)
                .padding(.top, -.M)
            }
            
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
        ZStack {
            self
                .allowsHitTesting(
                    !isPresent.wrappedValue
                )
                        
            ZStack {
                if isPresent.wrappedValue {
                    SFAlert(
                        isPresent: isPresent,
                        title: title,
                        text: text,
                        buttonText: buttonText,
                        header: header,
                        action: action
                    )
                }
            }
            .animation(alertAnimation, value: isPresent.wrappedValue)
        }
    }
    
    public func sfAlert<Wrapped, Header: View>(
        showWhenPresent: Binding<Wrapped?>,
        body: (Wrapped) -> SFAlert<Header>
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
            .animation(alertAnimation, value: showWhenPresent.isPresent().wrappedValue)
        }
    }
}

struct SFAlert_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var isPresent: Bool = false
        
        var body: some View {
            ZStack {
                Color.gray
                
                Button("show") {
                    isPresent = true
                }
            }
            .sfAlert(
                isPresent: $isPresent,
                title: "Hola",
                text: "ASLKDJHFALK ALKSDFLKAJHS DFH ALKSJDH FLKAJHSDLFKJHALSKDJFH ",
                buttonText: "Accept",
                header: {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                },
                action: {}
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
