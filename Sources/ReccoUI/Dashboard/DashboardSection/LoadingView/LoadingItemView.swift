import SwiftUI

struct LoadingItemView: View {
    var body: some View {
        Rectangle()
            .fill(Color.reccoPrimary20)
            .frame(width: .cardSize.width, height: .cardSize.height)
            .overlay(
                Text("loading placeholder")
                    .body3()
                    .frame(maxWidth: .infinity)
                    .padding(.XXS)
                    .multilineTextAlignment(.center)
                    .background(Color.reccoBackground),
                alignment: .bottom
            )
            .background(
                Color.reccoBackground
            )
            .clipShape(
                RoundedRectangle(cornerRadius: .XXS)
            )
    }
}
