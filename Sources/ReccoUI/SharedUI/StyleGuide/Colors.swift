import Foundation
import SwiftUI

// MARK: Main

extension UIColor {
	static var reccoPrimary: UIColor {
		CurrentReccoStyle.color.primary.uiColor
	}

	static var reccoAccent: UIColor {
		CurrentReccoStyle.color.accent.uiColor
	}

	static var reccoBackground: UIColor { CurrentReccoStyle.color.background.uiColor
	}

	static var reccoIllustration: UIColor { CurrentReccoStyle.color.illustration.uiColor
	}

	static var reccoOnAccent: UIColor { CurrentReccoStyle.color.onAccent.uiColor
	}

	static var reccoOnBackground: UIColor { CurrentReccoStyle.color.onBackground.uiColor
	}

	static var reccoOnPrimary: UIColor { CurrentReccoStyle.color.onPrimary.uiColor
	}

	static var reccoIllustrationLine: UIColor { CurrentReccoStyle.color.illustrationLine.uiColor
	}

	static let reccoLightGray: UIColor = .init(resource: "sfLightGray")!
	static let reccoWhite: UIColor = .init(resource: "sfWhite")!
	static let reccoStaticDark: UIColor = .init(resource: "sfStaticDark")!
}

extension Color {
	static var reccoPrimary: Color { .init(.reccoPrimary) }
	static var reccoAccent: Color { .init(.reccoAccent) }
	static var reccoBackground: Color { .init(.reccoBackground) }
	static var reccoIllustration: Color { .init(.reccoIllustration) }
	static var reccoOnAccent: Color { .init(.reccoOnAccent) }
	static var reccoOnBackground: Color { .init(.reccoOnBackground) }
	static var reccoOnPrimary: Color { .init(.reccoOnPrimary) }
	static var reccoIllustrationLine: Color { .init(.reccoIllustrationLine) }
	static var reccoWhite: Color { .init(.reccoWhite) }
	static var reccoStaticDark: Color { .init(.reccoStaticDark) }
	static var reccoLightGray: Color { .init(.reccoLightGray) }
}

// MARK: Derivation

extension UIColor {
	static var reccoIllustration80: UIColor {
		.reccoIllustration.withAlphaComponent(0.8)
	}

	static var reccoIllustration40: UIColor {
		.reccoIllustration.withAlphaComponent(0.4)
	}

	static var reccoPrimary10: UIColor {
		.reccoPrimary.withAlphaComponent(0.1)
	}

	static var reccoPrimary20: UIColor {
		.reccoPrimary.withAlphaComponent(0.2)
	}

	static var reccoPrimary40: UIColor {
		.reccoPrimary.withAlphaComponent(0.4)
	}

	static var reccoPrimary60: UIColor {
		.reccoPrimary.withAlphaComponent(0.6)
	}

	static var reccoPrimary80: UIColor {
		.reccoPrimary.withAlphaComponent(0.8)
	}

	static var reccoOnBackground60: UIColor { UIColor.reccoOnBackground.withAlphaComponent(0.6)
	}

	static var reccoOnBackground20: UIColor { UIColor.reccoOnBackground.withAlphaComponent(0.2)
	}

	static var reccoAccent10: UIColor { UIColor.reccoAccent.withAlphaComponent(0.1)
	}

	static var reccoAccent20: UIColor { UIColor.reccoAccent.withAlphaComponent(0.2)
	}

	static var reccoAccent40: UIColor { UIColor.reccoAccent.withAlphaComponent(0.4)
	}

	static var reccoAccent60: UIColor { UIColor.reccoAccent.withAlphaComponent(0.6)
	}

	static var reccoStaticDark60: UIColor { UIColor.reccoStaticDark.withAlphaComponent(0.6)
	}
}

extension Color {
	static var reccoIllustration80: Color { Color(.reccoIllustration80)
	}

	static var reccoIllustration40: Color { Color(.reccoIllustration40)
	}

	static var reccoPrimary10: Color { Color(.reccoPrimary10)
	}

	static var reccoPrimary20: Color { Color(.reccoPrimary20)
	}

	static var reccoPrimary40: Color { Color(.reccoPrimary40)
	}

	static var reccoPrimary60: Color { Color(.reccoPrimary60)
	}

	static var reccoPrimary80: Color { Color(.reccoPrimary80)
	}

	static var reccoOnBackground60: Color { Color(.reccoOnBackground60)
	}

	static var reccoOnBackground20: Color { Color(.reccoOnBackground20)
	}

	static var reccoAccent10: Color { Color(.reccoAccent10)
	}

	static var reccoAccent20: Color { Color(.reccoAccent20)
	}

	static var reccoAccent40: Color { Color(.reccoAccent40)
	}

	static var reccoAccent60: Color { Color(.reccoAccent60)
	}

	static var reccoStaticDark60: Color { Color(.reccoStaticDark60)
	}
}

struct ColorsName_Previews: PreviewProvider {
	static var previews: some View {
		ScrollView {
			VStack {
				ForEach([
					Color.reccoPrimary,
					.reccoPrimary10,
					.reccoPrimary20,
					.reccoPrimary40,
					.reccoPrimary60,
					.reccoPrimary80,
					.reccoAccent,
					.reccoAccent10,
					.reccoAccent20,
					.reccoAccent40,
					.reccoAccent60,
					.reccoLightGray,
					.reccoBackground,
					.reccoIllustration,
					.reccoOnAccent,
					.reccoOnPrimary,
					.reccoIllustrationLine,
					.reccoOnBackground,
					.reccoOnBackground20,
					.reccoOnBackground60,
					.reccoStaticDark,
					.reccoStaticDark60,
				], id: \.self) { color in
					Rectangle()
						.fill(color)
						.frame(width: 20, height: 20)
						.border(Color.black)
				}
			}
		}
		.background(Color.red)
		.padding()
	}
}
