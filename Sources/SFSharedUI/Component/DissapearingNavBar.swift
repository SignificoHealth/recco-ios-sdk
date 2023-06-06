import SwiftUI
import SFCore

private let navHeight = 44.0
private var topbarHeight: CGFloat {
    return (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + navHeight
}

struct DissapearingNavBar: View {
    var backAction: (() -> Void)?
    var closeAction: (() -> Void)?
    var scrollOffset: CGFloat
    var threshold: CGFloat
    var title: String
    
    var navOffset: CGFloat {
        (-topbarHeight + ((scrollOffset - threshold).clamped(to: 0...topbarHeight) )).clamped(to: -topbarHeight...0)
    }
    
    var opacity: CGFloat {
        1 - abs(navOffset / topbarHeight)
    }
    
    var body: some View {
        return VStack(spacing: 0) {
            Spacer(minLength: 0)
            HStack {
                HStack {
                    if let backAction = backAction {
                        Button(action: backAction, label: {
                            Image(systemName: "chevron.left")
                        })
                    } else {
                        Text("")
                    }
                    Spacer()
                }
                .padding(.leading, .S)
                
                Text(title)
                    .h4()
                    .lineLimit(1)
                    .layoutPriority(1)
                
                HStack {
                    Spacer()
                    if let closeAction = closeAction {
                        Button(action: closeAction, label: {
                            Image(systemName: "xmark")
                        })
                    } else {
                        Text("")
                    }
                }
                .padding(.trailing, .S)
            }
            .frame(height: 44)
            .overlay(
                Rectangle()
                    .fill(Color.sfSurface)
                    .frame(height: 1),
                alignment: .bottom
            )
        }
        .frame(height: topbarHeight)
        .background(Color.sfBackground)
        .offset(x: 0, y: navOffset)
        .opacity(opacity)
        .ignoresSafeArea(.container, edges: .top)
    }
}

extension View {
    public func dissapearingNavBar(
        scrollOffset: CGFloat,
        threshold: CGFloat,
        title: String?,
        backAction: (() -> Void)? = nil,
        closeAction: (() -> Void)? = nil
    ) -> some View {
        Group {
            if let title = title {
                overlay(
                    DissapearingNavBar(
                        backAction: backAction,
                        closeAction: closeAction,
                        scrollOffset: scrollOffset,
                        threshold: threshold,
                        title: title
                    ),
                    alignment: .top
                )
            } else {
               self
            }
        }
    }
}

struct DissapearingNavBar_Previews: PreviewProvider {
    struct SomeView: View {
        @State var number: CGFloat = 0.0
        var body: some View {
            ZStack {
                Color.sfBackground
                Slider(value: $number, in: 0...500)
                    .foregroundColor(.yellow)
            }
            .background(Color.blue)
            .dissapearingNavBar(
                scrollOffset: number,
                threshold: UIScreen.main.bounds.width * 7 / 10,
                title: Optional("Very large title asdlk askdjf jalksdkja a"),
                backAction: nil,
                closeAction: {}
            )
        }
    }
    
    static var previews: some View {
        SomeView()
    }
}
