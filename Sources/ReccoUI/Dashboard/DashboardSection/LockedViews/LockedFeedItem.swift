import SwiftUI

struct LockedFeedItem: View {
    var unlocking: Bool
    var imageName: String
    
    private var lockIcon: String {
        unlocking ? "unlocked_ic" : "locked_ic"
    }
    
    var body: some View {
        ZStack {
            Image(resource: imageName)
                .resizable()
                .blur(radius: 10)
            
            VStack(spacing: .XXS) {
                Image(resource: lockIcon)
                    .foregroundColor(.reccoPrimary)
                
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
                .fill(Color.reccoBackground)
        )
    }
}
