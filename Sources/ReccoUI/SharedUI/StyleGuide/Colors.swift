import Foundation
import SwiftUI

// MARK: Main

extension UIColor {
    static let reccoPrimary: UIColor = .init(resource: "sfPrimary")!
    static let reccoAccent: UIColor = .init(resource: "sfAccent")!
    static let reccoBackground: UIColor = .init(resource: "sfBackground")!
    static let reccoIllustration: UIColor = .init(resource: "sfIllustration")!
    static let reccoOnAccent: UIColor = .init(resource: "sfOnAccent")!
    static let reccoOnBackground: UIColor = .init(resource: "sfOnBackground")!
    static let reccoOnPrimary: UIColor = .init(resource: "sfOnPrimary")!
    static let reccoIllustrationLine: UIColor = .init(resource: "sfIllustrationLine")!
    static let reccoLightGray: UIColor = .init(resource: "sfLightGray")!
}

extension Color {
    static let reccoPrimary: Color = .init(.reccoPrimary)
    static let reccoAccent: Color = .init(.reccoAccent)
    static let reccoBackground: Color = .init(.reccoBackground)
    static let reccoIllustration: Color = .init(.reccoIllustration)
    static let reccoOnAccent: Color = .init(.reccoOnAccent)
    static let reccoOnBackground: Color = .init(.reccoOnBackground)
    static let reccoOnPrimary: Color = .init(.reccoOnPrimary)
    static let reccoIllustrationLine: Color = .init(.reccoIllustrationLine)
    static let reccoLightGray: Color = .init(.reccoLightGray)
}

// MARK: Derivation

extension UIColor {
    static var reccoIllustration80: UIColor =
        .reccoIllustration.withAlphaComponent(0.8)
    static var reccoIllustration40: UIColor =
        .reccoIllustration.withAlphaComponent(0.4)
    static var reccoPrimary10: UIColor =
        .reccoPrimary.withAlphaComponent(0.1)
    static var reccoPrimary20: UIColor =
        .reccoPrimary.withAlphaComponent(0.2)
    static var reccoPrimary40: UIColor =
        .reccoPrimary.withAlphaComponent(0.4)
    static var reccoPrimary60: UIColor =
        .reccoPrimary.withAlphaComponent(0.6)
    static let reccoPrimary80: UIColor =
        .reccoPrimary.withAlphaComponent(0.8)
    static let reccoOnBackground60 = UIColor.reccoOnBackground.withAlphaComponent(0.6)
    static let reccoOnBackground20 = UIColor.reccoOnBackground.withAlphaComponent(0.2)
    static let reccoAccent10 = UIColor.reccoAccent.withAlphaComponent(0.1)
    static let reccoAccent20 = UIColor.reccoAccent.withAlphaComponent(0.2)
    static let reccoAccent40 = UIColor.reccoAccent.withAlphaComponent(0.4)
    static let reccoAccent60 = UIColor.reccoAccent.withAlphaComponent(0.6)
}

extension Color {
    static var reccoIllustration80: Color = Color(.reccoIllustration80)
    static var reccoIllustration40: Color = Color(.reccoIllustration40)
    static let reccoPrimary10: Color = Color(.reccoPrimary10)
    static let reccoPrimary20: Color = Color(.reccoPrimary20)
    static let reccoPrimary40: Color = Color(.reccoPrimary40)
    static let reccoPrimary60: Color = Color(.reccoPrimary60)
    static let reccoPrimary80: Color = Color(.reccoPrimary80)
    static let reccoOnBackground60 = Color(.reccoOnBackground60)
    static let reccoOnBackground20 = Color(.reccoOnBackground20)
    static let reccoAccent10 = Color(.reccoAccent10)
    static let reccoAccent20 = Color(.reccoAccent20)
    static let reccoAccent40 = Color(.reccoAccent40)
    static let reccoAccent60 = Color(.reccoAccent60)
}

struct ColorsName_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ForEach([Color.reccoPrimary, .reccoPrimary10, .reccoPrimary20, .reccoPrimary40, .reccoPrimary60, .reccoPrimary80, .reccoAccent, .reccoAccent10, .reccoAccent20, .reccoAccent40, .reccoAccent60, .reccoLightGray, .reccoBackground, .reccoIllustration, .reccoOnAccent, .reccoOnPrimary, .reccoIllustrationLine, .reccoOnBackground, .reccoOnBackground20, .reccoOnBackground60], id: \.self) { color in
                        Rectangle()
                            .fill(color)
                            .frame(width: 20, height: 20)
                            .border(Color.black)
                }
                
            }
        }
        .padding()
    }
}
