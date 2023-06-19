import SFSharedUI
import SwiftUI

struct LoadingItemView: View {
    var body: some View {
        Rectangle()
            .fill(Color.sfPrimary20)
            .frame(width: .cardSize.width, height: .cardSize.height)
            .overlay(
                Text("loading placeholder")
                    .body3()
                    .frame(maxWidth: .infinity)
                    .padding(.XXS)
                    .multilineTextAlignment(.center)
                    .background(Color.sfBackground),
                alignment: .bottom
            )
            .background(
                Color.sfBackground
            )
            .clipShape(
                RoundedRectangle(cornerRadius: .XXS)
            )
    }
}
