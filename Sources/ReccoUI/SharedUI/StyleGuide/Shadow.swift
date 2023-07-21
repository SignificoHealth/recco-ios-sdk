import Foundation
import SwiftUI

extension View {
    func shadowBase(opacity: CGFloat = 0.08) -> some View {
        shadow(color: .black.opacity(opacity), radius: 5, y: 4)
    }
}
