import SwiftUI
import SFSharedUI

struct LockedSectionView: View {
    @State private var numberOfItems = 5
    
    var body: some View {
        // Empty axes allows us to create scrollview with no scrolling
        ScrollView([]) {
            HStack(spacing: .XXS) {
                ForEach(1..<numberOfItems, id: \.self) { _ in
                    LockedFeedItem()
                }
            }
            .padding(.horizontal, .M)
            .overlay(
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        numberOfItems = max(numberOfItems, Int(proxy.size.width / .cardSize.width))
                    }
                }
            )
        }
        .frame(height: .cardSize.height)
    }
}

struct LockedFeedItem: View {
    var body: some View {
        ZStack {
            Image(resource: "locked_bg_item_\(Int.random(in: (1...3)))")
                .resizable()
            
            VStack(spacing: .XXS) {
                Image(resource: "locked_ic")
                Text("dashboard.unlock".localized)
                    .h3()
            }
            
        }
        .frame(width: .cardSize.width)
        .clipShape(
            RoundedRectangle(cornerRadius: .XXS)
        )
        .background(
            RoundedRectangle(cornerRadius: .XXS)
                .fill(Color.sfBackground)
        )
    }
}
