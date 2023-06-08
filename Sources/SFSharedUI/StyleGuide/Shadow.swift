import Foundation
import SwiftUI

extension View {
    public func shadowBase() -> some View {
        shadow(color: .sfOnBackground.opacity(0.05), radius: 5, y: 4)
    }
}
