import Foundation
import SwiftUI

extension View {
    public func shadowBase(opacity: CGFloat = 0.05) -> some View {
        shadow(color: .sfOnBackground.opacity(opacity), radius: 5, y: 4)
    }
}
