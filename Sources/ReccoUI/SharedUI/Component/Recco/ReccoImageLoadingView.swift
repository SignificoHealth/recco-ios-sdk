import Combine
import SwiftUI

struct ReccoImageLoadingView: View {
    var feedItem: Bool
    
    init(feedItem: Bool) {
        self.feedItem = feedItem
    }
    
    var body: some View {
        Color.reccoPrimary20
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
