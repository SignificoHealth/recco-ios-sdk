import SwiftUI
import SFSharedUI

struct LoadingSectionView: View {
    @State private var numberOfItems = 5
    
    var body: some View {
        // Empty axes allows us to create scrollview with no scrolling
        ScrollView([]) {
            HStack(spacing: .XXS) {
                ForEach(0...numberOfItems, id: \.self) { _ in
                    LoadingItemView()
                }
            }
            .padding(.horizontal, .M)
        }
        .overlay(
            GeometryReader { proxy in
                Color.clear.onAppear {
                    numberOfItems = Int(proxy.size.width / .cardSize.width)
                }
            }
        )
        .frame(height: .cardSize.height)
        .redacted(reason: .placeholder)
        .shimmer(true)
    }
}

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
