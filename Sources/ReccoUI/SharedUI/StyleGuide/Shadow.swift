import Foundation
import SwiftUI

extension View {
    func shadowBase(opacity: CGFloat = 0.05) -> some View {
        shadow(color: .reccoOnBackground.opacity(opacity), radius: 5, y: 4)
    }
}
