import SwiftUI

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
    }
}
