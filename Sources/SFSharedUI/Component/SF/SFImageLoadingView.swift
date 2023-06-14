
import SwiftUI

public struct SFImageLoadingView: View {
    public var feedItem: Bool
    
    public init(feedItem: Bool) {
        self.feedItem = feedItem
    }
        
    private let timer = Timer.publish(
        every: 0.5,
        on: .main,
        in: .common
    ).autoconnect()
    
    @State private var counter: Double = Double(Int.random(in: 1...3))
    
    private var currentImage: String {
        let imageNumber = Int(counter.remainder(dividingBy: 3)) + 2
        return "locked_bg_\(feedItem  ? "item_" : "")\(imageNumber)"
    }
    
    public var body: some View {
        Image(resource: currentImage)
            .id(currentImage)
            .blur(radius: 10)
            .transition(.opacity.animation(.default))
            .onReceive(timer) { _ in
                withAnimation(.linear(duration: 0.5)) {
                    counter += 1.0
                }
            }
    }
}

struct ImageLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        // does not correctly animate in previews if there is no container
        VStack {
            SFImageLoadingView(feedItem: false)
            SFImageLoadingView(feedItem: true)
        }
    }
}
