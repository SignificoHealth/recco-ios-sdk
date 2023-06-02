import Foundation
import SwiftUI

extension View {
    public func shadowBase() -> some View {
        shadow(color: .black.opacity(0.1), radius: 20, y: 4)
    }
}
