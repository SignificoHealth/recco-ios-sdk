import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func addCloseSDKToNavbar(_ dismissAction: @escaping () -> Void) -> some View {
        toolbar {
            ToolbarItem {
                Button {
                    dismissAction()
                } label: {
                    Image(resource: "close_ic")
                        .renderingMode(.template)
                        .foregroundColor(.reccoPrimary)
                }
            }
        }
    }

    func addBlackOpacityOverlay() -> some View {
        ZStack {
            self

            LinearGradient(
                colors: [.black.opacity(0.6), .clear, .clear], startPoint: .top, endPoint: .bottom
            )
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
