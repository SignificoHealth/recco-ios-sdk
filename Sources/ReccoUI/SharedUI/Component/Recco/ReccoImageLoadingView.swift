import Combine
import SwiftUI

struct ReccoImageLoadingView: View {
    var feedItem: Bool
    init(feedItem: Bool) {
        self.feedItem = feedItem
        self.timer = Timer.publish(
            every: frequency,
            on: .main,
            in: .common
        ).autoconnect()
    }
        
    private let frequency: Double = Double.random(in: 0.4...1)
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    @State private var counter: Double = Double(Int.random(in: 1...7))

    private var currentImage: String {
        let imageNumber = Int(counter.remainder(dividingBy: 7)) + 4
        return "locked_bg_\(feedItem  ? "item_" : "")\(imageNumber)"
    }
    
    var body: some View {
        Image(resource: currentImage)
            .id(currentImage)
            .blur(radius: 15)
            .transition(.opacity.animation(.default))
            .onReceive(timer) { _ in
                withAnimation(.linear(duration: frequency)) {
                    counter += 1.0
                }
            }
    }
}

struct ReccoImageLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        // does not correctly animate in previews if there is no container
        VStack {
            ReccoImageLoadingView(feedItem: false)
            ReccoImageLoadingView(feedItem: true)
        }
    }
}
